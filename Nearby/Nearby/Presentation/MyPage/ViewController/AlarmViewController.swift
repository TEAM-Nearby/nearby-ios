//
//  AlarmViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import Combine
import UIKit

final class AlarmViewController: BaseViewController<AlarmViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?

    weak var coordinator: NotificationCoordinator?

    private var items = [AlarmRequestItem]()
    private var hasAppearedOnce = false

    // MARK: - UI Component

    private let alarmView = AlarmView()

    // MARK: - Life Cycles

    override func loadView() {
        view = alarmView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)

        if hasAppearedOnce {
            viewModel.action(.viewWillAppear)
        } else {
            hasAppearedOnce = true
        }
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        alarmView.navigationBar.leftButtonAction = { [weak self] in
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
        bindSelectedTab()
        bindItems()
        bindNavigation()
        bindError()

        viewModel.action(.viewDidLoad)
    }
}

// MARK: - Bind

private extension AlarmViewController {

    func bindSelectedTab() {
        viewModel.output.selectedTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedTab in
                guard let self else { return }

                alarmView.updateSelectedTab(selectedTab)
                alarmView.updateContent(items: items, selectedTab: selectedTab)
                alarmView.scrollToTop()
            }
            .store(in: &cancellables)
    }

    func bindItems() {
        viewModel.output.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self else { return }

                self.items = items

                alarmView.requestTableView.reloadData()
                alarmView.updateContent(items: items, selectedTab: viewModel.output.selectedTab.value)
            }
            .store(in: &cancellables)
    }

    func bindNavigation() {
        viewModel.output.backButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onBackButtonDidTap?()
            }
            .store(in: &cancellables)

        viewModel.output.showCompanionRequestAccept
            .receive(on: DispatchQueue.main)
            .sink { [weak self] applicationId in
                self?.coordinator?.showCompanionRequestAccept(applicationId: applicationId)
            }
            .store(in: &cancellables)

        viewModel.output.showCompanionRequestDecline
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showCompanionRequestDecline()
            }
            .store(in: &cancellables)

        viewModel.output.showHostRequestReceive
            .receive(on: DispatchQueue.main)
            .sink { [weak self] applicationId in
                self?.coordinator?.showHostRequestRecieve(applicationId: applicationId)
            }
            .store(in: &cancellables)

        viewModel.output.showSchedule
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchId in
                self?.coordinator?.showMatchingScheduleDetail(matchId: matchId)
            }
            .store(in: &cancellables)
    }

    func bindError() {
        viewModel.output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension AlarmViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AlarmRequestTableViewCell.identifier,
            for: indexPath
        ) as? AlarmRequestTableViewCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]

        cell.configure(with: item)

        cell.onActionButtonDidTap = { [weak self] in
            self?.viewModel.action(.actionButtonDidTap(item))
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlarmViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard items.indices.contains(indexPath.row) else {
            return
        }

        let item = items[indexPath.row]

        viewModel.action(.actionButtonDidTap(item))
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
