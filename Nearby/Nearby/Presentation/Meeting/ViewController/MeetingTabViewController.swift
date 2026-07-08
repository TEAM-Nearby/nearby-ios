//
//  MeetingTabViewController.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import UIKit

final class MeetingTabViewController: UIViewController {

    // MARK: - Property

    private let meetingTabView = MeetingTabView()

    // TODO: - 테스트용 -> 뷰모델로 교체 예정
    private let items: [MeetingVerificationCellType] = [
        .verifiable, .notYet, .verifiable, .notYet
    ]

    // MARK: - Life Cycle

    override func loadView() {
        view = meetingTabView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }

    // MARK: - Method

    private func setCollectionView() {
        meetingTabView.collectionView.dataSource = self
        meetingTabView.collectionView.register(
            MeetingVerificationCell.self,
            forCellWithReuseIdentifier: MeetingVerificationCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension MeetingTabViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MeetingVerificationCell.identifier,
            for: indexPath
        ) as? MeetingVerificationCell else {
            return UICollectionViewCell()
        }
        cell.configure(type: items[indexPath.item])
        return cell
    }
}
