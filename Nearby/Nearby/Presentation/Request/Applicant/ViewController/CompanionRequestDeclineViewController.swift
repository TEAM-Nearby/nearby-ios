//
//  CompanionRequestDeclineViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit
import Combine

final class CompanionRequestDeclineViewController: BaseViewController<CompanionRequestDeclineViewModel> {

    // MARK: - UI Components

    private let rootView = CompanionRequestDeclineView()

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func addTarget() {
        rootView.onBackButtonDidTap = { [weak self] in
                // TODO: - Coordinator 연결 (뒤로가기)
                self?.navigationController?.popViewController(animated: true)
            }
        
        rootView.onWriteButtonDidTap = { [weak self] in
            self?.viewModel.action(.writeButtonDidTap)
        }
        rootView.onSearchButtonDidTap = { [weak self] in
            self?.viewModel.action(.searchButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.rootView.configure(with: data)
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
