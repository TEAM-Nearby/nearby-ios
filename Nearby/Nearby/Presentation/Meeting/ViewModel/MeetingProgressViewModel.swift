//
//  MeetingProgressViewModel.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine
import UIKit

final class MeetingProgressViewModel: BaseViewModelType {
    
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
        let showReport = PassthroughSubject<Void, Never>()
        let showReview = PassthroughSubject<ReviewRoute, Never>()
        let showVerificationWaitingToast = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
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
        repository: MeetingRepository,
        matchingRepository: MatchedCompanionListRepository,
        reviewRepository: ReviewRepository
    ) {
        self.item = item
        self.meetingId = item.meetingId
        self.matchId = item.matchId
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
                guard let restaurantCoordinate else {
                    output.errorMessage.send("식당 위치를 확인할 수 없어요.")
                    return
                }
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
            output.showReport.send(())
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

                let DTO = try await meetingDetailTask
                let scheduleResponse = await scheduleTask

                if let place = scheduleResponse?.schedule?.place {
                    restaurantCoordinate = (
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                }
                
                meetingDate = DTO.meetingAt?.toDate()
                postType = DTO.meetingTimeType

                let data = MeetingProgressDisplayData(
                    profileImageURL: DTO.hostProfileImageUrl,
                    name: DTO.hostNickname,
                    gender: DTO.hostGender.genderDisplayText,
                    information: MeetingItem.makeInformation(placeName: DTO.placeName, meetingDate: meetingDate)
                )
                output.displayData.send(data)
                
                let initialStep = MeetingStep(
                    isCheckedIn: DTO.currentUserCheckedIn,
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
                output.errorMessage.send(error.localizedDescription)
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
        Task {
            do {
                _ = try await repository.checkIn(meetingId: meetingId, latitude: latitude, longitude: longitude)
                output.step.send(.completion)
                updateVerifyButtonState()
                refreshCompanionVerification()
                output.checkInSucceeded.send(())
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func fetchReviewTargets() {
        guard let meetingId else { return }
        Task {
            do {
                let DTO = try await reviewRepository.fetchReviewTargets(meetingId: meetingId)
                switch DTO.currentUserRole {
                case .host:
                    guard !DTO.reviewTargets.isEmpty else {
                        showVerificationWaiting()
                        return
                    }
                    output.showReview.send(.hostReviewList(meetingId: meetingId))
                case .participant:
                    guard let target = DTO.reviewTargets.first else {
                        showVerificationWaiting()
                        return
                    }
                    output.showReview.send(.participantReview(ReviewItem(target: target, meetingId: meetingId)))
                }
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }

    private func showVerificationWaiting() {
        hasVerifiedCompanion = false
        updateVerifyButtonState()
        output.showVerificationWaitingToast.send(())
    }

    private func refreshCompanionVerification() {
        guard let meetingId else { return }
        Task {
            guard let DTO = try? await reviewRepository.fetchReviewTargets(meetingId: meetingId) else { return }
            hasVerifiedCompanion = !DTO.reviewTargets.isEmpty
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
