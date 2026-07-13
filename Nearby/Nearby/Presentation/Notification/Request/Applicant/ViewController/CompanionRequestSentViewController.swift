//
//  CompanionRequestSentViewController.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import Combine
import UIKit

final class CompanionRequestSentViewController: BaseViewController<CompanionRequestSentViewModel> {

    // MARK: - UI Component

    private let companionRequestSentView = CompanionRequestSentView()
    
    // MARK: - Property
    
    weak var coordinator: NotificationCoordinator?

    // MARK: - Life Cycles

    override func loadView() {
        view = companionRequestSentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        companionRequestSentView.onBackButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        companionRequestSentView.onSearchButtonDidTap = { [weak self] in
            self?.viewModel.action(.searchButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.companionRequestSentView.configure(with: data)
            }
            .store(in: &cancellables)

        viewModel.output.showCompanionList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showCompanionTab()
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
