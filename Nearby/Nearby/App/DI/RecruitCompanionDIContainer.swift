//
//  RecruitCompanionDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import UIKit

final class RecruitCompanionDIContainer {
    
    // MARK: - Dependency

    private let networkProvider: NetworkProvider

    // MARK: - Service

    private lazy var recruitCompanionService: RecruitCompanionService = DefaultRecruitCompanionService(networkProvider: networkProvider)

    // MARK: - Repository

    private lazy var recruitCompanionRepository: RecruitCompanionRepository = DefaultRecruitCompanionRepository(googlePlaceService: GooglePlaceService(), recruitCompanionService: recruitCompanionService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Factory Method

    func makeRecruitCompanionViewController(coordinator: CompanionCoordinator) -> UIViewController {
        let viewModel = RecruitCompanionViewModel(repository: recruitCompanionRepository, searchCoordinate: (latitude: 41.3879706, longitude: 2.1671360))
        let viewController = RecruitCompanionViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
