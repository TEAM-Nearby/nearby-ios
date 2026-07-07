//
//  CompanionRequestSentViewModel.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import Combine
import UIKit

final class CompanionRequestSentViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case searchButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let showCompanionList = PassthroughSubject<Void, Never>()
    }

    struct DisplayData {
        let image: UIImage
        let title: String
        let subtitle: String
        let description: String
        let buttonTitle: String
    }

    // MARK: - Properties

    let output = Output()

    private let hostName: String
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(hostName: String) {
        self.hostName = hostName
    }

    // MARK: - Method

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .illustRequestSent,
                title: "신청을 보냈어요",
                subtitle: "\(hostName) 님이 신청자 프로필을 확인하고 있어요.",
                description: "Nearby는 호스트가 신청자를 직접 확인하고 수락해요.\n더 안전한 동행을 위해 조금만 기다려 주세요.",
                buttonTitle: "다른 동행도 살펴보기"
            )
            output.displayData.send(data)

        case .searchButtonDidTap:
            output.showCompanionList.send(())
        }
    }
}
