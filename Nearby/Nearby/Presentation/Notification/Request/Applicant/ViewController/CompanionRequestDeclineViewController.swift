//
//  CompanionRequestDeclineViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class CompanionRequestDeclineViewController: BaseViewController<CompanionRequestDeclineViewModel> {
    
    // MARK: - UI Component
    
    private let companionRequestDeclineView = CompanionRequestDeclineView()
    
    // MARK: - Property
    
    weak var coordinator: NotificationCoordinator?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = companionRequestDeclineView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        companionRequestDeclineView.restartAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Custom Methods
    
    override func setAddTarget() {
        companionRequestDeclineView.onBackButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        companionRequestDeclineView.onWriteButtonDidTap = { [weak self] in
            self?.viewModel.action(.writeButtonDidTap)
        }
        companionRequestDeclineView.onSearchButtonDidTap = { [weak self] in
            self?.viewModel.action(.searchButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.companionRequestDeclineView.configure(with: data)
            }
            .store(in: &cancellables)
    
        viewModel.output.showWriteCompanionHost
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showRecruitCompanion()
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
