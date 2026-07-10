//
//  AlarmViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

final class AlarmViewController:BaseViewController<AlarmViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onRequestActionDidTap: ((AlarmRequestItem) -> Void)?

    private var requestItems: [AlarmRequestItem] = []

    // MARK: - UI Component

    private let alarmView = AlarmView()

    // MARK: - Life Cycles

    override func loadView() {
        view = alarmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.action(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Method

    override func setAddTarget() {
        alarmView.navigationBar.leftButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        alarmView.sentRequestButton.addTarget(
            self, action: #selector(sentRequestButtonDidTap),
            for: .touchUpInside
        )

        alarmView.receivedRequestButton.addTarget(
            self, action: #selector(receivedRequestButtonDidTap),
            for: .touchUpInside
        )
    }
}

// MARK: - Private Method

private extension AlarmViewController {
    func bindViewModel() {
        viewModel.output.selectedRequestType = { [weak self] requestType in
            self?.alarmView.updateSelectedRequestType(requestType)
        }

        viewModel.output.backButtonDidTap = { [weak self] in
            self?.onBackButtonDidTap?()
        }
    }
}

// MARK: - Actions

private extension AlarmViewController {
    @objc
    func sentRequestButtonDidTap() {
        viewModel.action(.sentRequestButtonDidTap)
    }

    @objc
    func receivedRequestButtonDidTap() {
        viewModel.action(.receivedRequestButtonDidTap)
    }
}
