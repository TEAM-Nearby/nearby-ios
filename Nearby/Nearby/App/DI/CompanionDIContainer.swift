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
    private let myPageRepository: MyPageRepository

    // MARK: - Service

    private lazy var companionService: CompanionService = DefaultCompanionService(networkProvider: networkProvider)

    // MARK: - Repository

#if DEBUG
    private lazy var companionRepository: CompanionRepository = MockCompanionRepository()
#else
    private lazy var companionRepository: CompanionRepository = DefaultCompanionRepository(service: companionService)
#endif

    private var initialNickname: String? {
#if DEBUG
        "수민"
#else
        nil
#endif
    }

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Method

    func makeCompanionViewController(onRoute: @escaping (CompanionViewModel.Route) -> Void, onAlarmButtonDidTap: @escaping () -> Void) -> CompanionViewController {
        let viewModel = CompanionViewModel(myPageRepository: myPageRepository, initialNickname: initialNickname)
        viewModel.route = onRoute
        let bottomSheetController = CompanionBottomSheetController(
            nearbySheetViewController: NearCompanionSheetViewController(viewModel: NearCompanionSheetViewModel(repository: companionRepository)),
            specificSheetViewController: SpecificCompanionSheetViewController(viewModel: SpecificCompanionSheetViewModel()),
            emptySheetViewController: EmptyCompanionSheetViewController()
        )
        let viewController = CompanionViewController(viewModel: viewModel, bottomSheetController: bottomSheetController)
        viewController.onAlarmButtonDidTap = onAlarmButtonDidTap
        return viewController
    }
}
