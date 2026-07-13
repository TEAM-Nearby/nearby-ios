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
        case placeDidSelect(PlaceSearchResultItem)
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
        let selectedPlaceLatitude: Double?
        let selectedPlaceLongitude: Double?
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
            selectedPlaceLatitude: nil,
            selectedPlaceLongitude: nil,
            content: "",
            openChatURL: ""
        )

        var isCompleteButtonEnabled: Bool {
            return isFormValid
        }

        var isFormValid: Bool {
            let hasMeetingAt = meetingTimeType == .now || meetingAt != nil
            let hasPlace = selectedPlaceID != nil
                && selectedPlaceLatitude != nil
                && selectedPlaceLongitude != nil

            return hasMeetingAt
                && hasPlace
                && !content.trimmed.isEmpty
                && !openChatURL.trimmed.isEmpty
        }
    }

    // MARK: - Properties

    let output = Output()

    private let repository: RecruitCompanionRepository
    private let searchCoordinate: (latitude: Double, longitude: Double)
    private var draft = RecruitCompanionDraft()
    private var placeSearchWorkItem: DispatchWorkItem?
    private var latestPlaceSearchQuery = ""

    private var isFormValid: Bool {
        return output.state.value.isFormValid
    }

    // MARK: - Initializer

    init(
        repository: RecruitCompanionRepository,
        searchCoordinate: (latitude: Double, longitude: Double)
    ) {
        self.repository = repository
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
            draft.selectedPlaceLatitude = nil
            draft.selectedPlaceLongitude = nil
            draft.selectedPlaceCategory = PlaceCategory.other.rawValue
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
            postRecruitCompanion()

        case .placeDidSelect(let item):
            placeSearchWorkItem?.cancel()
            latestPlaceSearchQuery = ""
            fetchPlaceDetail(for: item)
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
                selectedPlaceLatitude: draft.selectedPlaceLatitude,
                selectedPlaceLongitude: draft.selectedPlaceLongitude,
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
            repository.resetPlaceSearchSession()
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
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let suggestions = try await repository.searchPlaces(
                    query: query,
                    latitude: searchCoordinate.latitude,
                    longitude: searchCoordinate.longitude
                )
                guard latestPlaceSearchQuery == query else { return }
                output.placeSuggestions.send(suggestions)
            } catch {
                guard latestPlaceSearchQuery == query else { return }
                AppLogger.error(error, message: "장소 검색에 실패했습니다.")
                output.placeSuggestions.send([])
            }
        }
    }

    private func fetchPlaceDetail(for item: PlaceSearchResultItem) {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let place = try await repository.fetchPlaceDetail(for: item)
                draft.placeQuery = place.name
                draft.selectedPlaceID = place.placeID
                draft.selectedPlaceAddress = place.address
                draft.selectedPlaceLatitude = place.latitude
                draft.selectedPlaceLongitude = place.longitude
                draft.selectedPlaceCategory = place.category
                output.placeSuggestions.send([])
                publishState()
            } catch {
                AppLogger.error(error, message: "장소 상세 조회에 실패했습니다.")
            }
        }
    }

    private func postRecruitCompanion() {
        guard let request = makeRecruitCompanionRequest() else { return }

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                _ = try await repository.recruitCompanion(request: request)
                output.completeButtonDidTap.send(())
            } catch {
                AppLogger.error(error, message: "동행 모집글 작성에 실패했습니다.")
            }
        }
    }

    private func makeRecruitCompanionRequest() -> RecruitCompanionRequestDTO? {
        guard
            let selectedPlaceID = draft.selectedPlaceID,
            let selectedPlaceLatitude = draft.selectedPlaceLatitude,
            let selectedPlaceLongitude = draft.selectedPlaceLongitude
        else {
            return nil
        }

        let meetingTimeType: MeetingTimeType = draft.meetingTimeType == .scheduled
            ? .scheduled
            : .now

        return RecruitCompanionRequestDTO(
            place: RecruitCompanionRequestDTO.Place(
                googlePlaceId: selectedPlaceID,
                name: draft.placeQuery,
                address: draft.selectedPlaceAddress,
                latitude: selectedPlaceLatitude,
                longitude: selectedPlaceLongitude,
                category: draft.selectedPlaceCategory
            ),
            meetingTimeType: meetingTimeType,
            meetingAt: draft.meetingTimeType == .scheduled
                ? draft.meetingAt?.toFormattedString("yyyy-MM-dd'T'HH:mm:ss")
                : nil,
            maxParticipants: draft.maxParticipants,
            content: draft.content.trimmed,
            openChatUrl: draft.openChatURL.trimmed
        )
    }
}
