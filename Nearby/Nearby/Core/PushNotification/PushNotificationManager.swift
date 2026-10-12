//
//  PushNotificationManager.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

import Combine
import UIKit
import UserNotifications

import FirebaseMessaging

final class PushNotificationManager: NSObject {

    // MARK: - Properties

    private let repository: PushEndpointRepository
    private let tokenStorage: TokenStorage
    private var apnsTokenCancellable: AnyCancellable?

    private var hasStoredSession: Bool {
        guard let accessToken = tokenStorage.accessToken else { return false }
        return !accessToken.isEmpty
    }

    // MARK: - Initializer

    init(repository: PushEndpointRepository, tokenStorage: TokenStorage) {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }

    // MARK: - Methods

    private func bindAPNsToken() {
        guard apnsTokenCancellable == nil else { return }
        apnsTokenCancellable = NotificationCenter.default.publisher(for: .apnsTokenDidReceive)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.registerCurrentToken() }
            }
    }

    private func requestAuthorization() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            AppLogger.error(error)
        }
    }

    private func registerCurrentToken() async {
        do {
            let token = try await Messaging.messaging().token()
            await register(token: token)
        } catch {
            AppLogger.error(error)
        }
    }

    private func register(token: String) async {
        guard hasStoredSession else { return }
        do {
            try await repository.register(token: token)
        } catch {
            AppLogger.error(error)
        }
    }

    func start() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        bindAPNsToken()

        Task {
            await requestAuthorization()
            UIApplication.shared.registerForRemoteNotifications()
            if Messaging.messaging().apnsToken != nil {
                await registerCurrentToken()
            }
        }
    }
}

// MARK: - MessagingDelegate

extension PushNotificationManager: MessagingDelegate {
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        Task { @MainActor in
            await register(token: fcmToken)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .list, .sound]
    }
}

// MARK: - Notification.Name

extension Notification.Name {
    static let apnsTokenDidReceive = Notification.Name("apnsTokenDidReceive")
}
