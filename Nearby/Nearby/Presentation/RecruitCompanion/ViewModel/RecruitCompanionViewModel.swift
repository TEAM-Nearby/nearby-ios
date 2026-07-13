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
        case placeDidSelect(SelectedPlace)
        case contentDidChange(String)
        case openChatURLDidChange(String)
        case completeButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let state = CurrentValueSubject<State, Never>(.initial)
        let placeSuggestions = CurrentValueSubject<[PlaceSearchResultItem], Never>([])
        let completeButtonDidTap = PassthroughSubject<Void, Never>()
        let showBack = PassthroughSubject<Void, Never>()
    }

    struct State {
        let meetingTimeType: RecruitMeetingTimeType
        let meetingAt: Date?
        let isDatePickerVisible: Bool
        let maxParticipants: Int
        let styleKeywords: Set<String>
        let placeQuery: String
        let selectedPlaceID: String?
        let content: String
        let openChatURL: String

        static let initial = State(
            meetingTimeType: .now,
            meetingAt: nil,
            isDatePickerVisible: false,
            maxParticipants: 2,
            styleKeywords: [],
            placeQuery: "",
            selectedPlaceID: nil,
            content: "",
            openChatURL: ""
        )

        var isCompleteButtonEnabled: Bool {
            return isFormValid
        }

        var isFormValid: Bool {
            let hasMeetingAt = meetingTimeType == .now || meetingAt != nil
            let hasPlace = selectedPlaceID != nil

            return hasMeetingAt
                && hasPlace
                && !styleKeywords.isEmpty
                && !content.trimmed.isEmpty
                && !openChatURL.trimmed.isEmpty
        }
    }

    // MARK: - Properties

    let output = Output()

    private let googlePlaceService: GooglePlaceService
    private let searchCoordinate: (latitude: Double, longitude: Double)
    private var draft = RecruitCompanionDraft()
    private var placeSearchWorkItem: DispatchWorkItem?
    private var latestPlaceSearchQuery = ""

    private var isFormValid: Bool {
        return output.state.value.isFormValid
    }

    // MARK: - Initializer

    init(
        googlePlaceService: GooglePlaceService,
        searchCoordinate: (latitude: Double, longitude: Double)
    ) {
        self.googlePlaceService = googlePlaceService
        self.searchCoordinate = searchCoordinate
    }

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
            draft.selectedPlaceID = nil
            draft.selectedPlaceAddress = ""
            publishState()
            searchPlacesWithDebounce(query: query)

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

        case .placeDidSelect(let place):
            placeSearchWorkItem?.cancel()
            latestPlaceSearchQuery = ""
            draft.placeQuery = place.name
            draft.selectedPlaceID = place.placeID
            draft.selectedPlaceAddress = place.address
            googlePlaceService.refreshSessionToken()
            publishState()
        }
    }

    // MARK: - Methods

    private func publishState() {
        output.state.send(
            State(
                meetingTimeType: draft.meetingTimeType,
                meetingAt: draft.meetingAt,
                isDatePickerVisible: draft.meetingTimeType == .scheduled,
                maxParticipants: draft.maxParticipants,
                styleKeywords: draft.styleKeywords,
                placeQuery: draft.placeQuery,
                selectedPlaceID: draft.selectedPlaceID,
                content: draft.content,
                openChatURL: draft.openChatURL
            )
        )
    }

    private func searchPlacesWithDebounce(query: String) {
        placeSearchWorkItem?.cancel()

        let trimmedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        latestPlaceSearchQuery = trimmedQuery

        guard !trimmedQuery.isEmpty else {
            output.placeSuggestions.send([])
            googlePlaceService.refreshSessionToken()
            return
        }

        let workItem = DispatchWorkItem { [weak self] in
            self?.searchPlaces(query: trimmedQuery)
        }

        placeSearchWorkItem = workItem

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.4,
            execute: workItem
        )
    }

    private func searchPlaces(query: String) {
        googlePlaceService.searchPlaces(
            query: query,
            latitude: searchCoordinate.latitude,
            longitude: searchCoordinate.longitude
        ) { [weak self] result in
            guard let self, latestPlaceSearchQuery == query else { return }

            switch result {
            case .success(let suggestions):
                output.placeSuggestions.send(suggestions)

            case .failure(let error):
                AppLogger.error(error, message: "장소 검색에 실패했습니다.")
                output.placeSuggestions.send([])
            }
        }
    }
}
