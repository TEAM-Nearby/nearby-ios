//
//  CompanionRequestDeclineViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class CompanionRequestDeclineViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case writeButtonDidTap
        case searchButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let showWriteCompanionHost = PassthroughSubject<Void, Never>()
        let showCompanionList = PassthroughSubject<Void, Never>()
    }

    struct DisplayData {
        let image: UIImage
        let title: String
        let subtitle: String
        let writeButtonTitle: String
        let buttonTitle: String
    }

    // MARK: - Properties

    let output = Output()
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .illustRequestFailed,
                title: "이번 동행은 아쉽게\n함께하지 못하게 되었어요",
                subtitle: "더 잘 맞는 동행을 찾을 수 있도록 직접 동행글을 올려볼까요?",
                writeButtonTitle: "동행글 작성하기",
                buttonTitle: "다른 동행도 살펴보기"
            )
            output.displayData.send(data)

        case .writeButtonDidTap:
            output.showWriteCompanionHost.send(())
        case .searchButtonDidTap:
            output.showCompanionList.send(())
        }
    }
}
