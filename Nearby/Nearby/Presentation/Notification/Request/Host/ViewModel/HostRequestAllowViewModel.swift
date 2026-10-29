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
    
    struct Output: OpenChatDisplayable {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let step = CurrentValueSubject<Step, Never>(.matched)
        let showOpenChat = PassthroughSubject<URL, Never>()
        let showChatLinkPopup = PassthroughSubject<String, Never>()
        let showScheduleDetail = PassthroughSubject<Int, Never>()
        let showScheduleConfirm = PassthroughSubject<Int, Never>()
    }
    
    enum Step {
        case matched
        case chat
    }
    
    struct DisplayData {
        let profileImageUrl: String?
        let title: String
        let location: String
        let date: String
        let chatTitle: String
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let applicantName: String
    private let locationName: String
    private let meetingAt: String
    private let matchId: Int?
    private let postType: PostType
    private let profileImageUrl: String?
    private let matchingRepository: MatchedCompanionListRepository
    private var scheduleTask: Task<Void, Never>?
    let openChatURLString: String

    // MARK: - Initializer

    init(applicantProfileImageUrl: String?, applicantName: String, locationName: String, meetingAt: String, matchId: Int?, postType: PostType, openChatUrl: String, matchingRepository: MatchedCompanionListRepository) {
        self.profileImageUrl = applicantProfileImageUrl
        self.applicantName = applicantName
        self.locationName = locationName
        self.meetingAt = meetingAt
        self.matchId = matchId
        self.postType = postType
        self.openChatURLString = openChatUrl
        self.matchingRepository = matchingRepository
    }

    deinit {
        scheduleTask?.cancel()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchConfirmedSchedule()
            
        case .confirmButtonDidTap:
            switch output.step.value {
            case .matched:
                output.step.send(.chat)
            case .chat:
                guard let matchId else { return }
                switch postType {
                case .immediate:
                    output.showScheduleDetail.send(matchId)
                case .scheduled:
                    output.showScheduleConfirm.send(matchId)
                case .undecided:
                    break
                }
                
            }
            
        case .enterChatButtonDidTap:
            sendOpenChatURL()
            
        case .chatHelpButtonDidTap:
            sendChatLinkPopup()
        }
    }

    // MARK: - Methods

    private func fetchConfirmedSchedule() {
        guard let matchId else {
            output.displayData.send(makeDisplayData(meetingAt: meetingAt, locationName: locationName))
            return
        }

        scheduleTask?.cancel()
        scheduleTask = Task { [weak self] in
            guard let self else { return }
            let schedule: MatchedCompanionScheduleDetail.Schedule?
            do {
                let detail = try await matchingRepository.fetchMatchMySchedule(matchId: matchId)
                schedule = detail.schedule
            } catch {
                schedule = nil
                AppLogger.error(error, message: "확정된 동행 일정을 불러오지 못했습니다.")
            }
            guard !Task.isCancelled else { return }
            output.displayData.send(makeDisplayData(
                meetingAt: schedule?.scheduledAt ?? meetingAt,
                locationName: schedule?.place.name ?? locationName
            ))
        }
    }

    private func makeDisplayData(meetingAt: String, locationName: String) -> DisplayData {
        DisplayData(
            profileImageUrl: profileImageUrl,
            title: "\(applicantName) 님과 동행이 매칭됐어요!",
            location: locationName,
            date: NearbyDateParser.reservationText(meetingAt, hourFormat: "M월 d일 (E) a h시", minuteFormat: "M월 d일 (E) a h시 m분") ?? "",
            chatTitle: "\(applicantName) 님과 대화를 나눠보세요"
        )
    }
}

// MARK: - OpenChatSendable

extension HostRequestAllowViewModel: OpenChatSendable {
    var openChatOutput: OpenChatDisplayable {
        output
    }
}
