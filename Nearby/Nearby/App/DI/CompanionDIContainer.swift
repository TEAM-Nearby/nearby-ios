//
//  CompanionDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import UIKit

final class CompanionDIContainer {
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let guestNetworkProvider: NetworkProvider
    private let myPageRepository: MyPageRepository

    // MARK: - Services

    private lazy var companionService: CompanionService = DefaultCompanionService(networkProvider: networkProvider)

    private lazy var notificationService: CompanionRequestService = DefaultCompanionRequestService(networkProvider: networkProvider)

    // MARK: - Repositories

    private lazy var companionRepository: CompanionRepository = DefaultCompanionRepository(service: companionService)

    private lazy var guestRepository: CompanionRepository = DefaultCompanionRepository(service: DefaultCompanionService(networkProvider: guestNetworkProvider))

    private lazy var notificationRepository: CompanionRequestRepository = DefaultCompanionRequestRepository(service: notificationService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, guestNetworkProvider: NetworkProvider, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.guestNetworkProvider = guestNetworkProvider
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Method

    func makeCompanionViewController(isGuest: Bool = false, onRoute: @escaping (CompanionViewModel.Route) -> Void, onAlarmButtonDidTap: @escaping () -> Void) -> CompanionViewController {
        let companionRepository = isGuest ? guestRepository : self.companionRepository
        let viewModel = CompanionViewModel(myPageRepository: myPageRepository, notificationRepository: notificationRepository, isGuest: isGuest)
        viewModel.route = onRoute
        let bottomSheetController = CompanionBottomSheetController(
            nearbySheetViewController: NearCompanionSheetViewController(viewModel: NearCompanionSheetViewModel(repository: companionRepository)),
            specificSheetViewController: SpecificCompanionSheetViewController(viewModel: SpecificCompanionSheetViewModel()),
            emptySheetViewController: EmptyCompanionSheetViewController()
        )
        let viewController = CompanionViewController(viewModel: viewModel, bottomSheetController: bottomSheetController, isGuest: isGuest)
        viewController.onAlarmButtonDidTap = onAlarmButtonDidTap
        return viewController
    }
}
