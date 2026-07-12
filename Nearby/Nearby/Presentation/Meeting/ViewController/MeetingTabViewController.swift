//
//  MeetingTabViewController.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine
import UIKit

final class MeetingTabViewController: BaseViewController<MeetingTabViewModel> {

    // MARK: - UI Component

    private let meetingTabView = MeetingTabView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?

    // MARK: - Life Cycles

    override func loadView() {
        view = meetingTabView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods
    
    override func setAddTarget() {
        meetingTabView.onNotificationButtonDidTap = { [weak self] in
            self?.coordinator?.showNotification()
        }
        meetingTabView.onSearchButtonDidTap = { [weak self] in
            self?.coordinator?.showCompanionTab()
        }
    }
    
    override func setDelegate() {
        meetingTabView.collectionView.dataSource = self
    }
    
    override func bindState() {
        viewModel.output.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.meetingTabView.updateState(isEmpty: items.isEmpty)
                self?.meetingTabView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Method

    private func setCollectionView() {
        meetingTabView.collectionView.register(
            MeetingVerificationCell.self,
            forCellWithReuseIdentifier: MeetingVerificationCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension MeetingTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MeetingVerificationCell.identifier,
            for: indexPath
        ) as? MeetingVerificationCell else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.item(at: indexPath.item)
        cell.configure(with: item)
        
        cell.onNextButtonDidTap = { [weak self] in
            self?.coordinator?.showMeetingProgress(for: item)
        }

        cell.onVerifyButtonDidTap = { [weak self] in
            self?.coordinator?.showMeetingProgress(for: item)
        }
        return cell
    }
}
