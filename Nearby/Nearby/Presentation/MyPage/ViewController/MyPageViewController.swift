//
//  MyPageViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//


//
//  MyPageViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

final class MyPageViewController: BaseViewController<MyPageViewModel> {
    
    // MARK: - UI Components
    
    private let myPageView = MyPageView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        myPageView.navigationBar.rightFirstButtonAction = { [weak self] in
            self?.viewModel.action(.alarmButtonDidTap)
        }
        
        myPageView.navigationBar.rightSecondButtonAction = { [weak self] in
            self?.viewModel.action(.settingButtonDidTap)
        }
    }
}