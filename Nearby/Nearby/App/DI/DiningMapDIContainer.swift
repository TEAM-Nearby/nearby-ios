//
//  DiningMapDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

final class DiningMapDIContainer {
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let guestNetworkProvider: NetworkProvider
    private let myPageRepository: MyPageRepository

    // MARK: - Services

    private lazy var diningMapService: DiningMapService = DefaultDiningMapService(networkProvider: networkProvider)

    private lazy var notificationService: CompanionRequestService = DefaultCompanionRequestService(networkProvider: networkProvider)

    // MARK: - Repositories

    private lazy var diningMapRepository: DiningMapRepository = DefaultDiningMapRepository(service: diningMapService)

    private lazy var guestRepository: DiningMapRepository = DefaultDiningMapRepository(service: DefaultDiningMapService(networkProvider: guestNetworkProvider))

    private lazy var notificationRepository: CompanionRequestRepository = DefaultCompanionRequestRepository(service: notificationService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, guestNetworkProvider: NetworkProvider, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.guestNetworkProvider = guestNetworkProvider
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Method

    func makeDiningMapViewController(isGuest: Bool = false, onLoginRequired: (() -> Void)? = nil) -> DiningMapViewController {
        let diningMapRepository = isGuest ? guestRepository : self.diningMapRepository
        return DiningMapViewController(viewModel: DiningMapViewModel(myPageRepository: myPageRepository, notificationRepository: notificationRepository, isGuest: isGuest), nearDiningSheetViewController: NearDiningSheetViewController(viewModel: NearDiningBottomSheetViewModel(repository: diningMapRepository, isGuest: isGuest, onLoginRequired: onLoginRequired)), saveDiningSheetViewController: SaveDiningSheetViewController(viewModel: SaveDiningSheetViewModel(repository: diningMapRepository, isGuest: isGuest, onLoginRequired: onLoginRequired)), diningInfoSheetViewController: DiningInfoSheetViewController(viewModel: DiningInfoSheetViewModel(repository: diningMapRepository, isGuest: isGuest, onLoginRequired: onLoginRequired)))
    }
}
