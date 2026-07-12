//
//  HostRequestRecieveViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestRecieveViewController: BaseViewController<HostRequestRecieveViewModel> {

    // MARK: - UI Component

    private let hostRequestRecieveView = HostRequestRecieveView()
    
    // MARK: - Property
    
    weak var coordinator: NotificationCoordinator?

    // MARK: - Life Cycles

    override func loadView() {
        view = hostRequestRecieveView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        hostRequestRecieveView.onBackButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        hostRequestRecieveView.onAllowButtonDidTap = { [weak self] in
            self?.viewModel.action(.allowButtonDidTap)
        }
        
        hostRequestRecieveView.onRejectButtonDidTap = { [weak self] in
            self?.viewModel.action(.rejectButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.hostRequestRecieveView.configure(with: data)
            }
            .store(in: &cancellables)
        
        viewModel.output.showHostRejectView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.coordinator?.showHostRequestDecline(
                    applicantName: self.viewModel.applicantNickname,
                    applicationId: self.viewModel.applicationId
                )
            }
            .store(in: &cancellables)

        viewModel.output.showHostAllowView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - postType도 알림 페이로드/응답에서 전달
                self?.coordinator?.showHostRequestAllow(
                    applicantName: self?.viewModel.applicantNickname ?? "",
                    locationName: self?.viewModel.placeName ?? "",
                    postType: .scheduled
                )
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
