//
//  CompanionDetailViewController.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import Combine
import UIKit

final class CompanionDetailViewController: BaseViewController<CompanionDetailViewModel> {

    // MARK: - UI Component

    private let companionDetailView = CompanionDetailView()

    // MARK: - Life Cycle

    override func loadView() {
        view = companionDetailView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setStyle() {
        view.backgroundColor = .bgDefaultGrey
    }

    override func setAddTarget() {
        companionDetailView.onBackButtonDidTap = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        companionDetailView.onApplyButtonDidTap = { [weak self] in
            self?.viewModel.action(.applyButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.companionDetailView.configure(state: state)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
