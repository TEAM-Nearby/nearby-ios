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
        case locationAgreementDidTap
        case privacyAgreementDidTap
        case marketingAgreementDidTap
    }

    // MARK: - Outputs

    struct Output {
        var onAgreementStateChanged: ((AgreementState) -> Void)?
    }

    struct AgreementState {
        let isAllAgreed: Bool
        let isLocationAgreed: Bool
        let isPrivacyAgreed: Bool
        let isMarketingAgreed: Bool
        let isAgreeButtonEnabled: Bool
    }

    // MARK: - Properties

    var output = Output()

    private var isLocationAgreed = false
    private var isPrivacyAgreed = false
    private var isMarketingAgreed = false

    private var isAllAgreed: Bool {
        isLocationAgreed && isPrivacyAgreed && isMarketingAgreed
    }

    private var isAgreeButtonEnabled: Bool {
        isLocationAgreed && isPrivacyAgreed
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .allAgreementDidTap:
            let isAgreed = !isAllAgreed

            isLocationAgreed = isAgreed
            isPrivacyAgreed = isAgreed
            isMarketingAgreed = isAgreed

        case .locationAgreementDidTap:
            isLocationAgreed.toggle()

        case .privacyAgreementDidTap:
            isPrivacyAgreed.toggle()

        case .marketingAgreementDidTap:
            isMarketingAgreed.toggle()
        }

        updateAgreementState()
    }

    // MARK: - Private Method

    private func updateAgreementState() {
        let state = AgreementState(
            isAllAgreed: isAllAgreed,
            isLocationAgreed: isLocationAgreed,
            isPrivacyAgreed: isPrivacyAgreed,
            isMarketingAgreed: isMarketingAgreed,
            isAgreeButtonEnabled: isAgreeButtonEnabled
        )
        output.onAgreementStateChanged?(state)
    }
}
