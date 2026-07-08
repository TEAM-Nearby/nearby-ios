//
//  MeetingTabViewController.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine
import UIKit

final class MeetingTabViewController: UIViewController {

    // MARK: - Properties

    private let meetingTabView = MeetingTabView()
    private let viewModel = MeetingTabViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Life Cycle

    override func loadView() {
        view = meetingTabView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        bind()
        viewModel.load()
    }

    // MARK: - Methods

    private func setCollectionView() {
        meetingTabView.collectionView.dataSource = self
        meetingTabView.collectionView.register(
            MeetingVerificationCell.self,
            forCellWithReuseIdentifier: MeetingVerificationCell.identifier
        )
    }
    
    private func bind() {
        viewModel.$cellTypes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.meetingTabView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension MeetingTabViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.cellTypes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MeetingVerificationCell.identifier,
            for: indexPath
        ) as? MeetingVerificationCell else {
            return UICollectionViewCell()
        }
        cell.configure(type: viewModel.cellTypes[indexPath.item])
        return cell
    }
}
