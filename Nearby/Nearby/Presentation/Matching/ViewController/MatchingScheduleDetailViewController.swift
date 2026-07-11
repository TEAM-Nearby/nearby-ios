//
//  MatchingScheduleDetailViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import UIKit

final class MatchingScheduleDetailViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Properties

    weak var coordinator: MatchingCoordinator?
    private let rootView = MatchingScheduleDetailView()
    private let item: MatchingMatchedCardItem

    // MARK: - Initializer

    init(item: MatchingMatchedCardItem) {
        self.item = item
        super.init(viewModel: EmptyViewModel())
    }

    convenience init() {
        self.init(item: MatchingMatchedCardItem.sample)
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Methods

    override func setStyle() {
        rootView.configure(item: item)
    }

    override func setAddTarget() {
        rootView.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        rootView.alarmButtonAction = {
            // TODO: - 알림뷰 연결
        }

        rootView.editButtonAction = { [weak self] in
            guard let self else { return }
            coordinator?.showManageScheduleDetail(item: item)
        }

        rootView.shareButtonAction = {
            // TODO: - 카카오톡 공유하기 SDK 연결
        }
    }
}
