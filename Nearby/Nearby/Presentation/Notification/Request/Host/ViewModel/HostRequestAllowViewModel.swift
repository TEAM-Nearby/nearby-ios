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
    let openChatURLString: String
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(applicantProfileImageUrl: String?, applicantName: String, locationName: String, meetingAt: String, matchId: Int?, postType: PostType, openChatUrl: String) {
        self.profileImageUrl = applicantProfileImageUrl
        self.applicantName = applicantName
        self.locationName = locationName
        self.meetingAt = meetingAt
        self.matchId = matchId
        self.postType = postType
        self.openChatURLString = openChatUrl
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                profileImageUrl: profileImageUrl,
                title: "\(applicantName) 님과 동행이 매칭됐어요!",
                location: "\(locationName)",
                date: meetingAt.toDate()?.meetingDisplayText ?? "",
                chatTitle: "\(applicantName) 님과 대화를 나눠보세요"
            )
            output.displayData.send(data)
            
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
}

// MARK: - OpenChatSendable

extension HostRequestAllowViewModel: OpenChatSendable {
    var openChatOutput: OpenChatDisplayable {
        output
    }
}
