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

    func makeCompanionRequestSentViewController(hostName: String, onRoute: @escaping (NotificationRoute) -> Void) -> UIViewController {
        let viewController = CompanionRequestSentViewController(viewModel: CompanionRequestSentViewModel(hostName: hostName))
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeCompanionRequestDeclineViewController(onRoute: @escaping (NotificationRoute) -> Void) -> UIViewController {
        let viewController = CompanionRequestDeclineViewController(viewModel: CompanionRequestDeclineViewModel())
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeCompanionRequestAcceptViewController(applicationId: Int, onRoute: @escaping (NotificationRoute) -> Void) -> UIViewController {
        let viewController = CompanionRequestAcceptViewController(viewModel: CompanionRequestAcceptViewModel(applicationId: applicationId, repository: applicantRepository))
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeHostRequestReceiveViewController(applicationId: Int, onRoute: @escaping (NotificationRoute) -> Void) -> UIViewController {
        let viewController = HostRequestReceiveViewController(viewModel: HostRequestReceiveViewModel(applicationId: applicationId, repository: hostRepository))
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeHostRequestDeclineViewController(applicantName: String, applicationId: Int, onRoute: @escaping (NotificationRoute) -> Void) -> UIViewController {
        let viewController = HostRequestDeclineViewController(viewModel: HostRequestDeclineViewModel(applicantName: applicantName, applicationId: applicationId, repository: hostRepository))
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeHostRequestAllowViewController(applicantName: String, applicantProfileImageUrl: String?, locationName: String, meetingAt: String, matchId: Int?, postType: PostType, openChatUrl: String, onRoute: @escaping (NotificationRoute) -> Void) -> UIViewController {
        let viewController = HostRequestAllowViewController(viewModel: HostRequestAllowViewModel(applicantProfileImageUrl: applicantProfileImageUrl, applicantName: applicantName, locationName: locationName, meetingAt: meetingAt, matchId: matchId, postType: postType, openChatUrl: openChatUrl))
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeHostProfileViewController(profileId: Int, onRoute: @escaping (NotificationRoute) -> Void) -> HostProfileViewController {
        let viewController = HostProfileViewController(viewModel: HostProfileViewModel(profileId: profileId, repository: profileRepository))
        viewController.onRoute = onRoute
        return viewController
    }

}
