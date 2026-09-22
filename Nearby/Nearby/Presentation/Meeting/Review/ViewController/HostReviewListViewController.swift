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
    
    var onRoute: ((MeetingRoute) -> Void)?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = hostReviewListView
    }
    
    // MARK: - Custom Methods

    func reviewDidSave(_ item: ReviewItem) {
        viewModel.action(.reviewSaved(item))
    }
    
    override func setAddTarget() {
        hostReviewListView.onBackButtonDidTap = { [weak self] in
            self?.onRoute?(.previous)
        }
        hostReviewListView.onNotificationButtonDidTap = { [weak self] in
            self?.onRoute?(.notification)
        }
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
                    avatarImageUrls: info.avatarImageUrls
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
                self?.onRoute?(.hostReview(item, isLast))
            }
            .store(in: &cancellables)
        
        viewModel.output.showCompletion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onRoute?(.reviewCompletion)
            }
            .store(in: &cancellables)

        viewModel.output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                let alert = UIAlertController(title: "후기 대상을 불러오지 못했어요", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
