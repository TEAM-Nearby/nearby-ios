//
//  MyPageDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

final class MyPageDIContainer {
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let authRepository: AuthRepository
    private let myPageRepository: MyPageRepository

    // MARK: - Service

    private lazy var requestService: CompanionRequestService = DefaultCompanionRequestService(networkProvider: networkProvider)

    // MARK: - Repository

    private lazy var requestRepository: CompanionRequestRepository = DefaultCompanionRequestRepository(service: requestService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, authRepository: AuthRepository, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.authRepository = authRepository
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Methods

    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(viewModel: MyPageViewModel(repository: myPageRepository))
    }

    func makeAlarmViewController(initialTab: AlarmTab = .sent) -> AlarmViewController {
        AlarmViewController(viewModel: AlarmViewModel(initialTab: initialTab, repository: requestRepository))
    }

    func makeSettingViewController() -> SettingViewController {
        SettingViewController(viewModel: SettingViewModel(authRepository: authRepository))
    }

    func makeWrittenPostViewController() -> WrittenPostViewController {
        WrittenPostViewController(viewModel: WrittenPostViewModel(repository: myPageRepository))
    }
}
