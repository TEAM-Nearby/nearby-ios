//
//  MatchingHostScheduleDetailViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

final class MatchingHostScheduleDetailViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Property

    private let rootView = MatchingManageScheduleDetailView()

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Method

    override func setAddTarget() {
        rootView.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        rootView.alarmButtonAction = {
            // TODO: - 알림 화면으로 이동
        }
    }
}
