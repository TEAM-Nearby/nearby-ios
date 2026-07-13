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
        let showReviewList = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
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
    // TODO: - 서버 연동 후 상세 분기
    private(set) var userRole: NearbyUserType = .participant
    private let repository: MeetingRepository
    private var meetingDate: Date = .distantPast
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
                // TODO: - 만남 인증(체크인) API 연동 후 성공 콜백에서 단계 갱신
                output.step.send(.completion)
                updateVerifyButtonState()
            case .completion:
                output.showReviewList.send(())
            case .match:
                return
            }
            
        case .reportButtonDidTap:
            output.showReport.send(())
        }
    }
    
    // MARK: - Methods
    
    private func fetchDetail() {
        Task {
            do {
                let DTO = try await repository.fetchMeetingDetail(meetingId: meetingId)
                
                userRole = DTO.currentUserRole
                meetingDate = DTO.meetingAt.toDate() ?? .distantPast
                postType = DTO.meetingTimeType
                
                let data = DisplayData(
                    profileImageUrl: DTO.hostProfileImageUrl,
                    name: DTO.hostNickname,
                    gender: DTO.hostGender.genderDisplayText,
                    information: "\(DTO.placeName) · \(meetingDate.meetingDisplayText)"
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
                
                if currentStep == .match && isWithinVerifiableWindow {
                    output.step.send(.verification)
                }
                updateVerifyButtonState()
            }
            .store(in: &cancellables)
    }
}
