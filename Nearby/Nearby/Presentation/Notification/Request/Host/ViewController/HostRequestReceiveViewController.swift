//
//  HostRequestReceiveViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestReceiveViewController: BaseViewController<HostRequestReceiveViewModel> {
    
    // MARK: - UI Component

    private let hostRequestReceiveView = HostRequestReceiveView()
    
    // MARK: - Property

    weak var coordinator: NotificationCoordinator?

    // MARK: - Life Cycles

    override func loadView() {
        view = hostRequestReceiveView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hostRequestReceiveView.restartAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        hostRequestReceiveView.onBackButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        hostRequestReceiveView.onNextButtonDidTap = { [weak self] in
            self?.viewModel.action(.nextButtonDidTap)
        }
        
        hostRequestReceiveView.onAllowButtonDidTap = { [weak self] in
            self?.viewModel.action(.allowButtonDidTap)
        }
        
        hostRequestReceiveView.onRejectButtonDidTap = { [weak self] in
            self?.viewModel.action(.rejectButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.hostRequestReceiveView.configure(with: data)
            }
            .store(in: &cancellables)
        
        viewModel.output.showHostRejectView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.showHostRequestDecline(
                    applicantName: viewModel.applicantNickname,
                    applicationId: viewModel.applicationId
                )
            }
            .store(in: &cancellables)

        viewModel.output.showHostAllowView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                coordinator?.showHostRequestAllow(
                    applicantName: viewModel.applicantNickname,
                    applicantProfileImageUrl: viewModel.applicantProfileImageUrl,
                    locationName: viewModel.placeName,
                    meetingAt: viewModel.meetingAt,
                    matchId: viewModel.matchId,
                    postType: viewModel.meetingTimeType,
                    openChatUrl: viewModel.openChatUrl
                )
            }
            .store(in: &cancellables)
        
        viewModel.output.showApplicantProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profileId in
                self?.coordinator?.showHostProfile(profileId: profileId)
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
