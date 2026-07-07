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

    // MARK: - Life Cycles

    override func loadView() {
        view = companionRequestSentView
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        companionRequestSentView.onBackButtonDidTap = { [weak self] in
                // TODO: - Coordinator 연결 (뒤로가기)
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
                // TODO: - Coordinator 연결 (동행 리스트로 이동)
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
