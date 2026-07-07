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
        
        viewModel.action(.viewDidLoad)
    }
}
