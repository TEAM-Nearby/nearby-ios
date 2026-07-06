//
//  CompanionRequestAcceptViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit
import Combine

final class CompanionRequestAcceptViewController: BaseViewController<CompanionRequestAcceptViewModel> {

    // MARK: - UI Components

    private let rootView = CompanionRequestAcceptView()

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    // MARK: - Custom Methods

    override func addTarget() {
        rootView.onConfirmButtonDidTap = { [weak self] in
            self?.viewModel.action(.confirmButtonDidTap)
        }

        rootView.onEnterChatButtonDidTap = { [weak self] in
            self?.viewModel.action(.enterChatButtonDidTap)
        }

        rootView.onChatHelpButtonDidTap = { [weak self] in
            self?.viewModel.action(.chatHelpButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.rootView.configure(with: data)
            }
            .store(in: &cancellables)

        viewModel.output.step
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                self?.rootView.updateStep(step)
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
