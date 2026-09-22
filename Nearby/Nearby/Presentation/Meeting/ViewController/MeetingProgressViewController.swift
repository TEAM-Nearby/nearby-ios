//
//  MeetingProgressViewController.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine
import UIKit

final class MeetingProgressViewController: BaseViewController<MeetingProgressViewModel> {
    
    // MARK: - UI Component
    
    private let meetingProgressView = MeetingProgressView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = meetingProgressView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        meetingProgressView.onBackButtonDidTap = { [weak self] in
            self?.coordinator?.pop()
        }
        meetingProgressView.onReportButtonDidTap = { [weak self] in
            self?.viewModel.action(.reportButtonDidTap)
        }
        meetingProgressView.onVerifyButtonDidTap = { [weak self] in
            self?.viewModel.action(.verifyButtonDidTap)
        }
    }
    
    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.meetingProgressView.configure(with: data)
            }
            .store(in: &cancellables)
        
        viewModel.output.step
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                self?.meetingProgressView.updateStep(step)
            }
            .store(in: &cancellables)
        
        viewModel.output.verifyButtonState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.meetingProgressView.updateVerifyButtonState(state)
            }
            .store(in: &cancellables)
        
        viewModel.output.showReport
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showReportPost()
            }
            .store(in: &cancellables)
        
        viewModel.output.showReview
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                switch route {
                case .hostReviewList(let meetingId):
                    self?.coordinator?.showHostReviewList(meetingId: meetingId)
                case .participantReview(let item):
                    self?.coordinator?.showReview(type: .participant, item: item)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.checkInSucceeded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showCheckInSuccessAlert()
            }
            .store(in: &cancellables)

        viewModel.output.showVerificationWaitingToast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.meetingProgressView.showVerificationWaitingToast()
            }
            .store(in: &cancellables)

        viewModel.output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.coordinator?.showErrorAlert(message: message)
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
