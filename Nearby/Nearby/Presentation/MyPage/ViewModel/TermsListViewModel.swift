//
//  TermsListViewModel.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import Foundation

final class TermsListViewModel: BaseViewModelType {

    // MARK: - Properties

    enum Input {
        case backButtonDidTap
        case termsDidTap(AgreementDetailType)
    }

    struct Output {
        var backButtonDidTap: (() -> Void)?
        var termsDidTap: ((AgreementDetailType) -> Void)?
    }

    var output = Output()

    // MARK: - Custom Method

    func action(_ input: Input) {
        switch input {
        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .termsDidTap(let type):
            output.termsDidTap?(type)
        }
    }
}
