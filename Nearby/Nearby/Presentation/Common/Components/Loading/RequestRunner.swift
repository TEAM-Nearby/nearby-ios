//
//  RequestRunner.swift
//  Nearby
//
//  Created by soomin on 10/13/26.
//

import Combine
import Foundation

@MainActor
protocol RequestRunning {
    var requestRunner: RequestRunner { get }
}

enum LoadingPolicy {
    case standard
    case meetingVerification

    var message: String {
        switch self {
        case .standard: return "잠시만 기다려주세요"
        case .meetingVerification: return "만남을 인증하고 있어요"
        }
    }

    var minimumDuration: TimeInterval {
        switch self {
        case .standard: return 0
        case .meetingVerification: return 1
        }
    }
}

@MainActor
final class RequestRunner {
    
    // MARK: - Property
    
    let id = UUID()
    private let loadingState: CTARequestState
    private var task: Task<Void, Never>?

    var state: AnyPublisher<CTARequestState.State, Never> { loadingState.state.eraseToAnyPublisher() }
    var isRunning: Bool { loadingState.state.value != .idle && loadingState.state.value != .connectionFailure }

    // MARK: - Initializer
    
    init(delay: TimeInterval = 0.5, timeout: TimeInterval = 10) {
        loadingState = CTARequestState(delay: delay, timeout: timeout)
    }
    
    // MARK: - Methods

    @discardableResult
    func run<Value: Sendable>(policy: LoadingPolicy = .standard, onStart: () -> Void = {}, operation: @escaping @MainActor @Sendable () async throws -> Value,
                              onSuccess: @escaping @MainActor (Value) -> Void, onFailure: @escaping @MainActor (Error) -> Void, onFinish: @escaping @MainActor () -> Void = {}) -> Task<Void, Never>? {
        guard task == nil,
              loadingState.begin(message: policy.message, minimumDuration: policy.minimumDuration) else { return nil }
        onStart()
        
        let runningTask = Task { [self] in
            let result: Result<Value, Error>
            do {
                result = .success(try await loadingState.perform(operation))
            } catch {
                result = .failure(error)
            }

            let handled: Bool
            switch result {
            case .success: handled = false
            case .failure(let error): handled = Task.isCancelled || loadingState.handles(error)
            }
            onFinish()
            loadingState.finish()
            task = nil

            guard !Task.isCancelled, !handled else { return }
            switch result {
            case .success(let value): onSuccess(value)
            case .failure(let error): onFailure(error)
            }
        }
        task = runningTask
        return runningTask
    }

    func cancel() {
        task?.cancel()
        loadingState.cancel()
    }

    func dismissFailure() {
        loadingState.dismissFailure()
    }
}
