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
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.rootView.configure(with: data)
            }
            .store(in: &cancellables)

        viewModel.output.showOpenChat
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - Coordinator 연결 (오픈채팅 뷰로 이동)
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
