//
//  MatchingScheduleDetailViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import UIKit

import KakaoSDKShare

final class MatchingScheduleDetailViewController: BaseViewController<MatchingScheduleDetailViewModel> {

    // MARK: - Properties

    weak var coordinator: MatchingCoordinator?
    private let rootView = MatchingScheduleDetailView()

    // MARK: - Initializer

    init(item: MatchingMatchedCardItem) {
        super.init(viewModel: MatchingScheduleDetailViewModel(item: item))
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Methods

    override func setAddTarget() {
        rootView.backButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        rootView.alarmButtonAction = { [weak self] in
            self?.viewModel.action(.alarmButtonDidTap)
        }

        rootView.editButtonAction = { [weak self] in
            self?.viewModel.action(.editButtonDidTap)
        }

        rootView.shareButtonAction = { [weak self] in
            self?.viewModel.action(.shareButtonDidTap)
        }
    }

    override func bindState() {
        viewModel.output.displayData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] displayData in
                self?.rootView.configure(displayData: displayData)
            }
            .store(in: &cancellables)

        viewModel.output.showBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.output.showAlarm
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showAlarm()
            }
            .store(in: &cancellables)

        viewModel.output.showEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.coordinator?.showManageScheduleDetail(item: item)
            }
            .store(in: &cancellables)

        viewModel.output.showShare
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.share()
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }

    private func share() {
        guard ShareApi.isKakaoTalkSharingAvailable() else {
            if let url = ShareApi.shared.makeCustomUrl(templateId: 135202) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                AppLogger.error(
                    AppError.apiError(message: "카카오톡 공유 URL 생성에 실패했습니다.")
                )
            }
            return
        }

        ShareApi.shared.shareCustom(templateId: 135202) { sharingResult, error in
            if let error {
                AppLogger.error(error, message: "카카오톡 공유에 실패했습니다.")
                return
            }

            if let sharingResult {
                UIApplication.shared.open(sharingResult.url, options: [:]) { success in
                    if success == false {
                        AppLogger.error(
                            AppError.apiError(
                                message: "카카오톡 공유 URL 열기에 실패했습니다: \(sharingResult.url)"
                            )
                        )
                    }
                }
            }
        }
    }
}
