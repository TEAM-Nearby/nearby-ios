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
    }
    
    override func bindAction() {
        viewModel.output.backButtonDidTap = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        
        viewModel.output.logoutButtonDidTap = { [weak self] in
            self?.onLogoutButtonDidTap?()
        }
        
        viewModel.output.isLogoutLoading = { [weak self] isLoading in
            self?.settingView.logoutButton.isEnabled = !isLoading
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
    
    // MARK: - Action
    
    @objc
    func logoutButtonDidTap() {
        showLogoutConfirmationAlert()
    }
}
