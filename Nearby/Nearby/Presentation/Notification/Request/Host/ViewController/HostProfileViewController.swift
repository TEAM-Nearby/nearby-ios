//
//  HostProfileViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/12/26.
//

import Combine
import UIKit

final class HostProfileViewController: BaseViewController<HostProfileViewModel> {

    // MARK: - UI Component

    private let hostProfileView = HostProfileView()

    // MARK: - Life Cycles

    override func loadView() {
        view = hostProfileView
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
        hostProfileView.onBackButtonDidTap = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        hostProfileView.onReviewChipDidTap = { [weak self] category, index in

            switch category {
            case .communication:
                self?.viewModel.action(.communicationChipDidTap(index: index))

            case .punctuality:
                self?.viewModel.action(.punctualityChipDidTap(index: index))
            }
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] displayData in
                self?.hostProfileView.configure(with: displayData)
            }
            .store(in: &cancellables)

        viewModel.output.selectedReviewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.hostProfileView.updateReviewChipSelection(
                    selectedCommunicationIndexes: state.selectedCommunicationIndexes,
                    selectedPunctualityIndexes: state.selectedPunctualityIndexes
                )
            }
            .store(in: &cancellables)

        viewModel.output.backButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
