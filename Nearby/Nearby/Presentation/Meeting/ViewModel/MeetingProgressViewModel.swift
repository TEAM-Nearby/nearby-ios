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
        let showMeetingVerification = PassthroughSubject<Void, Never>()
        let showReport = PassthroughSubject<Void, Never>()
        let showReviewList = PassthroughSubject<Void, Never>()
    }
    
    struct DisplayData {
        let image: UIImage
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
    
    private let item: MeetingItem
    private let verifiableWindow: TimeInterval = 3600
    let output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentStep: MeetingStep {
        output.step.value
    }
    
    private var isWithinVerifiableWindow: Bool {
        abs(item.meetingDate.timeIntervalSinceNow) <= verifiableWindow
    }
    
    private var isVerifiable: Bool {
        currentStep == .verification && isWithinVerifiableWindow
    }
    
    // MARK: - Initializer
    
    init(item: MeetingItem) {
        self.item = item
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .imgProfileDefault,
                name: item.name,
                gender: item.gender,
                information: item.information
            )
            output.displayData.send(data)
            
            let initialStep: MeetingStep = isWithinVerifiableWindow ? .verification : .match
            output.step.send(initialStep)
            
            updateVerifyButtonState()
            startTimer()
        
        case .verifyButtonDidTap:
            switch currentStep {
            case .verification:
                guard isVerifiable else { return }
                // TODO: - 만남 인증 API 연동 후 성공 콜백에서 단계 갱신
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
