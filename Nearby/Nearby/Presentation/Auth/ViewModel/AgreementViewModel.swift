//
//  AgreementViewModel.swift
//  Nearby
//
//  Created by 신서연 on 10/9/26.
//

import Foundation

final class AgreementViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case allAgreementDidTap
        case serviceAgreementDidTap
        case locationAgreementDidTap
        case privacyAgreementDidTap
        case marketingAgreementDidTap
        case serviceDetailDidTap
        case locationDetailDidTap
        case privacyDetailDidTap
        case marketingDetailDidTap
    }

    // MARK: - Outputs

    struct Output {
        var onAgreementStateChanged: ((AgreementState) -> Void)?
        var onAgreementDetailRequested: ((AgreementDetailType) -> Void)?
    }

    struct AgreementState {
        let isAllAgreed: Bool
        let isServiceAgreed: Bool
        let isLocationAgreed: Bool
        let isPrivacyAgreed: Bool
        let isMarketingAgreed: Bool
        let isAgreeButtonEnabled: Bool
    }

    // MARK: - Properties

    var output = Output()
    
    private var isServiceAgreed = false
    private var isLocationAgreed = false
    private var isPrivacyAgreed = false
    private var isMarketingAgreed = false

    private var isAllAgreed: Bool {
        isServiceAgreed && isLocationAgreed && isPrivacyAgreed && isMarketingAgreed
    }

    private var isAgreeButtonEnabled: Bool {
        isServiceAgreed && isLocationAgreed && isPrivacyAgreed
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .allAgreementDidTap:
            let isAgreed = !isAllAgreed

            isServiceAgreed = isAgreed
            isLocationAgreed = isAgreed
            isPrivacyAgreed = isAgreed
            isMarketingAgreed = isAgreed

        case .serviceAgreementDidTap:
            isServiceAgreed.toggle()

        case .locationAgreementDidTap:
            isLocationAgreed.toggle()

        case .privacyAgreementDidTap:
            isPrivacyAgreed.toggle()

        case .marketingAgreementDidTap:
            isMarketingAgreed.toggle()
        
        case .serviceDetailDidTap:
            output.onAgreementDetailRequested?(.service)
            return

        case .locationDetailDidTap:
            output.onAgreementDetailRequested?(.location)
            return

        case .privacyDetailDidTap:
            output.onAgreementDetailRequested?(.privacy)
            return

        case .marketingDetailDidTap:
            output.onAgreementDetailRequested?(.marketing)
            return
        }

        updateAgreementState()
    }

    // MARK: - Private Method

    private func updateAgreementState() {
        let state = AgreementState(
            isAllAgreed: isAllAgreed,
            isServiceAgreed: isServiceAgreed,
            isLocationAgreed: isLocationAgreed,
            isPrivacyAgreed: isPrivacyAgreed,
            isMarketingAgreed: isMarketingAgreed,
            isAgreeButtonEnabled: isAgreeButtonEnabled
        )
        output.onAgreementStateChanged?(state)
    }
}
