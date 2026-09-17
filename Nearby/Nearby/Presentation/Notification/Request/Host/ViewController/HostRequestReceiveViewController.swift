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

    var onRoute: ((NotificationRoute) -> Void)?

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
            self?.onRoute?(.previous)
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
                onRoute?(.hostRequestDecline(applicantName: viewModel.applicantNickname, applicationId: viewModel.applicationId))
            }
            .store(in: &cancellables)

        viewModel.output.showHostAllowView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                onRoute?(.hostRequestAllow(applicantName: viewModel.applicantNickname, applicantProfileImageURL: viewModel.applicantProfileImageURL, locationName: viewModel.placeName, meetingAt: viewModel.meetingAt, matchId: viewModel.matchId, postType: viewModel.meetingTimeType, openChatURL: viewModel.openChatURL))
            }
            .store(in: &cancellables)
        
        viewModel.output.showApplicantProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profileId in
                self?.onRoute?(.applicantProfile(profileId))
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
