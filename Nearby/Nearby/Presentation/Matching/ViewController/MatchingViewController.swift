//
//  MatchingViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import Combine
import UIKit

final class MatchingViewController: BaseViewController<MatchingViewModel> {

    // MARK: - Properties

    weak var coordinator: MatchingCoordinator?
    private let matchedCardView = MatchedCardCollectionView()

    // MARK: - Life Cycles

    override func loadView() {
        view = matchedCardView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Methods

    override func setDelegate() {
        matchedCardView.matchedCardCollectionView.dataSource = self
        matchedCardView.matchedCardCollectionView.delegate = self
    }

    override func setAddTarget() {
        matchedCardView.findCompanionButton.addTarget(
            self,
            action: #selector(findCompanionButtonDidTap),
            for: .touchUpInside
        )
        matchedCardView.alarmButtonAction = { [weak self] in
            self?.viewModel.action(.alarmButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.matchedCardView.updateEmptyState(isEmpty: items.isEmpty)
                self?.matchedCardView.matchedCardCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.showScheduleDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.coordinator?.showScheduleDetail(item: item)
            }
            .store(in: &cancellables)

        viewModel.output.showAlarm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showAlarm()
            }
            .store(in: &cancellables)

        viewModel.output.showCompanionTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showCompanionTab()
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }

    // MARK: - Action

    @objc
    private func findCompanionButtonDidTap() {
        viewModel.action(.findCompanionButtonDidTap)
    }
}

// MARK: - UICollectionViewDataSource

extension MatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MatchingMatchedCardCell.self, for: indexPath)
        let item = viewModel.item(at: indexPath.item)

        cell.configure(content: item.content)
        cell.onNextButtonDidTap = { [weak self] in
            self?.viewModel.action(.cardDidTap(indexPath.item))
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.cardDidTap(indexPath.item))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 110)
    }
}
