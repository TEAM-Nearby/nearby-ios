//
//  ReviewPostViewController.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class ReviewPostViewController: BaseViewController<ReviewPostViewModel> {
    
    // MARK: - UI Component
    
    private let reviewPostView = ReviewPostView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = reviewPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgDefaultGrey
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        [reviewPostView.firstTagCollectionView,
         reviewPostView.secondTagCollectionView].forEach {
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
    override func setAddTarget() {
        reviewPostView.onRatingChanged = { [weak self] rating in
            self?.viewModel.action(.ratingChanged(rating))
        }
        reviewPostView.onReportButtonDidTap = { [weak self] in
            self?.viewModel.action(.reportButtonDidTap)
        }
        reviewPostView.onCompletionButtonDidTap = { [weak self] in
            self?.viewModel.action(.completionButtonDidTap)
        }
    }
    
    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.reviewPostView.configure(name: data.name, information: data.information, userType: data.type)
            }
            .store(in: &cancellables)
        
        viewModel.output.reloadFirstTags
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexes in
                self?.reloadItems(self?.reviewPostView.firstTagCollectionView, indexes)
            }
            .store(in: &cancellables)
        
        viewModel.output.reloadSecondTags
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexes in
                self?.reloadItems(self?.reviewPostView.secondTagCollectionView, indexes)
            }
            .store(in: &cancellables)
        
        viewModel.output.isCompletionEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.reviewPostView.updateCompletionButton(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.output.showReport
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showReportPost()
            }
            .store(in: &cancellables)
        
        viewModel.output.submitSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Method
    
    private func reloadItems(_ collectionView: UICollectionView?, _ indexes: [Int]) {
        guard let collectionView, !indexes.isEmpty else { return }
        let paths = indexes.map { IndexPath(item: $0, section: 0) }
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: paths)
            collectionView.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ReviewPostViewController: UICollectionViewDataSource {
    private func titles(for collectionView: UICollectionView) -> [String] {
        collectionView === reviewPostView.firstTagCollectionView
            ? viewModel.firstTagTitles : viewModel.secondTagTitles
    }
    
    private func selectedIndexes(for collectionView: UICollectionView) -> Set<Int> {
        collectionView === reviewPostView.firstTagCollectionView
            ? viewModel.firstSelectedTags : viewModel.secondSelectedTags
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        titles(for: collectionView).count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NearbyTextChipCollectionViewCell = collectionView.dequeueReusableCell(
            NearbyTextChipCollectionViewCell.self, for: indexPath
        )
        let titles = titles(for: collectionView)
        let isSelected = selectedIndexes(for: collectionView).contains(indexPath.item)
        let style: NearbyChipStyle = isSelected ? .tagStateSelected : .tagStateUnselected
        cell.configure(style: style, title: titles[indexPath.item], horizontalInset: 12)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ReviewPostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView === reviewPostView.firstTagCollectionView {
            viewModel.action(.firstTagTapped(indexPath.item))
        } else {
            viewModel.action(.secondTagTapped(indexPath.item))
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = titles(for: collectionView)[indexPath.item]
        let font = NearbyChipStyle.tagStateUnselected.font
        let titleWidth = (title as NSString).size(withAttributes: [.font: font]).width
        let horizontalInset: CGFloat = 24
        return CGSize(
            width: ceil(titleWidth + horizontalInset),
            height: NearbyChipStyle.tagStateUnselected.height
        )
    }
}
