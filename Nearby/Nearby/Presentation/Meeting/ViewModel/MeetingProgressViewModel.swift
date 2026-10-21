//
//  MeetingProgressViewModel.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine
import UIKit

final class MeetingProgressViewModel: BaseViewModelType, RequestRunning {
    let requestRunner = RequestRunner()
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case verifyButtonDidTap
        case reportButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let displayData = PassthroughSubject<MeetingProgressDisplayData, Never>()
        let step = CurrentValueSubject<MeetingStep, Never>(.match)
        let verifyButtonState = PassthroughSubject<MeetingVerifyButtonState, Never>()
        let showReport = PassthroughSubject<MeetingReportTarget, Never>()
        let showReview = PassthroughSubject<ReviewRoute, Never>()
        let showVerificationWaitingToast = PassthroughSubject<Void, Never>()
        let checkInSucceeded = PassthroughSubject<Void, Never>()
    }
    
    enum ReviewRoute {
        case hostReviewList(meetingId: Int)
        case participantReview(ReviewItem)
    }
    
    // MARK: - Properties
    
    let output = Output()

    private let meetingId: Int?
    private let item: MeetingItem
    private let matchId: Int
    private let repository: MeetingRepository
    private let matchingRepository: MatchedCompanionListRepository
    private let reviewRepository: ReviewRepository
    private var restaurantCoordinate: (latitude: Double, longitude: Double)?
    private var meetingDate: Date?
    private var postType: PostType = .scheduled
    private var hasVerifiedCompanion: Bool?
    private var currentUserRole: NearbyUserType?
    private var cancellables = Set<AnyCancellable>()
    
    private var currentStep: MeetingStep {
        output.step.value
    }
    
    private var isWithinVerifiableWindow: Bool {
        postType.isVerifiable(meetingAt: meetingDate)
    }
    
    private var isVerifiable: Bool {
        currentStep == .verification && isWithinVerifiableWindow
    }
    
    // MARK: - Initializer
    
    init(
        item: MeetingItem,
        currentUserId: Int?,
        repository: MeetingRepository,
        matchingRepository: MatchedCompanionListRepository,
        reviewRepository: ReviewRepository
    ) {
        self.item = item
        self.meetingId = item.meetingId
        self.matchId = item.matchId
        self.currentUserRole = currentUserId.map { item.hostUserID == $0 ? .host : .participant }
        self.repository = repository
        self.matchingRepository = matchingRepository
        self.reviewRepository = reviewRepository
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchDetail()
            
        case .verifyButtonDidTap:
            switch currentStep {
            case .verification:
                guard isVerifiable else { return }
                guard let restaurantCoordinate else { return }
                checkIn(
                    latitude: restaurantCoordinate.latitude,
                    longitude: restaurantCoordinate.longitude
                )
            case .completion:
                guard hasVerifiedCompanion != false else {
                    output.showVerificationWaitingToast.send(())
                    refreshCompanionVerification()
                    return
                }
                fetchReviewTargets()
            case .match:
                return
            }
            
        case .reportButtonDidTap:
            guard let currentUserRole else { return }
            let reportedUserID = currentUserRole == .participant ? item.hostUserID : nil
            if let meetingId {
                output.showReport.send(.meeting(id: meetingId, reportedUserID: reportedUserID))
            } else {
                output.showReport.send(.match(id: matchId, reportedUserID: reportedUserID))
            }
        }
    }
    
    // MARK: - Methods
    
    private func fetchDetail() {
        guard let meetingId else {
            configureUnconfirmedMeeting()
            return
        }
        Task {
            do {
                async let meetingDetailTask = repository.fetchMeetingDetail(meetingId: meetingId)
                async let scheduleTask = try? matchingRepository.fetchMatchMySchedule(matchId: matchId)

                let detail = try await meetingDetailTask
                let scheduleResponse = await scheduleTask

                if let place = scheduleResponse?.schedule?.place {
                    restaurantCoordinate = (
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                }
                
                currentUserRole = detail.currentUserRole
                meetingDate = detail.meetingAt
                postType = detail.meetingTimeType

                let data = MeetingProgressDisplayData(
                    profileImageURL: detail.hostProfileImageURL,
                    name: detail.hostNickname,
                    gender: detail.hostGender.genderDisplayText,
                    information: MeetingItem.makeInformation(placeName: detail.placeName, meetingDate: meetingDate, timeZoneID: detail.timeZoneID)
                )
                output.displayData.send(data)
                
                let initialStep = MeetingStep(
                    isCheckedIn: detail.isCurrentUserCheckedIn,
                    isWithinVerifiableWindow: isWithinVerifiableWindow
                )
                output.step.send(initialStep)

                updateVerifyButtonState()
                if initialStep == .completion {
                    refreshCompanionVerification()
                }
                startTimer()
            } catch {
                AppLogger.error(error)
            }
        }
    }
    
    private func configureUnconfirmedMeeting() {
        meetingDate = item.meetingDate
        postType = item.postType
        output.displayData.send(
            MeetingProgressDisplayData(
                profileImageURL: item.profileImageUrl,
                name: item.name,
                gender: item.gender,
                information: item.information
            )
        )
        output.step.send(.match)
        updateVerifyButtonState()
    }

    private func checkIn(latitude: Double, longitude: Double) {
        guard let meetingId else { return }

        requestRunner.run(
            policy: .meetingVerification,
            operation: { [self] in
                try await repository.checkIn(meetingId: meetingId, latitude: latitude, longitude: longitude)
            },
            onSuccess: { [self] _ in
                output.step.send(.completion)
                updateVerifyButtonState()
                refreshCompanionVerification()
                output.checkInSucceeded.send(())
            },
            onFailure: { [self] error in
                AppLogger.error(error)
            }
        )
    }
    
    private func fetchReviewTargets() {
        guard let meetingId else { return }

        requestRunner.run(
            operation: { [self] in
                try await reviewRepository.fetchReviewTargets(meetingId: meetingId)
            },
            onSuccess: { [self] reviewTargets in
                switch reviewTargets.currentUserRole {
                case .host:
                    guard !reviewTargets.reviewees.isEmpty else {
                        showVerificationWaiting()
                        return
                    }
                    output.showReview.send(.hostReviewList(meetingId: meetingId))
                case .participant:
                    guard let reviewee = reviewTargets.reviewees.first else {
                        showVerificationWaiting()
                        return
                    }
                    output.showReview.send(.participantReview(ReviewItem(reviewee: reviewee, meetingId: meetingId)))
                }
            },
            onFailure: { [self] error in
                AppLogger.error(error)
            }
        )
    }

    private func showVerificationWaiting() {
        hasVerifiedCompanion = false
        updateVerifyButtonState()
        output.showVerificationWaitingToast.send(())
    }

    private func refreshCompanionVerification() {
        guard let meetingId else { return }
        Task {
            guard let reviewTargets = try? await reviewRepository.fetchReviewTargets(meetingId: meetingId) else { return }
            hasVerifiedCompanion = !reviewTargets.reviewees.isEmpty
            updateVerifyButtonState()
        }
    }

    private func updateVerifyButtonState() {
        output.verifyButtonState.send(
            MeetingVerifyButtonState(
                isEnabled: isVerifiable || (currentStep == .completion && hasVerifiedCompanion == true),
                isTouchEnabled: isVerifiable || currentStep == .completion,
                isDescriptionHidden: isVerifiable || currentStep == .completion,
                title: currentStep == .completion ? "다음" : "만남 인증하기"
            )
        )
    }
    
    private func startTimer() {
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                
                let newStep = MeetingStep(isCheckedIn: false, isWithinVerifiableWindow: isWithinVerifiableWindow)
                if currentStep != .completion && currentStep != newStep {
                    output.step.send(newStep)
                }
                updateVerifyButtonState()

                if currentStep == .completion && hasVerifiedCompanion != true {
                    refreshCompanionVerification()
                }
            }
            .store(in: &cancellables)
    }
}
