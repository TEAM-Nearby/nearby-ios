//
//  DiningMapDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import CoreLocation

final class DiningMapDIContainer {
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let myPageRepository: MyPageRepository

    // MARK: - Service

    private lazy var diningMapService: DiningMapService = DefaultDiningMapService(networkProvider: networkProvider)

    // MARK: - Repository

    private lazy var diningMapRepository: DiningMapRepository = DefaultDiningMapRepository(service: diningMapService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Method

    func makeDiningMapViewController() -> DiningMapViewController {
        DiningMapViewController(viewModel: DiningMapViewModel(myPageRepository: myPageRepository), nearDiningSheetViewController: NearDiningSheetViewController(viewModel: NearDiningBottomSheetViewModel(repository: diningMapRepository)), saveDiningSheetViewController: SaveDiningSheetViewController(viewModel: SaveDiningSheetViewModel(repository: diningMapRepository)), diningInfoSheetViewController: DiningInfoSheetViewController(viewModel: DiningInfoSheetViewModel(repository: diningMapRepository, coordinate: CLLocationCoordinate2D(latitude: 41.3879706, longitude: 2.1671360))))
    }
}
