//
//  ReportPostViewController.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class ReportPostViewController: BaseViewController<ReportPostViewModel> {
    
    // MARK: - UI Component
    
    private let reportPostView = ReportPostView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = reportPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        reportPostView.reasonTableView.dataSource = self
        reportPostView.reasonTableView.delegate = self
    }
    
    override func setAddTarget() {
        reportPostView.onTextChanged = { [weak self] text in
            self?.viewModel.action(.detailTextChanged(text))
        }
        
        reportPostView.onReportButtonDidTap = { [weak self] in
            self?.viewModel.action(.reportButtonDidTap)
        }
    }
    
    override func bindState() {
        viewModel.output.reloadReasons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexes in
                let paths = indexes.map { IndexPath(row: $0, section: 0) }
                self?.reportPostView.reasonTableView.reloadRows(at: paths, with: .none)
            }
            .store(in: &cancellables)
        
        viewModel.output.isReportButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.reportPostView.updateReportButton(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.output.submitSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showReportComplete()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Method
    
    private func setTableView() {
        reportPostView.reasonTableView.register(ReportReasonCell.self, forCellReuseIdentifier: ReportReasonCell.identifier)
    }
}

// MARK: - UITableViewDataSource

extension ReportPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReportReasonCell.identifier,
            for: indexPath
        ) as? ReportReasonCell else { return UITableViewCell() }
        
        let reason = viewModel.reasons[indexPath.row]
        let isChecked = viewModel.selectedReasons.contains(indexPath.row)
        let isLast = indexPath.row == viewModel.reasons.count - 1
        
        cell.configure(title: reason.title, isChecked: isChecked, isLast: isLast)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ReportPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.action(.reasonDidTap(indexPath.row))
    }
}
