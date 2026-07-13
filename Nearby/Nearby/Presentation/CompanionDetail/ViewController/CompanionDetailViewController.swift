//
//  CompanionDetailViewController.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import Combine
import UIKit

final class CompanionDetailViewController: BaseViewController<CompanionDetailViewModel> {
    
    // MARK: - Properties
    
    private var tags: [String] = []
    
    // MARK: - UI Component
    
    private let companionDetailView = CompanionDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = companionDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Custom Methods
    
    override func setStyle() {
        view.backgroundColor = .bgDefaultGrey
    }
    
    override func setAddTarget() {
        companionDetailView.onBackButtonDidTap = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }
        
        companionDetailView.onApplyButtonDidTap = { [weak self] in
            self?.viewModel.action(.applyButtonDidTap)
        }
    }
    
    override func setDelegate() {
        companionDetailView.scrollView.delegate = self
        companionDetailView.tagCollectionView.dataSource = self
        companionDetailView.tagCollectionView.delegate = self
    }
    
    override func bindState() {
        viewModel.output.displayState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.tags = state.tags
                self?.companionDetailView.configure(state: state)
                self?.companionDetailView.tagCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.error
            .sink { error in
                AppLogger.error(error)
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}

// MARK: - UIScrollViewDelegate

extension CompanionDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maximumOffsetY = max(-scrollView.adjustedContentInset.top, scrollView.contentSize.height
                                  - scrollView.bounds.height + scrollView.adjustedContentInset.bottom)
        
        scrollView.backgroundColor = scrollView.contentOffset.y >= maximumOffsetY ? .white : .bgDefaultGrey
    }
}

// MARK: - UICollectionViewDataSource

extension CompanionDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearbyTextChipCollectionViewCell.self, for: indexPath)
        cell.configure(style: .personalityOrange, title: tags[indexPath.item], horizontalInset: 16)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanionDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let style = NearbyChipStyle.personalityOrange
        let titleWidth = (tags[indexPath.item] as NSString).size(withAttributes: [.font: style.font]).width
        
        return CGSize(width: ceil(titleWidth + 32), height: style.height)
    }
}
