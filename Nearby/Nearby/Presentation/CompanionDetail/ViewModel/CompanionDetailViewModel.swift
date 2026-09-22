//
//  CompanionDetailViewModel.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import Combine
import Foundation

final class CompanionDetailViewModel: BaseViewModelType {

    // MARK: - State

    enum ViewState {
        case idle
        case loading(CompanionDetailState)
        case loaded(CompanionDetailState)
        case failed(Error)
    }

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
        let viewState = CurrentValueSubject<ViewState, Never>(.idle)
        let isApplying = CurrentValueSubject<Bool, Never>(false)
        let applyError = PassthroughSubject<Error, Never>()
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
            if state.postId == nil {
                output.viewState.send(.loaded(state))
            } else {
                output.viewState.send(.loading(state))
                fetchDetail()
            }
        case .backButtonDidTap:
            route?(.close)
        case .applyButtonDidTap:
            applyCompanion()
        case .hostProfileDidTap:
            guard let hostProfileId = state.hostProfileId else { return }
            route?(.hostProfile(profileId: hostProfileId))
        }
    }

    // MARK: - Methods

    private func fetchDetail() {
        guard let postId = state.postId else { return }

        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchDetail(postId: postId)
                guard !Task.isCancelled else { return }

                state = response.detailState(preserving: state, currentUserId: currentUserId)
                output.viewState.send(.loaded(state))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.viewState.send(.failed(error))
            }
        }
    }

    private func applyCompanion() {
        guard state.isApplicationEnabled, let postId = state.postId, applyTask == nil else { return }

        output.isApplying.send(true)
        applyTask = Task { [weak self] in
            guard let self else { return }
            defer {
                applyTask = nil
                output.isApplying.send(false)
            }

            do {
                try await repository.apply(postId: postId)
                guard !Task.isCancelled else { return }
                route?(.applyCompanion(hostName: state.hostName))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.applyError.send(error)
            }
        }
    }
}

private extension CompanionDetail {
    func detailState(preserving previousState: CompanionDetailState, currentUserId: Int?) -> CompanionDetailState {
        CompanionDetailState(
            postId: postId,
            hostProfileId: hostProfileId,
            postType: postType,
            isApplicationEnabled: isRecruiting && hasNotApplied && participantCount < maxParticipants && hostUserId != currentUserId,
            tags: TravelStyleKeyword.titles(for: hostProfile.keywords),
            hostName: hostProfile.nickname,
            genderTitle: hostProfile.gender.title,
            profileImageURL: hostProfile.profileImageURL,
            hostIntroduction: hostProfile.introduction,
            mannerScoreText: String(format: "%.1f", hostProfile.mannerScore),
            isPhoneVerified: hostProfile.isPhoneVerified,
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
        let imageURLs = participants.map(\.profileImageURL)
        let missingCount = max(participantCount - imageURLs.count, 0)
        return imageURLs + [String?](repeating: nil, count: missingCount)
    }

    var postType: PostType {
        guard meetingTimeType == .now else { return .scheduled }
        return .immediate(expirationTime: expirationTimeText)
    }

    var expirationTimeText: String {
        guard let expiresAt else { return "곧" }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .nearbyAPITimeZone
        formatter.dateFormat = "H시 mm분"
        return formatter.string(from: expiresAt)
    }

    var detailMeetingTimeTitle: String? {
        switch meetingTimeType {
        case .now:
            return "지금 바로"
        case .undecided:
            return "시간 미정"
        case .scheduled, .unknown:
            guard let meetingAt else { return nil }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = .current
            formatter.dateFormat = "M월 d일 (E) a h시 m분"
            return formatter.string(from: meetingAt)
        }
    }
}
