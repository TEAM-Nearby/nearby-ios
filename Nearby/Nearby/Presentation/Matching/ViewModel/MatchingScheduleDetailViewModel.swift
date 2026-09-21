//
//  MatchingScheduleDetailViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import Foundation

final class MatchingScheduleDetailViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case alarmButtonDidTap
        case editButtonDidTap
        case shareButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<MatchingScheduleDetailDisplayData, Never>()
        let showBack = PassthroughSubject<Void, Never>()
        let showAlarm = PassthroughSubject<Void, Never>()
        let showEdit = PassthroughSubject<Int, Never>()
        let showShare = PassthroughSubject<MatchingScheduleDetailDisplayData, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    // MARK: - Properties

    let output = Output()

    private let matchId: Int
    private let repository: MatchedCompanionListRepository
    private var currentDisplayData: MatchingScheduleDetailDisplayData?
    private var fetchTask: Task<Void, Never>?

    // MARK: - Initializer

    init(matchId: Int, repository: MatchedCompanionListRepository) {
        self.matchId = matchId
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMatchMySchedule()

        case .backButtonDidTap:
            output.showBack.send(())

        case .alarmButtonDidTap:
            output.showAlarm.send(())

        case .editButtonDidTap:
            output.showEdit.send(matchId)

        case .shareButtonDidTap:
            guard let displayData = currentDisplayData else { return }
            output.showShare.send(displayData)
        }
    }

    // MARK: - Methods

    private func fetchMatchMySchedule() {
        fetchTask?.cancel()
        let matchID = matchId
        let repository = repository
        fetchTask = Task { @MainActor [weak self, repository] in

            do {
                async let scheduleResponseTask = repository.fetchMatchMySchedule(matchId: matchID)
                async let previewResponseTask = repository.fetchMatchPreview(matchId: matchID)

                let scheduleResponse = try await scheduleResponseTask
                let previewResponse = try? await previewResponseTask
                guard let self, !Task.isCancelled else { return }
                let displayData = makeDisplayData(
                    scheduleDetail: scheduleResponse,
                    preview: previewResponse
                )
                currentDisplayData = displayData
                output.displayData.send(displayData)
            } catch is CancellationError {
                return
            } catch {
                guard let self, !Task.isCancelled else { return }
                AppLogger.error(error, message: "매칭 상세 조회에 실패했습니다.")
                output.errorMessage.send("매칭 상세 정보를 불러오지 못했어요.")
            }
        }
    }
}

private extension MatchingScheduleDetailViewModel {
    func makeDisplayData(
        scheduleDetail: MatchedCompanionScheduleDetail,
        preview: MatchedCompanionPreview?
    ) -> MatchingScheduleDetailDisplayData {
        let userType = makeUserType(scheduleDetail.currentUserRole)
        let cardItem = makeCardItem(
            scheduleDetail: scheduleDetail,
            preview: preview,
            userType: userType
        )

        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: scheduleDetail.schedule?.place.name ?? "",
            placeAddress: scheduleDetail.schedule?.place.address ?? "",
            googlePlaceId: scheduleDetail.schedule?.place.googlePlaceID,
            latitude: scheduleDetail.schedule?.place.latitude ?? 0,
            longitude: scheduleDetail.schedule?.place.longitude ?? 0,
            scheduledAt: scheduleDetail.schedule?.scheduledAt,
            scheduledAtText: makeDateTimeText(
                scheduleDetail.schedule?.scheduledAt,
                fallback: scheduleDetail.meetingTimeType
            ),
            openChatUrl: scheduleDetail.openChatURL ?? "",
            type: userType
        )
    }

    func makeCardItem(
        scheduleDetail: MatchedCompanionScheduleDetail,
        preview: MatchedCompanionPreview?,
        userType: NearbyUserType
    ) -> MatchingMatchedCardItem {
        guard let preview else {
            return MatchingMatchedCardItem(
                matchId: scheduleDetail.matchID,
                content: MatchingMatchedCardContentModel(
                    name: scheduleDetail.userNickname ?? "",
                    participantCount: 1,
                    gender: "",
                    uploadedTime: "",
                    place: scheduleDetail.schedule?.place.name ?? "",
                    meetingTime: makeTimeText(
                        scheduleDetail.schedule?.scheduledAt,
                        fallback: scheduleDetail.meetingTimeType
                    ),
                    description: ""
                ),
                matchStatus: scheduleDetail.matchStatus.rawValue,
                type: userType
            )
        }

        let placeName = preview.companionPost.placeName.isEmpty
            ? scheduleDetail.schedule?.place.name ?? ""
            : preview.companionPost.placeName

        return MatchingMatchedCardItem(
            matchId: preview.matchID,
            content: MatchingMatchedCardContentModel(
                profileImageUrl: preview.host.hostProfileImageURL,
                profileImageUrls: [preview.host.hostProfileImageURL]
                    + preview.members.map(\.profileImageURL),
                name: preview.host.hostName,
                participantCount: preview.members.count + 1,
                gender: "",
                uploadedTime: "",
                place: placeName,
                meetingTime: makeTimeText(
                    preview.companionPost.meetingAt,
                    fallback: preview.companionPost.meetingTimeType
                ),
                description: preview.companionPost.content
            ),
            matchStatus: scheduleDetail.matchStatus.rawValue,
            type: userType
        )
    }

    func makeUserType(_ role: MatchedCompanionUserRole) -> NearbyUserType {
        switch role {
        case .host:
            return .host
        case .participant:
            return .participant
        }
    }

    func makeTimeText(
        _ scheduledAt: String?,
        fallback timeType: MatchedCompanionTimeType
    ) -> String {
        guard let scheduledAt else { return makeTimeTypeTitle(timeType) }
        return scheduledAt.toDate()?.timeDisplayText ?? scheduledAt
    }

    func makeDateTimeText(
        _ scheduledAt: String?,
        fallback timeType: MatchedCompanionTimeType
    ) -> String {
        guard let scheduledAt else { return makeTimeTypeTitle(timeType) }
        return scheduledAt.toDate()?.meetingDisplayText ?? scheduledAt
    }

    func makeTimeTypeTitle(_ timeType: MatchedCompanionTimeType) -> String {
        switch timeType {
        case .now:
            return "지금 바로"
        case .scheduled:
            return ""
        case .undecided:
            return "시간 미정"
        }
    }
}
