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
        let avatarImageURLs: [String?]
        let chatDescription: String
    }

    // MARK: - Properties

    let output = Output()

    let applicationId: Int
    private(set) var openChatURLString: String = ""
    private var matchId: Int?
    private var matchStatus: MatchStatus?
    private let repository: ApplicantCompanionRepository
    private let matchingRepository: MatchedCompanionListRepository

    // MARK: - Initializer

    init(applicationId: Int, repository: ApplicantCompanionRepository, matchingRepository: MatchedCompanionListRepository) {
        self.applicationId = applicationId
        self.repository = repository
        self.matchingRepository = matchingRepository
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
                guard let matchId,
                      matchStatus != .completed,
                      matchStatus != .canceled
                else { return }
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
                matchStatus = MatchStatus(rawValue: result.matchStatus)

                let preview = try? await matchingRepository.fetchMatchPreview(matchId: result.matchId)
                let avatarImageURLs = preview.map { [$0.host.hostProfileImageURL] + $0.members.map(\.profileImageURL) }
                    ?? [String?](repeating: nil, count: result.participantCount)

                let data = DisplayData(
                    hostProfileImageUrl: result.host.profileImageUrl,
                    title: "\(result.host.nickname) 님과 동행이 매칭됐어요!",
                    location: result.place.name,
                    date: result.meetingAt?.toDate()?.meetingDisplayText ?? "",
                    people: "\(result.participantCount)/\(result.maxParticipants)명",
                    buttonTitle: "확인했어요",
                    avatarImageURLs: avatarImageURLs,
                    chatDescription: "\(result.host.nickname) 님이 만남 약속을 위한 오픈채팅방을 열어뒀어요. 입장해서 인사를 나눠보세요!"
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
