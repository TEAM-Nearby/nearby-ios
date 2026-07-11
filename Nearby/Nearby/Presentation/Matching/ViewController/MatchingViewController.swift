//
//  MatchingViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

final class MatchingViewController: UIViewController {

    // MARK: - Properties

    weak var coordinator: MatchingCoordinator?
    private let matchedCardView = MatchedCardCollectionView()
    private var cardItems: [MatchingMatchedCardItem] = [
        MatchingMatchedCardItem(
            content: MatchingMatchedCardContentModel(
                profileImage: .imgProfileDefault, name: "정지영", participantCount: 2, gender: "여성",
                uploadedTime: "15분 전 올림", place: "시우다드 콘달", meetingTime: "오후 4:30",
                description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분..."
            ),
            state: .pending,
            isHost: false
        ),
        MatchingMatchedCardItem(
            content: MatchingMatchedCardContentModel(
                profileImage: .imgProfileDefault, name: "정지영", participantCount: 2, gender: "여성",
                uploadedTime: "15분 전 올림", place: "시우다드 콘달", meetingTime: "오후 4:30",
                description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분..."
            ),
            state: .pending,
            isHost: true
        ),
        MatchingMatchedCardItem(
            content: MatchingMatchedCardContentModel(
                profileImage: .imgProfileDefault, name: "정지영", participantCount: 2, gender: "여성",
                uploadedTime: "15분 전 올림", place: "시우다드 콘달", meetingTime: "오후 4:30",
                description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분..."
            ),
            state: .confirmed,
            isHost: true
        )
    ]
    private var displayCardItems: [MatchingMatchedCardItem] {
        return cardItems.sorted {
            $0.state.displayPriority < $1.state.displayPriority
        }
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = matchedCardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        setAddTarget()
        updateViewState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Methods

    private func setDelegate() {
        matchedCardView.matchedCardCollectionView.dataSource = self
        matchedCardView.matchedCardCollectionView.delegate = self
    }

    private func setAddTarget() {
        matchedCardView.findCompanionButton.addTarget(self, action: #selector(findCompanionButtonDidTap), for: .touchUpInside)
    }

    private func updateViewState() {
        matchedCardView.updateEmptyState(isEmpty: displayCardItems.isEmpty)
    }

    private func updateCardItems(_ items: [MatchingMatchedCardItem]) {
        cardItems = items
        matchedCardView.matchedCardCollectionView.reloadData()
        updateViewState()
    }

    private func matchingCardDidTap(item: MatchingMatchedCardItem) {
        coordinator?.showScheduleDetail(item: item)
    }

    // MARK: - Action

    @objc
    private func findCompanionButtonDidTap() {
        // TODO: - 동행 찾기 뷰 연결
    }
}

// MARK: - UICollectionViewDataSource

extension MatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayCardItems.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MatchingMatchedCardCell.self, for: indexPath)
        let item = displayCardItems[indexPath.item]

        cell.configure(content: item.content, state: item.state)
        cell.onNextButtonDidTap = { [weak self] in
            self?.matchingCardDidTap(item: item)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = displayCardItems[indexPath.item]
        matchingCardDidTap(item: item)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let state = displayCardItems[indexPath.item].state
        let height: CGFloat = state == .confirmed ? 148 : 110

        return CGSize(width: collectionView.bounds.width, height: height)
    }
}
