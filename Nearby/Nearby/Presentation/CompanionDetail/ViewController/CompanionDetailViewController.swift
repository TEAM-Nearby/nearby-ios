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
    private let initialLoadingTracker = InitialLoadingTracker()
    
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

        companionDetailView.onHostProfileDidTap = { [weak self] in
            self?.viewModel.action(.hostProfileDidTap)
        }
    }
    
    override func setDelegate() {
        companionDetailView.scrollView.delegate = self
        companionDetailView.tagCollectionView.dataSource = self
        companionDetailView.tagCollectionView.delegate = self
    }
    
    override func bindState() {
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let self else { return }

                switch viewState {
                case .idle:
                    break
                case .loading(let state):
                    configure(state)
                case .loaded(let state):
                    initialLoadingTracker.complete(in: self)
                    configure(state)
                case .failed(let error):
                    initialLoadingTracker.complete(in: self)
                    AppLogger.error(error)
                }
            }
            .store(in: &cancellables)

        viewModel.output.applyError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let self {
                    initialLoadingTracker.complete(in: self)
                }
                AppLogger.error(error)
            }
            .store(in: &cancellables)

        viewModel.output.isApplying
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isApplying in
                self?.companionDetailView.setApplying(isApplying)
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
        initialLoadingTracker.begin(in: self)
    }

    private func configure(_ state: CompanionDetailState) {
        tags = state.tags
        companionDetailView.configure(state: state)
        companionDetailView.tagCollectionView.reloadData()
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
