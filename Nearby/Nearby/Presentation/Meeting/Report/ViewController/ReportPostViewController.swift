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
    
    private lazy var reportPostView = ReportPostView(detailPlaceholder: viewModel.detailPlaceholder)
    
    // MARK: - Property
    
    var onRoute: ((MeetingRoute) -> Void)?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = reportPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setKeyboardObserver()
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        reportPostView.reasonTableView.dataSource = self
        reportPostView.reasonTableView.delegate = self
    }
    
    override func setAddTarget() {
        setKeyboardDismissGesture()

        reportPostView.onBackButtonDidTap = { [weak self] in
            self?.onRoute?(.previous)
        }
        
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

        viewModel.output.detailPlaceholder
            .receive(on: DispatchQueue.main)
            .sink { [weak self] placeholder in
                self?.reportPostView.updateDetailPlaceholder(placeholder)
            }
            .store(in: &cancellables)

        viewModel.output.clearDetailText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.reportPostView.clearDetailText()
            }
            .store(in: &cancellables)
        
        viewModel.output.submitSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onRoute?(.reportCompletion)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    private func setTableView() {
        reportPostView.reasonTableView.register(ReportReasonCell.self, forCellReuseIdentifier: ReportReasonCell.identifier)
    }

    private func setKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Actions

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        reportPostView.revealDetailInput(keyboardFrame: keyboardFrame)
    }

    @objc
    private func keyboardWillHide() {
        reportPostView.restoreContentOffset()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ReportPostViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        reportPostView.shouldDismissKeyboard(for: touch)
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
