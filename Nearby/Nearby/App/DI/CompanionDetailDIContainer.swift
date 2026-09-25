//
//  CompanionDetailDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

final class CompanionDetailDIContainer {
    
    // MARK: - Dependencies

    private let tokenStorage: TokenStorage
    private let networkProvider: NetworkProvider

    // MARK: - Service

    private lazy var companionDetailService: CompanionDetailService = DefaultCompanionDetailService(networkProvider: networkProvider)

    // MARK: - Repository

#if DEBUG
    private lazy var companionDetailRepository: CompanionDetailRepository = MockCompanionDetailRepository()
#else
    private lazy var companionDetailRepository: CompanionDetailRepository = DefaultCompanionDetailRepository(service: companionDetailService)
#endif

    // MARK: - Initializer

    init(tokenStorage: TokenStorage, networkProvider: NetworkProvider) {
        self.tokenStorage = tokenStorage
        self.networkProvider = networkProvider
    }

    // MARK: - Factory Method

    func makeCompanionDetailViewController(state: CompanionDetailState, onRoute: @escaping (CompanionDetailViewModel.Route) -> Void) -> CompanionDetailViewController {
        let viewModel = CompanionDetailViewModel(state: state, repository: companionDetailRepository, currentUserId: tokenStorage.currentUserId)
        viewModel.route = onRoute
        return CompanionDetailViewController(viewModel: viewModel)
    }
}
