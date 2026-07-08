//
//  HostReviewListViewController.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class HostReviewListViewController: BaseViewController<HostReviewListViewModel> {
    
    private let hostReviewListView = HostReviewListView()
    weak var coordinator: MeetingTabCoordinator?
    
    override func loadView() {
        view = hostReviewListView
    }
    
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
                    location: info.location
                )
            }
            .store(in: &cancellables)
        
        viewModel.output.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.hostReviewListView.setReviewList(items) { item in
                    self?.viewModel.action(.profileDidTap(item))
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.showReviewWrite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                // TODO: - Coordinator 연결 (후기 작성 화면)
                _ = item
            }
            .store(in: &cancellables)
        
        viewModel.output.showCompletion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - Coordinator 연결
            }
            .store(in: &cancellables)
        
        viewModel.action(.viewDidLoad)
    }
}
