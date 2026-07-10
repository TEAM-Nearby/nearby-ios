//
//  HostRequestDeclineViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestDeclineViewController: BaseViewController<HostRequestDeclineViewModel> {

    // MARK: - UI Component

    private let hostRequestDeclineView = HostRequestDeclineView()

    // MARK: - Life Cycle

    override func loadView() {
        view = hostRequestDeclineView
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        hostRequestDeclineView.onBackButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        hostRequestDeclineView.onRejectButtonDidTap = { [weak self] in
            let reason = self?.hostRequestDeclineView.rejectReasonText ?? ""
            self?.viewModel.action(.rejectButtonDidTap(reason: reason))
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.hostRequestDeclineView.configure(with: data)
            }
            .store(in: &cancellables)

        viewModel.output.showDeclineComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - Coordinator 연결 (거절 완료 화면 or 뒤로)
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
