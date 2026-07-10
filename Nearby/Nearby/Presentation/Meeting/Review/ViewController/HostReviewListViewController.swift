//
//  HostReviewListViewController.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class HostReviewListViewController: BaseViewController<HostReviewListViewModel> {
    
    // MARK: - UI Component
    
    private let hostReviewListView = HostReviewListView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = hostReviewListView
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        hostReviewListView.onCompletionButtonDidTap = { [weak self] in
            self?.viewModel.action(.completionButtonDidTap)
        }
    }
    
    override func bindState() {
        viewModel.output.headerInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.hostReviewListView.configure(
                    people: info.people,
                    information: info.information,
                    location: info.location,
                    avatarImages: info.avatarImages
                )
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.output.items, viewModel.output.reviewedIDs)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items, reviewedIDs in
                self?.hostReviewListView.setReviewList(items, reviewedIDs: reviewedIDs) { item in
                    self?.viewModel.action(.profileDidTap(item))
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.showReviewWrite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item, isLast in
                self?.coordinator?.showReviewPost(for: item, type: .host, isLast: isLast) { [weak self] in
                    self?.viewModel.action(.reviewSaved(item))
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.showCompletion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.finishCompanonReview()
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
