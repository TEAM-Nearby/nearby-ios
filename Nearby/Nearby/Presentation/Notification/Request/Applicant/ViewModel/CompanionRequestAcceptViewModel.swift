//
//  CompanionRequestAcceptViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class CompanionRequestAcceptViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case confirmButtonDidTap
        case enterChatButtonDidTap
        case chatHelpButtonDidTap
    }

    // MARK: - Output

    struct Output: OpenChatDisplayable {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let step = CurrentValueSubject<Step, Never>(.matched)
        let showOpenChat = PassthroughSubject<URL, Never>()
        let showChatLinkPopup = PassthroughSubject<String, Never>()
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
    // TODO: - 서버 연동 시 응답값으로 교체
    let openChatURLString = "https://open.kakao.com/o/s3lwQwDi"
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(hostName: String, locationName: String) {
        self.hostName = hostName
        self.locationName = locationName
    }

    // MARK: - Action

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
                // TODO: - 지인이 화면으로 교체
                showOpenChat()
            }

        case .enterChatButtonDidTap:
            sendOpenChatURL()

        case .chatHelpButtonDidTap:
            sendChatLinkPopup()
        }
    }
    
    // MARK: - Method
    
    private func showOpenChat() {
        guard let url = URL(string: openChatURLString), url.scheme == "https"
                || url.scheme == "http" else { return }
        output.showOpenChat.send(url)
    }
}

// MARK: - OpenChatDiplayable

extension CompanionRequestAcceptViewModel: OpenChatSendable {
    var openChatOutput: OpenChatDisplayable {
        output
    }
}
