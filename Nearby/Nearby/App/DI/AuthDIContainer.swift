//
//  AuthDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

final class AuthDIContainer {
    
    // MARK: - Dependency

    private let authRepository: AuthRepository

    // MARK: - Initializer

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    // MARK: - Factory Methods

    func makeLoginViewController() -> LoginViewController {
        LoginViewController(viewModel: LoginViewModel(authRepository: authRepository))
    }

    func makePhoneVerificationViewController() -> PhoneVerificationViewController {
        PhoneVerificationViewController(viewModel: PhoneVerificationViewModel(authRepository: authRepository))
    }

    func makeCompanionProfileViewController() -> CompanionProfileViewController {
        CompanionProfileViewController(viewModel: CompanionProfileViewModel(authRepository: authRepository))
    }
    
    func makeEmergencyContactViewController() -> EmergencyContactViewController {
        EmergencyContactViewController(viewModel: EmergencyContactViewModel())
    }
    
    func makeAgreementViewController() -> AgreementViewController {
        AgreementViewController(viewModel: AgreementViewModel())
    }
    
    func makeAgreementDetailViewController(type: AgreementDetailType) -> AgreementDetailViewController {
        let viewModel = AgreementDetailViewModel(agreementType: type)
        return AgreementDetailViewController(viewModel: viewModel)
    }

}
