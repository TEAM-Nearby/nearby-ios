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
        case locationDidUpdate(latitude: Double, longitude: Double)
        case locationDidFail
    }
    
    // MARK: - Output
    
    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let step = CurrentValueSubject<MeetingStep, Never>(.match)
        let verifyButtonState = PassthroughSubject<VerifyButtonState, Never>()
        let showReport = PassthroughSubject<Void, Never>()
        let showReviewList = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
        let requestLocation = PassthroughSubject<Void, Never>()
    }
    
    struct DisplayData {
        let profileImageUrl: String?
        let name: String
        let gender: String
        let information: String
    }
    
    struct VerifyButtonState {
        let isEnabled: Bool
        let isDescriptionHidden: Bool
        let title: String
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    let meetingId: Int
    private(set) var userRole: NearbyUserType = .participant
    private(set) var canMoveToComplete: Bool = false
    private let repository: MeetingRepository
    private var meetingDate: Date?
    private var postType: PostType = .scheduled
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
    
    init(meetingId: Int, repository: MeetingRepository) {
        self.meetingId = meetingId
        self.repository = repository
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
                output.requestLocation.send(())
            case .completion:
                output.showReviewList.send(())
            case .match:
                return
            }
            
        case .reportButtonDidTap:
            output.showReport.send(())
        
        case .locationDidUpdate(let latitude, let longitude):
            checkIn(latitude: latitude, longitude: longitude)
            
        case .locationDidFail:
            output.errorMessage.send("위치를 확인할 수 없어요. 위치 권한을 확인해 주세요.")
        }
    }
    
    // MARK: - Methods
    
    private func fetchDetail() {
        Task {
            do {
                let DTO = try await repository.fetchMeetingDetail(meetingId: meetingId)
                
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
                startTimer()
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func checkIn(latitude: Double, longitude: Double) {
        Task {
            do {
                let DTO = try await repository.checkIn(meetingId: meetingId, latitude: latitude, longitude: longitude)
                canMoveToComplete = DTO.canMoveToComplete
                output.step.send(.completion)
                updateVerifyButtonState()
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func updateVerifyButtonState() {
        output.verifyButtonState.send(
            VerifyButtonState(
                isEnabled: isVerifiable || currentStep == .completion,
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
            }
            .store(in: &cancellables)
    }
}
