//
//  DiningMapDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

final class DiningMapDIContainer {
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let myPageRepository: MyPageRepository

    // MARK: - Services

    private lazy var diningMapService: DiningMapService = DefaultDiningMapService(networkProvider: networkProvider)

    private lazy var notificationService: CompanionRequestService = DefaultCompanionRequestService(networkProvider: networkProvider)

    // MARK: - Repositories

    private lazy var diningMapRepository: DiningMapRepository = DefaultDiningMapRepository(service: diningMapService)

    private lazy var notificationRepository: CompanionRequestRepository = DefaultCompanionRequestRepository(service: notificationService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Method

    func makeDiningMapViewController() -> DiningMapViewController {
        DiningMapViewController(viewModel: DiningMapViewModel(myPageRepository: myPageRepository, notificationRepository: notificationRepository), nearDiningSheetViewController: NearDiningSheetViewController(viewModel: NearDiningBottomSheetViewModel(repository: diningMapRepository)), saveDiningSheetViewController: SaveDiningSheetViewController(viewModel: SaveDiningSheetViewModel(repository: diningMapRepository)), diningInfoSheetViewController: DiningInfoSheetViewController(viewModel: DiningInfoSheetViewModel(repository: diningMapRepository)))
    }
}
