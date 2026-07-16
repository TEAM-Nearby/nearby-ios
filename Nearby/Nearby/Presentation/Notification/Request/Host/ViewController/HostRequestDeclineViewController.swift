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
    
    // MARK: - Property
    
    weak var coordinator: NotificationCoordinator?

    // MARK: - Life Cycles

    override func loadView() {
        view = hostRequestDeclineView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        addKeyboardDismissGesture()

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
                self?.coordinator?.showCompanionTab()
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
