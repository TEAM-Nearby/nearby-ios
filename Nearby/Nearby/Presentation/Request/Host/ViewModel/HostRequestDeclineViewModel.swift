//
//  HostRequestDeclineViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestDeclineViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case rejectButtonDidTap(reason: String)
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let showDeclineComplete = PassthroughSubject<Void, Never>()
    }

    struct DisplayData {
        let image: UIImage
        let title: String
        let subTitle: String
        let buttonTitle: String
    }

    // MARK: - Properties

    let output = Output()

    private let applicantName: String
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(applicantName: String) {
        self.applicantName = applicantName
    }

    // MARK: - Method

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .imgProfileDefault,
                title: "\(applicantName) 님과의 동행을 거절할게요",
                subTitle: "더 잘 맞는 동행을 기다려볼까요?",
                buttonTitle: "거절하기"
            )
            output.displayData.send(data)

        case .rejectButtonDidTap(let reason):
            // TODO: - CoorDinator 연결
            print("거절 사유: \(reason)")
            output.showDeclineComplete.send(())
        }
    }
}
