//
//  MyPageViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

final class MyPageViewController: BaseViewController<MyPageViewModel> {

    // MARK: - Properties

    var onLoginRequired: ((Bool) -> Void)?
    var onAlarmButtonDidTap: (() -> Void)?
    var onSettingButtonDidTap: (() -> Void)?
    var onWrittenPostRowDidTap: (() -> Void)?
    var onSentRequestRowDidTap: (() -> Void)?
    var onReceivedRequestRowDidTap: (() -> Void)?
    private let initialLoadingTracker = InitialLoadingTracker()
    var onEditProfileRequested: ((Int) -> Void)?

    private let isGuest: Bool

    // MARK: - UI Component

    private lazy var myPageView = MyPageView(isGuest: isGuest)

    // MARK: - Initializer

    init(viewModel: MyPageViewModel, isGuest: Bool = false) {
        self.isGuest = isGuest
        super.init(viewModel: viewModel)
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = myPageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        guard !isGuest else { return }
        initialLoadingTracker.begin(in: self)
        viewModel.action(.viewWillAppear)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        myPageView.navigationBar.rightFirstButtonAction = { [weak self] in
            self?.performMemberAction(.alarmButtonDidTap)
        }

        myPageView.navigationBar.rightSecondButtonAction = { [weak self] in
            self?.viewModel.action(.settingButtonDidTap)
        }

        myPageView.onWrittenPostRowDidTap = { [weak self] in
            self?.performMemberAction(.writtenPostRowDidTap)
        }

        myPageView.onSentRequestRowDidTap = { [weak self] in
            self?.performMemberAction(.sentRequestRowDidTap)
        }

        myPageView.onReceivedRequestRowDidTap = { [weak self] in
            self?.performMemberAction(.receivedRequestRowDidTap)
        }
        
        myPageView.onEditProfileButtonDidTap = { [weak self] in
            self?.performMemberAction(.editProfileButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.myPageData = { [weak self] displayModel in
            guard let self else { return }
            initialLoadingTracker.complete(in: self)
            myPageView.configure(with: displayModel)
        }

        viewModel.output.errorMessage = { [weak self] message in
            guard let self else { return }
            initialLoadingTracker.complete(in: self)
            showErrorAlert(message: message)
        }
        
        viewModel.output.alarmButtonDidTap = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }

        viewModel.output.settingButtonDidTap = { [weak self] in
            self?.onSettingButtonDidTap?()
        }

        viewModel.output.writtenPostRowDidTap = { [weak self] in
            self?.onWrittenPostRowDidTap?()
        }

        viewModel.output.sentRequestRowDidTap = { [weak self] in
            self?.onSentRequestRowDidTap?()
        }

        viewModel.output.receivedRequestRowDidTap = { [weak self] in
            self?.onReceivedRequestRowDidTap?()
        }
        
        viewModel.output.editProfileRequested = { [weak self] profileID in
            self?.onEditProfileRequested?(profileID)
        }
    }
    
    // MARK: - Methods
    
    func performMemberAction(_ action: MyPageViewModel.Input) {
        guard isGuest else {
            viewModel.action(action)
            return
        }
        guard presentedViewController == nil else { return }
        let isGeneralFeature: Bool
        switch action {
        case .alarmButtonDidTap, .writtenPostRowDidTap, .sentRequestRowDidTap, .receivedRequestRowDidTap:
            isGeneralFeature = true
        default:
            isGeneralFeature = false
        }
        onLoginRequired?(isGeneralFeature)
    }

    func showErrorAlert(message: String) {
        guard presentedViewController == nil else {
            return
        }

        let alertController = UIAlertController(title: "마이페이지 조회 실패", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "확인", style: .default))

        present(alertController, animated: true)
    }
}
