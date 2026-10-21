//
//  SettingViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

final class SettingViewController: BaseViewController<SettingViewModel> {
    
    // MARK: - Properties
    
    var onBackButtonDidTap: (() -> Void)?
    var onLogoutButtonDidTap: (() -> Void)?
    var onAgreementButtonDidTap: (() -> Void)?
    var onWithdrawalDidComplete: (() -> Void)?
    
    // MARK: - UI Component
    
    private let settingView = SettingView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = settingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        settingView.navigationBar.leftButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }
        
        settingView.logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        settingView.withdrawalButton.addTarget(self, action: #selector(withdrawalButtonDidTap), for: .touchUpInside)
        settingView.agreementButton.addTarget(self, action: #selector(agreementButtonDidTap), for: .touchUpInside)
    }
    
    override func bindAction() {
        viewModel.output.backButtonDidTap = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        
        viewModel.output.logoutButtonDidTap = { [weak self] in
            self?.onLogoutButtonDidTap?()
        }
        
        viewModel.output.agreementButtonDidTap = { [weak self] in
            self?.onAgreementButtonDidTap?()
        }
        
        viewModel.output.isLogoutLoading = { [weak self] isLoading in
            self?.settingView.logoutButton.isEnabled = !isLoading
        }
        
        viewModel.output.withdrawalDidComplete = { [weak self] in
            self?.onWithdrawalDidComplete?()
        }

        viewModel.output.isWithdrawalLoading = { [weak self] isLoading in
            self?.settingView.withdrawalButton.isEnabled = !isLoading
        }
        
        viewModel.output.withdrawalErrorMessage = { [weak self] message in
            let alertController = UIAlertController(title: "회원 탈퇴 실패", message: message, preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "확인", style: .default))

            self?.present(alertController, animated: true)
        }
    }
    
    // MARK: - Method
    
    func showLogoutConfirmationAlert() {
        guard presentedViewController == nil else { return }
        
        let alertController = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alertController.addAction(UIAlertAction(title: "네", style: .default) { [weak self] _ in
            self?.viewModel.action(.logoutButtonDidTap)
        })
        present(alertController, animated: true)
    }
    
    func showWithdrawalConfirmationAlert() {
        guard presentedViewController == nil else { return }

        let alertController = UIAlertController(title: "정말 탈퇴하시겠습니까?", message: "탈퇴 시, 기존의 활동 기록은 모두 삭제되며\n되돌릴 수 없습니다.", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "네", style: .default) { [weak self] _ in
            self?.viewModel.action(.withdrawalButtonDidTap)
        })

        alertController.addAction(UIAlertAction(title: "아니오", style: .cancel))

        present(alertController, animated: true)
    }
    
    // MARK: - Action
    
    @objc
    func logoutButtonDidTap() {
        showLogoutConfirmationAlert()
    }
    
    @objc
    private func agreementButtonDidTap() {
        viewModel.action(.agreementButtonDidTap)
    }
    
    @objc
    private func withdrawalButtonDidTap() {
        showWithdrawalConfirmationAlert()
    }
}
