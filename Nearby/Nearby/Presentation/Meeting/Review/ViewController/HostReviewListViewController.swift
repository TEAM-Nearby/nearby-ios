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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewWillAppear)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.action(.viewDidDisappear)
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

        viewModel.output.hasUnreadNotifications
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasUnread in
                self?.hostReviewListView.updateAlarm(hasUnread: hasUnread)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .merge(with: NotificationCenter.default.publisher(for: .companionNotificationDidChange))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.action(.refreshNotifications)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
