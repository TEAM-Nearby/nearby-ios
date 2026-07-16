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
        let showScheduleDetail = PassthroughSubject<Int, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    enum Step {
        case matched
        case chat
    }

    struct DisplayData {
        let hostProfileImageUrl: String?
        let title: String
        let location: String
        let date: String
        let people: String
        let buttonTitle: String
        let avatarImages: [UIImage?]
    }

    // MARK: - Properties

    let output = Output()

    let applicationId: Int
    private(set) var openChatURLString: String = ""
    private var matchId: Int?
    private let repository: ApplicantCompanionRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(applicationId: Int, repository: ApplicantCompanionRepository) {
        self.applicationId = applicationId
        self.repository = repository
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchRequestResult()

        case .confirmButtonDidTap:
            switch output.step.value {
            case .matched:
                output.step.send(.chat)
            case .chat:
                guard let matchId else { return }
                output.showScheduleDetail.send(matchId)
            }

        case .enterChatButtonDidTap:
            sendOpenChatURL()

        case .chatHelpButtonDidTap:
            sendChatLinkPopup()
        }
    }

    // MARK: - Method

    private func fetchRequestResult() {
        Task {
            do {
                let DTO = try await repository.fetchRequestResult(applicationId: applicationId)

                guard let result = DTO.acceptedResult else {
                    output.errorMessage.send("신청 결과를 불러올 수 없어요")
                    return
                }

                openChatURLString = result.openChatUrl ?? ""
                matchId = result.matchId

                let data = DisplayData(
                    hostProfileImageUrl: result.host.profileImageUrl,
                    title: "\(result.host.nickname) 님과 동행이 매칭됐어요!",
                    location: result.place.name,
                    date: result.meetingAt?.toDate()?.meetingDisplayText ?? "",
                    people: "\(result.participantCount)/\(result.maxParticipants)명",
                    buttonTitle: "확인했어요",
                    avatarImages: [UIImage?](repeating: nil, count: result.participantCount)
                )
                output.displayData.send(data)
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
}

// MARK: - OpenChatSendable

extension CompanionRequestAcceptViewModel: OpenChatSendable {
    var openChatOutput: OpenChatDisplayable {
        output
    }
}
