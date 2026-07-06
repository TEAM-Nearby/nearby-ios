//
//  CompanionRequestAcceptViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit
import Combine

final class CompanionRequestAcceptViewModel: BaseViewModelType {

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
        let people: String
        let buttonTitle: String
    }

    // MARK: - Properties

    let output = Output()

    private let hostName: String
    private let locationName: String
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(hostName: String, locationName: String) {
        self.hostName = hostName
        self.locationName = locationName
    }

    // MARK: - Method

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .imgProfileDefault,
                title: "\(hostName) 님과 동행이 매칭됐어요!",
                location: "\(locationName)",
                date: "6월 18일 (목) 오후 4시 30분",
                people: "3/4명",
                buttonTitle: "확인했어요"
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
