//
//  AppIntroductionViewController.swift
//  Nearby
//
//  Created by soomin on 10/2/26.
//

import UIKit

final class AppIntroductionViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Properties

    var onAppIntroductionCompleted: (() -> Void)?
    private let pages: [AppIntroductionPage]

    // MARK: - UI Components

    private let appIntroductionView = AppIntroductionView()

    // MARK: - Initializer

    init(pages: [AppIntroductionPage] = AppIntroductionPage.pages) {
        self.pages = pages
        super.init(viewModel: EmptyViewModel())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = appIntroductionView
    }

    // MARK: - Custom Methods

    override func setStyle() {
        view.backgroundColor = .bgDefaultGrey
    }

    override func setAddTarget() {
        appIntroductionView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }

    override func setDelegate() {
        appIntroductionView.collectionView.dataSource = self
        appIntroductionView.collectionView.delegate = self
        appIntroductionView.configure(numberOfPages: pages.count)
    }
    
    // MARK: - Method
    
    private func updateCurrentPage(for scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }

        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        let validPage = min(max(page, 0), max(pages.count - 1, 0))
        appIntroductionView.updateCurrentPage(validPage)
    }

    // MARK: - Action

    @objc
    private func startButtonDidTap() {
        onAppIntroductionCompleted?()
    }
}

// MARK: - UICollectionViewDataSource

extension AppIntroductionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(AppIntroductionPageCell.self, for: indexPath)

        cell.configure(with: pages[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppIntroductionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentPage(for: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage(for: scrollView)
    }
}
