//
//  RecruitCompanionViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Combine
import Foundation

final class RecruitCompanionViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case timeTypeDidSelect(RecruitMeetingTimeType)
        case meetingAtDidChange(Date)
        case participantCountDidChange(Int)
        case styleKeywordDidTap(String)
        case placeQueryDidChange(String)
        case placeSearchButtonDidTap
        case contentDidChange(String)
        case openChatURLDidChange(String)
        case completeButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let state = CurrentValueSubject<State, Never>(.initial)
        let showPlaceSearch = PassthroughSubject<Void, Never>()
        let completeButtonDidTap = PassthroughSubject<Void, Never>()
        let showBack = PassthroughSubject<Void, Never>()
    }

    struct State {
        let meetingTimeType: RecruitMeetingTimeType
        let isDatePickerVisible: Bool
        let maxParticipants: Int
        let styleKeywords: Set<String>
        let placeQuery: String
        let isCompleteButtonEnabled: Bool

        static let initial = State(
            meetingTimeType: .now,
            isDatePickerVisible: false,
            maxParticipants: 2,
            styleKeywords: [],
            placeQuery: "",
            isCompleteButtonEnabled: false
        )
    }

    // MARK: - Properties

    let output = Output()

    private var draft = RecruitCompanionDraft()

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            publishState()

        case .backButtonDidTap:
            output.showBack.send(())

        case .timeTypeDidSelect(let type):
            draft.meetingTimeType = type
            if type == .now {
                draft.meetingAt = nil
            }
            publishState()

        case .meetingAtDidChange(let date):
            draft.meetingAt = date
            publishState()

        case .participantCountDidChange(let count):
            draft.maxParticipants = count
            publishState()

        case .styleKeywordDidTap(let keyword):
            if draft.styleKeywords.contains(keyword) {
                draft.styleKeywords.remove(keyword)
            } else {
                draft.styleKeywords.insert(keyword)
            }
            publishState()

        case .placeQueryDidChange(let query):
            draft.placeQuery = query
            publishState()

        case .placeSearchButtonDidTap:
            output.showPlaceSearch.send(())

        case .contentDidChange(let content):
            draft.content = content
            publishState()

        case .openChatURLDidChange(let url):
            draft.openChatURL = url
            publishState()

        case .completeButtonDidTap:
            guard isFormValid else { return }
            // TODO: - 동행글 작성 API POST 연결
            output.completeButtonDidTap.send(())
        }
    }

    // MARK: - Methods

    private var isFormValid: Bool {
        let hasMeetingAt = draft.meetingTimeType == .now || draft.meetingAt != nil
        let hasPlace = !draft.placeQuery.trimmed.isEmpty

        return hasMeetingAt
            && hasPlace
            && !draft.styleKeywords.isEmpty
            && !draft.content.trimmed.isEmpty
            && !draft.openChatURL.trimmed.isEmpty
    }

    private func publishState() {
        output.state.send(
            State(
                meetingTimeType: draft.meetingTimeType,
                isDatePickerVisible: draft.meetingTimeType == .scheduled,
                maxParticipants: draft.maxParticipants,
                styleKeywords: draft.styleKeywords,
                placeQuery: draft.placeQuery,
                isCompleteButtonEnabled: isFormValid
            )
        )
    }
}
