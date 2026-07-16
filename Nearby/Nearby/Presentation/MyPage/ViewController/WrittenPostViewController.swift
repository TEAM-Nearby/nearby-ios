//
//  WrittenPostViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import UIKit

final class WrittenPostViewController:
    BaseViewController<WrittenPostViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onFindCompanionButtonDidTap: (() -> Void)?

    private var writtenPostItems: [WrittenPostItem] = []

    // MARK: - UI Component

    private let writtenPostView = WrittenPostView()

    // MARK: - Life Cycles

    override func loadView() { view = writtenPostView }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        writtenPostView.playEmptyAnimationIfNeeded()
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        writtenPostView.navigationBar.leftButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        writtenPostView.findCompanionButton.addTarget(
            self, action: #selector(findCompanionButtonDidTap),
            for: .touchUpInside
        )
    }

    override func setDelegate() {
        writtenPostView.tableView.dataSource = self
        writtenPostView.tableView.delegate = self
    }

    override func bindState() {
        viewModel.output.writtenPostItems = { [weak self] items in

            guard let self else { return }

            writtenPostItems = items
            writtenPostView.tableView.reloadData()
            writtenPostView.updateContent(items: items)
        }

        viewModel.output.backButtonDidTap = { [weak self] in
            self?.onBackButtonDidTap?()
        }

        viewModel.output.findCompanionButtonDidTap = { [weak self] in
            self?.onFindCompanionButtonDidTap?()
        }
    }
    
    // MARK: - Action
    
    @objc
    func findCompanionButtonDidTap() {
        viewModel.action(.findCompanionButtonDidTap)
    }
}

// MARK: - UITableViewDataSource

extension WrittenPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writtenPostItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WrittenPostTableViewCell.identifier, for: indexPath) as? WrittenPostTableViewCell
        else {
            return UITableViewCell()
        }

        let item = writtenPostItems[indexPath.row]
        cell.configure(with: item)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension WrittenPostViewController: UITableViewDelegate { func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: false) } }

// MARK: - Action

private extension WrittenPostViewController {
    
}
