//
//  MatchingScheduleDetailViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import UIKit

import KakaoSDKShare

final class MatchingScheduleDetailViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Properties

    weak var coordinator: MatchingCoordinator?
    private let rootView = MatchingScheduleDetailView()
    private let item: MatchingMatchedCardItem

    // MARK: - Initializer

    init(item: MatchingMatchedCardItem) {
        self.item = item
        super.init(viewModel: EmptyViewModel())
    }

    convenience init() {
        self.init(item: MatchingMatchedCardItem.sample)
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

    override func setStyle() {
        rootView.configure(item: item)
    }

    override func setAddTarget() {
        rootView.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        rootView.alarmButtonAction = {
            // TODO: - 알림뷰 연결
        }

        rootView.editButtonAction = { [weak self] in
            guard let self else { return }
            coordinator?.showManageScheduleDetail(item: item)
        }

        rootView.shareButtonAction = { [weak self] in
            self?.share()
        }
    }

    func share() {
        guard ShareApi.isKakaoTalkSharingAvailable() else {
            if let url = ShareApi.shared.makeCustomUrl(templateId: 135202) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                print("url 성공")
            } else {
                print("Failed to create Kakao sharer URL.")
            }
            return
        }

        ShareApi.shared.shareCustom(templateId: 135202) { sharingResult, error in
            if let error {
                print(error)
                print("에러 발생")
                return
            }

            print("shareCustom() success.")
            if let sharingResult {
                UIApplication.shared.open(sharingResult.url, options: [:]) { success in
                    if success == false {
                        print("Failed to open KakaoTalk sharing URL: \(sharingResult.url)")
                    }
                }
            }
        }
    }
}
