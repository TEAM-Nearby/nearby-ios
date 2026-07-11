//
//  MatchingManageDetailViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import Combine
import UIKit

final class MatchingManageDetailViewController: BaseViewController<MatchingManageDetailViewModel> {

    // MARK: - Properties

    weak var coordinator: MatchingCoordinator?
    private let rootView = MatchingManageScheduleDetailView()

    // MARK: - Initializer

    init(item: MatchingMatchedCardItem) {
        super.init(viewModel: MatchingManageDetailViewModel(item: item))
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

    override func setAddTarget() {
        rootView.backButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        rootView.alarmButtonAction = { [weak self] in
            self?.viewModel.action(.alarmButtonDidTap)
        }

        rootView.dateDidChange = { [weak self] date in
            self?.viewModel.action(.dateDidChange(date))
        }

        rootView.confirmButtonAction = { [weak self] in
            self?.viewModel.action(.confirmButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] displayData in
                self?.rootView.configure(with: displayData)
            }
            .store(in: &cancellables)

        viewModel.output.dateButtonTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.rootView.updateDateAndTimeButtonTitle(title)
            }
            .store(in: &cancellables)

        viewModel.output.showBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.output.showAlarm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showAlarm()
            }
            .store(in: &cancellables)

        viewModel.output.submitSchedule
            .receive(on: DispatchQueue.main)
            .sink { request in
                // TODO: - 일정 확정 API 연결
<<<<<<< HEAD
                AppLogger.data(request)
=======
                print(request)
>>>>>>> origin/feat/#76
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
