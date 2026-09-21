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

    var onRoute: ((MatchingRoute) -> Void)?
    private let rootView = MatchingManageScheduleDetailView()

    // MARK: - Initializer

    override init(viewModel: MatchingManageDetailViewModel) {
        super.init(viewModel: viewModel)
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
                self?.onRoute?(.previous)
            }
            .store(in: &cancellables)

        viewModel.output.showAlarm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onRoute?(.alarm)
            }
            .store(in: &cancellables)

        viewModel.output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "요청 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
