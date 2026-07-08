//
//  HostRequestAllowViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestAllowViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case confirmButtonDidTap
        case enterChatButtonDidTap
        case chatHelpButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let step = CurrentValueSubject<Step, Never>(.matched)
        let showOpenChat = PassthroughSubject<Void, Never>()
    }

    enum Step {
        case matched
        case chat
    }

    struct DisplayData {
        let image: UIImage
        let title: String
        let location: String
        let date: String
        let chatTitle: String
    }

    // MARK: - Properties

    let output = Output()

    private let applicantName: String
    private let locationName: String
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(applicantName: String, locationName: String) {
        self.applicantName = applicantName
        self.locationName = locationName
    }

    // MARK: - Method

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .imgProfileDefault,
                title: "\(applicantName) 님과 동행이 매칭됐어요!",
                location: "\(locationName)",
                date: "6월 18일 (목) 오후 4시 30분",
                chatTitle: "\(applicantName) 님과 대화를 나눠보세요"
            )
            output.displayData.send(data)

        case .confirmButtonDidTap:
            switch output.step.value {
            case .matched:
                output.step.send(.chat)
            case .chat:
                output.showOpenChat.send(())
            }

        case .enterChatButtonDidTap:
            output.showOpenChat.send(())

        case .chatHelpButtonDidTap:
            break
        }
    }
}
