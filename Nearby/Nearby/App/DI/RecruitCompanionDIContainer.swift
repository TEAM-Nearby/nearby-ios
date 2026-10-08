//
//  RecruitCompanionDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import CoreLocation
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

    func makeRecruitCompanionViewController(searchCoordinate: CLLocationCoordinate2D?, onRoute: @escaping (RecruitCompanionRoute) -> Void) -> UIViewController {
#if DEBUG
        let resolvedSearchCoordinate = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
#else
        let resolvedSearchCoordinate = searchCoordinate
#endif
        let viewModel = RecruitCompanionViewModel(repository: recruitCompanionRepository, searchCoordinate: resolvedSearchCoordinate)
        let viewController = RecruitCompanionViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
