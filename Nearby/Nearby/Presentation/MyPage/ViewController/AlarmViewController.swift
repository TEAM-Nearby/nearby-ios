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

        viewModel.action(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        alarmView.navigationBar.leftButtonAction = {
            [weak self] in

            self?.viewModel.action(.backButtonDidTap)
        }

        alarmView.sentRequestButton.addTarget(self, action: #selector(sentRequestButtonDidTap), for: .touchUpInside)

        alarmView.receivedRequestButton.addTarget(self, action: #selector(receivedRequestButtonDidTap), for: .touchUpInside)
    }

    override func setDelegate() {
        alarmView.requestTableView.dataSource = self
        alarmView.requestTableView.delegate = self
    }

    override func bindState() {
        viewModel.output.selectedTab = {
            [weak self] tab in

            self?.alarmView.updateSelectedTab(tab)
            self?.alarmView.scrollToTop()
        }

        viewModel.output.requestItems = {
            [weak self] items in

            guard let self else {
                return
            }

            requestItems = items
            alarmView.requestTableView.reloadData()
        }

        viewModel.output.backButtonDidTap = {
            [weak self] in

            self?.onBackButtonDidTap?()
        }

        viewModel.output.requestActionDidTap = {
            [weak self] requestItem in

            self?.onRequestActionDidTap?(requestItem)
        }
    }
}

// MARK: - UITableViewDataSource

extension AlarmViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return requestItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier:
                AlarmRequestTableViewCell.identifier,
            for: indexPath
        ) as? AlarmRequestTableViewCell else {
            return UITableViewCell()
        }

        let requestItem = requestItems[indexPath.row]

        cell.configure(with: requestItem)

        cell.onActionButtonDidTap = {
            [weak self] in

            self?.viewModel.action(
                .requestActionButtonDidTap(
                    id: requestItem.id
                )
            )
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlarmViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let requestItem = requestItems[indexPath.row]

        viewModel.action(
            .requestActionButtonDidTap(
                id: requestItem.id
            )
        )
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
