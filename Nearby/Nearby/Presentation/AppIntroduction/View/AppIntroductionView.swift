//
//  AppIntroductionView.swift
//  Nearby
//
//  Created by soomin on 10/2/26.
//

import UIKit

import SnapKit
import Then

final class AppIntroductionView: BaseView {
    
    // MARK: - UI Components
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let startButton = NearbyButton(style: .primary, title: "동행 시작하기")
    private let bottomContainerView = UIView()
    private let pageControl = UIPageControl()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .bgDefaultGrey
        
        collectionView.do {
            guard let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.backgroundColor = .bgDefaultGrey
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.alwaysBounceHorizontal = false
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        bottomContainerView.do {
            $0.backgroundColor = .white
        }
        
        pageControl.do {
            $0.numberOfPages = 0
            $0.currentPage = 0
            $0.currentPageIndicatorTintColor = .primary50
            $0.pageIndicatorTintColor = .grey10
            $0.isUserInteractionEnabled = false
            $0.hidesForSinglePage = true
        }
        
        startButton.do {
            $0.isEnabled = false
        }
    }
    
    override func setUI() {
        addSubviews(collectionView, bottomContainerView)
        bottomContainerView.addSubviews(pageControl, startButton)
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomContainerView.snp.top)
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func registerCells() {
        collectionView.register(AppIntroductionPageCell.self)
    }
    
    // MARK: - Methods
    
    func configure(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
        updateCurrentPage(0)
    }
    
    func updateCurrentPage(_ page: Int) {
        pageControl.currentPage = page
        startButton.isEnabled = pageControl.numberOfPages > 0 && page == pageControl.numberOfPages - 1
    }
}
