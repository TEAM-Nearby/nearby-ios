//
//  CompanionDetailViewModel.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import Combine
import Foundation

final class CompanionDetailViewModel: BaseViewModelType {

    // MARK: - Route

    enum Route {
        case close
        case applyCompanion(hostName: String)
        case hostProfile(profileId: Int)
    }

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case applyButtonDidTap
        case hostProfileDidTap
    }

    // MARK: - Output

    struct Output {
        let displayState = PassthroughSubject<CompanionDetailState, Never>()
        let isApplying = CurrentValueSubject<Bool, Never>(false)
        let error = PassthroughSubject<Error, Never>()
    }

    // MARK: - Properties

    var route: ((Route) -> Void)?
    let output = Output()
    private var state: CompanionDetailState
    private let repository: CompanionDetailRepository
    private let currentUserId: Int?
    private var fetchTask: Task<Void, Never>?
    private var applyTask: Task<Void, Never>?

    // MARK: - Initializer

    init(
        state: CompanionDetailState,
        repository: CompanionDetailRepository,
        currentUserId: Int?
    ) {
        self.state = state
        self.repository = repository
        self.currentUserId = currentUserId
    }

    deinit {
        fetchTask?.cancel()
        applyTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.displayState.send(state)
            fetchDetail()
        case .backButtonDidTap:
            route?(.close)
        case .applyButtonDidTap:
            applyCompanion()
        case .hostProfileDidTap:
            guard let hostProfileId = state.hostProfileId else { return }
            route?(.hostProfile(profileId: hostProfileId))
        }
    }
}

private extension CompanionDetailViewModel {
    func fetchDetail() {
        guard let postId = state.postId else { return }

        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchDetail(postId: postId)
                guard !Task.isCancelled else { return }

                state = response.detailState(
                    preserving: state,
                    currentUserId: currentUserId
                )
                output.displayState.send(state)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }

    func applyCompanion() {
        guard state.isApplicationEnabled, let postId = state.postId, applyTask == nil else { return }

        output.isApplying.send(true)
        applyTask = Task { [weak self] in
            guard let self else { return }
            defer {
                applyTask = nil
                output.isApplying.send(false)
            }

            do {
                _ = try await repository.apply(postId: postId)
                guard !Task.isCancelled else { return }
                route?(.applyCompanion(hostName: state.hostName))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }
}

private extension CompanionDetailResponseDTO {
    func detailState(preserving previousState: CompanionDetailState, currentUserId: Int?) -> CompanionDetailState {
        CompanionDetailState(
            postId: postId,
            hostProfileId: hostProfileId,
            postType: postType,
            isApplicationEnabled: status == "RECRUITING"
                && applyStatus == "NOT_APPLIED"
                && hostUserId != currentUserId,
            tags: TravelStyleKeyword.titles(for: hostProfileSummary.keywords),
            hostName: hostProfileSummary.nickname,
            genderTitle: hostProfileSummary.gender == "FEMALE" ? "여성" : "남성",
            profileImageURL: hostProfileSummary.profileImageUrl.flatMap(URL.init(string:)),
            hostIntroduction: hostProfileSummary.intro,
            mannerScoreText: String(format: "%.1f", hostProfileSummary.mannerScore),
            isPhoneVerified: hostProfileSummary.phoneVerifiedAt != nil,
            placeName: previousState.placeName,
            googlePlaceId: googlePlaceId,
            placeLatitude: previousState.placeLatitude,
            placeLongitude: previousState.placeLongitude,
            meetingTimeText: detailMeetingTimeTitle ?? previousState.meetingTimeText,
            participantSummaryText: "\(participantCount)/\(maxParticipants)명",
            participantCount: participantCount,
            participantImageURLs: participantProfileImageURLs,
            content: content
        )
    }

    var participantProfileImageURLs: [String?] {
        let imageURLs = participants.map(\.profileImageUrl)
        let missingCount = max(participantCount - imageURLs.count, 0)
        return imageURLs + [String?](repeating: nil, count: missingCount)
    }

    var postType: PostType {
        guard meetingTimeType == "NOW" else { return .scheduled }
        return .immediate(expirationTime: expirationTimeText)
    }

    var expirationTimeText: String {
        guard let time = expiresAt?.split(separator: "T").last?.prefix(5) else { return "곧" }
        let components = time.split(separator: ":")
        guard components.count == 2 else { return String(time) }
        return "\(components[0])시 \(components[1])분"
    }

    var detailMeetingTimeTitle: String? {
        switch meetingTimeType {
        case "NOW":
            return "지금 바로"
        case "UNDECIDED":
            return "시간 미정"
        default:
            guard let meetingDate else { return nil }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = .current
            formatter.dateFormat = "M월 d일 (E) a h시 m분"
            return formatter.string(from: meetingDate)
        }
    }

    var meetingDate: Date? {
        guard let meetingAt else { return nil }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: meetingAt) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: meetingAt) {
            return date
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current

        for format in ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm"] {
            formatter.dateFormat = format
            if let date = formatter.date(from: meetingAt) {
                return date
            }
        }

        return nil
    }
}
