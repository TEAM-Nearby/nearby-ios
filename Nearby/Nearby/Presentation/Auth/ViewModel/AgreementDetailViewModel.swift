//
//  AgreementDetailViewModel.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import Foundation

final class AgreementDetailViewModel: BaseViewModelType {

    // MARK: - Properties

    enum Input {
        case viewDidLoad
    }

    struct Output {
        var onAgreementDetailLoaded: ((String, String) -> Void)?
    }

    var output = Output()

    private let agreementType: AgreementDetailType

    // MARK: - Initializer

    init(agreementType: AgreementDetailType) {
        self.agreementType = agreementType
    }

    // MARK: - Custom Method

    func action(_ input: Input) {
        switch input {
        case .viewDidLoad:
            loadAgreementDetail()
        }
    }

    // MARK: - Methods

    private func loadAgreementDetail() {
        guard let fileURL = Bundle.main.url(forResource: agreementType.fileName, withExtension: "txt"
        ) else {
            output.onAgreementDetailLoaded?(agreementType.title, "약관 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            output.onAgreementDetailLoaded?(agreementType.title, content)
        } catch {
            output.onAgreementDetailLoaded?(agreementType.title, "약관 내용을 불러오지 못했습니다.")
        }
    }
}
