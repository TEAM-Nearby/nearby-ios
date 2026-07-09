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
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = reviewPostView
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        reviewPostView.onRatingChanged = { [weak self] rating in
            self?.viewModel.action(.ratingChanged(rating))
        }
        reviewPostView.onTagsChanged = { [weak self] first, second in
            self?.viewModel.action(.tagsChanged(first: first, second: second))
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
                self?.reviewPostView.configure(name: data.name, information: data.information)
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
                // TODO: - Coordinator 연결 (신고 화면)
            }
            .store(in: &cancellables)
        
        viewModel.output.submitSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - Coordinator 연결 (후기 완료 후 이동)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
