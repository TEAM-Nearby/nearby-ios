//
//  MatchingHostScheduleDetailViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

final class MatchingHostScheduleDetailViewController: UIViewController {

    // MARK: - Properties

    private let rootView = MatchingHostScheduleDetailView()

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Methods

    private func setAction() {
        rootView.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        rootView.alarmButtonAction = {
            // TODO: - 알림 화면으로 이동
        }
    }
}
