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

    private lazy var companionRepository: CompanionRepository = DefaultCompanionRepository(service: companionService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Method

    func makeCompanionViewController(onRoute: @escaping (CompanionViewModel.Route) -> Void, onAlarmButtonDidTap: @escaping () -> Void) -> CompanionViewController {
        let viewModel = CompanionViewModel(myPageRepository: myPageRepository)
        viewModel.route = onRoute
        let viewController = CompanionViewController(viewModel: viewModel, nearbySheetViewController: NearCompanionSheetViewController(viewModel: NearCompanionSheetViewModel(repository: companionRepository)), specificSheetViewController: SpecificCompanionSheetViewController(viewModel: SpecificCompanionSheetViewModel()), emptySheetViewController: EmptyCompanionSheetViewController())
        viewController.onAlarmButtonDidTap = onAlarmButtonDidTap
        return viewController
    }
}
