//
//  HostRequestAllowViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestAllowViewController: BaseViewController<HostRequestAllowViewModel> {
    
    // MARK: - UI Component
    
    private let hostRequestAllowView = HostRequestAllowView()
    
    // MARK: - Property
    
    weak var coordinator: NotificationCoordinator?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = hostRequestAllowView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        hostRequestAllowView.onConfirmButtonDidTap = { [weak self] in
            self?.viewModel.action(.confirmButtonDidTap)
        }
        
        hostRequestAllowView.onEnterChatButtonDidTap = { [weak self] in
            self?.viewModel.action(.enterChatButtonDidTap)
        }
        
        hostRequestAllowView.onChatHelpButtonDidTap = { [weak self] in
            self?.viewModel.action(.chatHelpButtonDidTap)
        }
    }
    
    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.hostRequestAllowView.configure(with: data)
            }
            .store(in: &cancellables)
        
        viewModel.output.step
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                self?.hostRequestAllowView.updateStep(step)
            }
            .store(in: &cancellables)
        
        viewModel.output.showScheduleDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - 서버 연동 시 데이터로 교체
                let mockItem = MatchingMatchedCardItem.sample
                self?.coordinator?.showMatchingScheduleDetail(item: mockItem)
            }
            .store(in: &cancellables)

        viewModel.output.showScheduleConfirm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                // TODO: - 서버 연동 시 데이터로 교체
                let mockItem = MatchingMatchedCardItem.sample
                self?.coordinator?.showMatchingManageDetail(item: mockItem)
            }
            .store(in: &cancellables)
        
        bindOpenChat(viewModel.output, cancellables: &cancellables) { [weak self] in
            self?.hostRequestAllowView.showLinkCopiedToast()
        }
        
        viewModel.action(.viewDidLoad)
    }
}
