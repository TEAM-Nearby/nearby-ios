//
//  MyPageDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

final class MyPageDIContainer {
    
    // MARK: - Properties

    private lazy var companionProfileService: CompanionProfileService = DefaultCompanionProfileService(networkProvider: networkProvider)

    private lazy var companionProfileRepository: CompanionProfileRepository = DefaultCompanionProfileRepository(service: companionProfileService, authService: authService)
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let authRepository: AuthRepository
    private let authService: AuthService
    private let myPageRepository: MyPageRepository

    // MARK: - Service

    private lazy var requestService: CompanionRequestService = DefaultCompanionRequestService(networkProvider: networkProvider)

    // MARK: - Repository

    private lazy var requestRepository: CompanionRequestRepository = DefaultCompanionRequestRepository(service: requestService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, authRepository: AuthRepository, authService: AuthService, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.authRepository = authRepository
        self.authService = authService
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Methods

    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(viewModel: MyPageViewModel(repository: myPageRepository))
    }

    func makeAlarmViewController(initialTab: AlarmTab = .sent, onRoute: @escaping (AlarmViewController.Route) -> Void) -> AlarmViewController {
        let viewController = AlarmViewController(viewModel: AlarmViewModel(initialTab: initialTab, repository: requestRepository))
        viewController.onRoute = onRoute
        return viewController
    }

    func makeSettingViewController() -> SettingViewController {
        SettingViewController(viewModel: SettingViewModel(authRepository: authRepository))
    }
    
    func makeTermsListViewController() -> TermsListViewController {
        TermsListViewController(viewModel: TermsListViewModel())
    }
    
    func makeAgreementDetailViewController(type: AgreementDetailType) -> AgreementDetailViewController {
        AgreementDetailViewController(viewModel: AgreementDetailViewModel(agreementType: type))
    }

    func makeWrittenPostViewController() -> WrittenPostViewController {
        WrittenPostViewController(viewModel: WrittenPostViewModel(repository: myPageRepository))
    }
    
    func makeEditCompanionProfileViewController(profileID: Int) -> EditCompanionProfileViewController {
        let viewModel = EditCompanionProfileViewModel(repository: companionProfileRepository, profileID: profileID)

        return EditCompanionProfileViewController(viewModel: viewModel)
    }
}
