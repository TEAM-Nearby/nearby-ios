//
//  CTARequestState.swift
//  Nearby
//
//  Created by soomin on 10/13/26.
//

import Combine
import Foundation

@MainActor
final class CTARequestState {

    // MARK: - State

    enum State: Equatable {
        case idle
        case waiting
        case loading(String)
        case networkLoading
        case connectionFailure
    }

    // MARK: - Properties

    let state = CurrentValueSubject<State, Never>(.idle)
    private var startedAt: TimeInterval = 0
    private var minimumDuration: TimeInterval = 0
    private var revealTask: Task<Void, Never>?
    private var isActive = false
    private var isCancelled = false
    private var cancelOperation: (() -> Void)?
    private let delay: TimeInterval
    private let timeout: TimeInterval
    private var elapsed: TimeInterval { ProcessInfo.processInfo.systemUptime - startedAt }

    // MARK: - Initializer

    init(delay: TimeInterval = 0.5, timeout: TimeInterval = 10) {
        self.delay = delay
        self.timeout = timeout
    }

    // MARK: - Methods

    private func wait(seconds: TimeInterval) async throws {
        let task = Task { try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000)) }
        cancelOperation = { task.cancel() }
        defer { cancelOperation = nil }
        try await withTaskCancellationHandler {
            try await task.value
        } onCancel: {
            task.cancel()
        }
    }

    private static func isConnectionError(_ error: Error) -> Bool {
        if let error = error as? NetworkError { return error == .networkFail || error == .timeout }
        guard let error = error as? URLError else { return false }
        return [.notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotConnectToHost,
                .cannotFindHost, .dnsLookupFailed, .dataNotAllowed].contains(error.code)
    }
    
    func begin(message: String = "잠시만 기다려주세요", minimumDuration: TimeInterval = 0) -> Bool {
        guard !isActive, state.value == .idle else { return false }
        isActive = true
        isCancelled = false
        startedAt = ProcessInfo.processInfo.systemUptime
        self.minimumDuration = minimumDuration
        state.send(minimumDuration > 0 ? .loading(message) : .waiting)
        revealTask = Task { [weak self, delay] in
            do { try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000)) } catch { return }
            guard let self, isActive else { return }
            state.send(.loading(message))
        }
        return true
    }

    func perform<Value: Sendable>(_ operation: @escaping @MainActor @Sendable () async throws -> Value) async throws -> Value {
        guard !isCancelled else { throw CancellationError() }
        let remaining = timeout - elapsed
        guard isActive, remaining > 0 else { throw NetworkError.timeout }
        do {
            let race = CTARequestRace<Value>()
            cancelOperation = { race.cancel() }
            let result = try await withTaskCancellationHandler {
                try Task.checkCancellation()
                return try await race.run(timeout: remaining, operation: operation)
            } onCancel: {
                Task { @MainActor in race.cancel() }
            }
            cancelOperation = nil
            try Task.checkCancellation()
            guard !isCancelled else { throw CancellationError() }
            let minimumRemaining = minimumDuration - elapsed
            if minimumRemaining > 0 {
                try await wait(seconds: minimumRemaining)
            }
            return result
        } catch {
            try Task.checkCancellation()
            if error is CancellationError { throw error }
            if Self.isConnectionError(error), elapsed < timeout {
                revealTask?.cancel()
                state.send(.networkLoading)
                try await wait(seconds: max(0, timeout - elapsed))
            } else if minimumDuration > elapsed {
                try await wait(seconds: minimumDuration - elapsed)
            }
            throw error
        }
    }

    func handles(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        guard Self.isConnectionError(error) else { return false }
        revealTask?.cancel()
        state.send(.connectionFailure)
        return true
    }

    func finish() {
        revealTask?.cancel()
        revealTask = nil
        isActive = false
        cancelOperation = nil
        if state.value != .connectionFailure { state.send(.idle) }
    }

    func dismissFailure() {
        state.send(.idle)
    }

    func cancel() {
        isCancelled = true
        revealTask?.cancel()
        cancelOperation?()
    }
}

@MainActor
private final class CTARequestRace<Value: Sendable> {

    // MARK: - Properties

    private var continuation: CheckedContinuation<Value, Error>?
    private var operationTask: Task<Void, Never>?
    private var timeoutTask: Task<Void, Never>?
    private var isCancelled = false

    // MARK: - Methods

    private func resolve(_ result: Result<Value, Error>) {
        guard let continuation else { return }
        self.continuation = nil
        operationTask?.cancel()
        timeoutTask?.cancel()
        operationTask = nil
        timeoutTask = nil
        continuation.resume(with: result)
    }

    func run(timeout: TimeInterval, operation: @escaping @MainActor @Sendable () async throws -> Value) async throws -> Value {
        guard !isCancelled else { throw CancellationError() }
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            operationTask = Task { [weak self] in
                do { self?.resolve(.success(try await operation())) } catch { self?.resolve(.failure(error)) }
            }
            timeoutTask = Task { [weak self] in
                do { try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000)) } catch { return }
                self?.resolve(.failure(NetworkError.timeout))
            }
        }
    }

    func cancel() {
        isCancelled = true
        resolve(.failure(CancellationError()))
    }
}
