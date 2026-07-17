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
        let displayData = PassthroughSubject<DisplayData, Never>()
        let step = CurrentValueSubject<MeetingStep, Never>(.match)
        let verifyButtonState = PassthroughSubject<VerifyButtonState, Never>()
        let showReport = PassthroughSubject<Void, Never>()
        let showReviewList = PassthroughSubject<ReviewItem?, Never>()
        let showVerificationWaitingToast = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
        let checkInSucceeded = PassthroughSubject<Void, Never>()
    }
    
    struct DisplayData {
        let profileImageUrl: String?
        let name: String
        let gender: String
        let information: String
    }
    
    struct VerifyButtonState {
        let isEnabled: Bool
        let isTouchEnabled: Bool
        let isDescriptionHidden: Bool
        let title: String
    }
    
    // MARK: - Properties
    
    let output = Output()

    let meetingId: Int?
    private(set) var userRole: NearbyUserType = .participant
    private(set) var canMoveToComplete: Bool = false
    private let item: MeetingItem
    private let matchId: Int
    private let repository: MeetingRepository
    private let matchingRepository: MatchedCompanionListRepository
    private let reviewRepository: ReviewRepository
    private var restaurantCoordinate: (latitude: Double, longitude: Double)?
    private var meetingDate: Date?
    private var postType: PostType = .scheduled
    private var hasVerifiedCompanion = true
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
                guard hasVerifiedCompanion else {
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
                
                userRole = DTO.currentUserRole
                meetingDate = DTO.meetingAt?.toDate()
                postType = DTO.meetingTimeType

                let information = [DTO.placeName, meetingDate?.timeDisplayText]
                    .compactMap { $0 }
                    .joined(separator: " · ")
                let data = DisplayData(
                    profileImageUrl: DTO.hostProfileImageUrl,
                    name: DTO.hostNickname,
                    gender: DTO.hostGender.genderDisplayText,
                    information: information
                )
                output.displayData.send(data)
                
                let initialStep: MeetingStep
                if DTO.currentUserCheckedIn {
                    initialStep = .completion
                } else {
                    initialStep = isWithinVerifiableWindow ? .verification : .match
                }
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
    
    /// 일정 미확정(meetingId 없음) 만남: 리스트 데이터로 화면을 구성하고 인증 대기 상태로 표시
    private func configureUnconfirmedMeeting() {
        meetingDate = item.meetingDate
        postType = item.postType
        output.displayData.send(
            DisplayData(
                profileImageUrl: item.profileImageUrl,
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
                let DTO = try await repository.checkIn(meetingId: meetingId, latitude: latitude, longitude: longitude)
                canMoveToComplete = DTO.canMoveToComplete
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
                userRole = DTO.currentUserRole

                switch DTO.currentUserRole {
                case .host:
                    guard !DTO.reviewTargets.isEmpty else {
                        showVerificationWaiting()
                        return
                    }
                    output.showReviewList.send(nil)
                case .participant:
                    guard let target = DTO.reviewTargets.first else {
                        showVerificationWaiting()
                        return
                    }
                    output.showReviewList.send(ReviewItem(target: target, meetingId: meetingId))
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
            userRole = DTO.currentUserRole
            hasVerifiedCompanion = !DTO.reviewTargets.isEmpty
            updateVerifyButtonState()
        }
    }

    private func updateVerifyButtonState() {
        output.verifyButtonState.send(
            VerifyButtonState(
                isEnabled: isVerifiable || (currentStep == .completion && hasVerifiedCompanion),
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
                
                let newStep: MeetingStep = isWithinVerifiableWindow ? .verification : .match
                if currentStep != .completion && currentStep != newStep {
                    output.step.send(newStep)
                }
                updateVerifyButtonState()

                if currentStep == .completion && !hasVerifiedCompanion {
                    refreshCompanionVerification()
                }
            }
            .store(in: &cancellables)
    }
}
