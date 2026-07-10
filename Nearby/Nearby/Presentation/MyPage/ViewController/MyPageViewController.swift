//
//  MyPageViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

final class MyPageViewController: BaseViewController<MyPageViewModel> {

    // MARK: - Properties

    var onAlarmButtonDidTap: (() -> Void)?
    var onSettingButtonDidTap: (() -> Void)?

    // MARK: - UI Component

    private let myPageView = MyPageView()

    // MARK: - Life Cycles

    override func loadView() {
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Method

    override func setAddTarget() {
        myPageView.navigationBar.rightFirstButtonAction = { [weak self] in
            self?.viewModel.action(.alarmButtonDidTap)
        }

        myPageView.navigationBar.rightSecondButtonAction = { [weak self] in
            self?.viewModel.action(.settingButtonDidTap)
        }
    }
}

// MARK: - Private Method

private extension MyPageViewController {
    func bindViewModel() {
        viewModel.output.alarmButtonDidTap = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }

        viewModel.output.settingButtonDidTap = { [weak self] in
            self?.onSettingButtonDidTap?()
        }
    }
}
