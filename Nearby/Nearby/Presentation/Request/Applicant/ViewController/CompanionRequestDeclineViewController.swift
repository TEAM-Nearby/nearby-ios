//
//  CompanionRequestDeclineViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class CompanionRequestDeclineViewController: BaseViewController<CompanionRequestDeclineViewModel> {

    // MARK: - UI Components

    private let companionRequestDeclineView = CompanionRequestDeclineView()

    // MARK: - Life Cycles

    override func loadView() {
        view = companionRequestDeclineView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods
    
    override func setAddTarget() {
        companionRequestDeclineView.onBackButtonDidTap = { [weak self] in
            // TODO: - Coordinator 연결 (뒤로가기)
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
                // TODO: - CoorDinator 연결 (동행 글 작성으로 이동)
                self?.navigationController?.popToRootViewController(animated: true)
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
