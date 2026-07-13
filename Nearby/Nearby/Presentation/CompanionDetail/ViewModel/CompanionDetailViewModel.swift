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
        case applyCompanion
    }

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case applyButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayState = PassthroughSubject<CompanionDetailState, Never>()
        let error = PassthroughSubject<Error, Never>()
    }

    // MARK: - Properties

    var route: ((Route) -> Void)?
    let output = Output()
    private var state: CompanionDetailState
    private let repository: CompanionDetailRepository
    private var fetchTask: Task<Void, Never>?

    // MARK: - Initializer

    init(state: CompanionDetailState, repository: CompanionDetailRepository) {
        self.state = state
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
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
            guard state.isApplicationEnabled else { return }
            route?(.applyCompanion)
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

                state = response.detailState(preserving: state)
                output.displayState.send(state)
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
    func detailState(preserving previousState: CompanionDetailState) -> CompanionDetailState {
        CompanionDetailState(
            postId: postId,
            postType: postType,
            isApplicationEnabled: status == "RECRUITING" && applyStatus == "NOT_APPLIED",
            tags: hostProfileSummary.keywords.map {
                TravelStyleKeyword(rawValue: $0)?.title ?? $0
            },
            hostName: hostProfileSummary.nickname,
            genderTitle: hostProfileSummary.gender == "FEMALE" ? "여성" : "남성",
            profileImageURL: hostProfileSummary.profileImageUrl.flatMap(URL.init(string:)),
            mannerScoreText: String(format: "%.1f", hostProfileSummary.mannerScore),
            isPhoneVerified: hostProfileSummary.phoneVerifiedAt != nil,
            placeName: previousState.placeName,
            googlePlaceId: googlePlaceId,
            placeLatitude: previousState.placeLatitude,
            placeLongitude: previousState.placeLongitude,
            meetingTimeText: previousState.meetingTimeText,
            participantSummaryText: "\(participantCount)/\(maxParticipants)명",
            participantCount: participantCount,
            content: content
        )
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
}
