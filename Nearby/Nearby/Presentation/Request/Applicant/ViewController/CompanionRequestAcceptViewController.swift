//
//  CompanionRequestAcceptViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class CompanionRequestAcceptViewController: BaseViewController<CompanionRequestAcceptViewModel> {

    // MARK: - UI Components

    private let companionRequestAcceptView = CompanionRequestAcceptView()

    // MARK: - Life Cycles

    override func loadView() {
        view = companionRequestAcceptView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func addTarget() {
        companionRequestAcceptView.onConfirmButtonDidTap = { [weak self] in
            self?.viewModel.action(.confirmButtonDidTap)
        }

        companionRequestAcceptView.onEnterChatButtonDidTap = { [weak self] in
            self?.viewModel.action(.enterChatButtonDidTap)
        }

        companionRequestAcceptView.onChatHelpButtonDidTap = { [weak self] in
            self?.viewModel.action(.chatHelpButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.companionRequestAcceptView.configure(with: data)
            }
            .store(in: &cancellables)

        viewModel.output.step
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                self?.companionRequestAcceptView.updateStep(step)
            }
            .store(in: &cancellables)

        viewModel.output.showOpenChat
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
