//
//  MyPageViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

final class MyPageViewController:
    BaseViewController<MyPageViewModel> {

    // MARK: - Properties

    var onAlarmButtonDidTap: (() -> Void)?
    var onSettingButtonDidTap: (() -> Void)?
    var onWrittenPostRowDidTap: (() -> Void)?
    var onSentRequestRowDidTap: (() -> Void)?
    var onReceivedRequestRowDidTap: (() -> Void)?

    // MARK: - UI Component

    private let myPageView = MyPageView()

    // MARK: - Life Cycles

    override func loadView() {
        view = myPageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        myPageView.navigationBar.rightFirstButtonAction = { [weak self] in
            self?.viewModel.action(.alarmButtonDidTap)
        }

        myPageView.navigationBar.rightSecondButtonAction = { [weak self] in
            self?.viewModel.action(.settingButtonDidTap)
        }

        myPageView.onWrittenPostRowDidTap = { [weak self] in
            self?.viewModel.action(.writtenPostRowDidTap)
        }

        myPageView.onSentRequestRowDidTap = { [weak self] in
            self?.viewModel.action(.sentRequestRowDidTap)
        }

        myPageView.onReceivedRequestRowDidTap = { [weak self] in
            self?.viewModel.action(.receivedRequestRowDidTap)
        }
    }

    override func bindState() {
        viewModel.output.alarmButtonDidTap = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }

        viewModel.output.settingButtonDidTap = { [weak self] in
            self?.onSettingButtonDidTap?()
        }

        viewModel.output.writtenPostRowDidTap = { [weak self] in
            self?.onWrittenPostRowDidTap?()
        }

        viewModel.output.sentRequestRowDidTap = { [weak self] in
            self?.onSentRequestRowDidTap?()
        }

        viewModel.output.receivedRequestRowDidTap = { [weak self] in
            self?.onReceivedRequestRowDidTap?()
        }
    }
}
