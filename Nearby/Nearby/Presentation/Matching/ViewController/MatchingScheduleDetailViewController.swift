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
    private let kakaoShareTemplateId: Int = 135215
    private var currentDisplayData: MatchingScheduleDetailDisplayData?
    
    // MARK: - Initializer
    
    override init(viewModel: MatchingScheduleDetailViewModel) {
        super.init(viewModel: viewModel)
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.action(.viewDidLoad)
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
                self?.currentDisplayData = displayData
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
            .sink { [weak self] displayData in
                self?.coordinator?.showManageScheduleDetail(displayData: displayData)
            }
            .store(in: &cancellables)
        
        viewModel.output.showShare
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let displayData = self?.currentDisplayData else { return }
                self?.share(displayData: displayData)
            }
            .store(in: &cancellables)
    }
    
    private func share(displayData: MatchingScheduleDetailDisplayData) {
        let templateArgs: [String: String] = [
            "time": displayData.scheduledAtText,
            "placeName": displayData.placeName,
            "name": displayData.cardItem.content.name
        ]

        // TODO: - 서버 응답 값으로 displayData 구성
        guard ShareApi.isKakaoTalkSharingAvailable() else {
            if let url = ShareApi.shared.makeCustomUrl(templateId: .init(kakaoShareTemplateId), templateArgs: templateArgs) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                AppLogger.error(
                    AppError.apiError(message: "카카오톡 공유 URL 생성에 실패했습니다.")
                )
            }
            return
        }

        ShareApi.shared.shareCustom(templateId: .init(kakaoShareTemplateId), templateArgs: templateArgs) { sharingResult, error in
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
