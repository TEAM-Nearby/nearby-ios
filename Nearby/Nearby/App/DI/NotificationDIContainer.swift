//
//  NotificationDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import UIKit

final class NotificationDIContainer {
    
    // MARK: - Dependency

    private let networkProvider: NetworkProvider

    // MARK: - Services

    private lazy var applicantService: ApplicantCompanionService = DefaultApplicantCompanionService(networkProvider: networkProvider)
    private lazy var hostService: HostCompanionService = DefaultHostCompanionService(networkProvider: networkProvider)
    private lazy var profileService: ProfileService = DefaultProfileService(networkProvider: networkProvider)

    // MARK: - Repositories

    private lazy var applicantRepository: ApplicantCompanionRepository = DefaultApplicantCompanionRepository(applicantCompanionService: applicantService)
    private lazy var hostRepository: HostCompanionRepository = DefaultHostCompanionRepository(hostCompanionService: hostService)
    private lazy var profileRepository: ProfileRepository = DefaultProfileRepository(service: profileService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Factory Methods

    func makeCompanionRequestSentViewController(coordinator: NotificationCoordinator, hostName: String) -> UIViewController {
        let viewController = CompanionRequestSentViewController(viewModel: CompanionRequestSentViewModel(hostName: hostName))
        configure(viewController, coordinator: coordinator)
        return viewController
    }

    func makeCompanionRequestDeclineViewController(coordinator: NotificationCoordinator) -> UIViewController {
        let viewController = CompanionRequestDeclineViewController(viewModel: CompanionRequestDeclineViewModel())
        configure(viewController, coordinator: coordinator)
        return viewController
    }

    func makeCompanionRequestAcceptViewController(coordinator: NotificationCoordinator, applicationId: Int) -> UIViewController {
        let viewController = CompanionRequestAcceptViewController(viewModel: CompanionRequestAcceptViewModel(applicationId: applicationId, repository: applicantRepository))
        configure(viewController, coordinator: coordinator)
        return viewController
    }

    func makeHostRequestReceiveViewController(coordinator: NotificationCoordinator, applicationId: Int) -> UIViewController {
        let viewController = HostRequestReceiveViewController(viewModel: HostRequestReceiveViewModel(applicationId: applicationId, repository: hostRepository))
        configure(viewController, coordinator: coordinator)
        return viewController
    }

    func makeHostRequestDeclineViewController(coordinator: NotificationCoordinator, applicantName: String, applicationId: Int) -> UIViewController {
        let viewController = HostRequestDeclineViewController(viewModel: HostRequestDeclineViewModel(applicantName: applicantName, applicationId: applicationId, repository: hostRepository))
        configure(viewController, coordinator: coordinator)
        return viewController
    }

    func makeHostRequestAllowViewController(coordinator: NotificationCoordinator, applicantName: String, applicantProfileImageUrl: String?, locationName: String, meetingAt: String, matchId: Int?, postType: PostType, openChatUrl: String) -> UIViewController {
        let viewController = HostRequestAllowViewController(viewModel: HostRequestAllowViewModel(applicantProfileImageUrl: applicantProfileImageUrl, applicantName: applicantName, locationName: locationName, meetingAt: meetingAt, matchId: matchId, postType: postType, openChatUrl: openChatUrl))
        configure(viewController, coordinator: coordinator)
        return viewController
    }

    func makeHostProfileViewController(profileId: Int) -> HostProfileViewController {
        HostProfileViewController(viewModel: HostProfileViewModel(profileId: profileId, repository: profileRepository))
    }

    private func configure(_ viewController: CompanionRequestSentViewController, coordinator: NotificationCoordinator) {
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
    }

    private func configure(_ viewController: CompanionRequestDeclineViewController, coordinator: NotificationCoordinator) {
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
    }

    private func configure(_ viewController: CompanionRequestAcceptViewController, coordinator: NotificationCoordinator) {
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
    }

    private func configure(_ viewController: HostRequestReceiveViewController, coordinator: NotificationCoordinator) {
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
    }

    private func configure(_ viewController: HostRequestDeclineViewController, coordinator: NotificationCoordinator) {
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
    }

    private func configure(_ viewController: HostRequestAllowViewController, coordinator: NotificationCoordinator) {
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
    }
}
