//
//  ViewController.swift
//  Nearby
//
//  Created by soomin on 7/1/26.
//

import UIKit

import SnapKit

final class NavigationBarTestViewController: UIViewController {

    private let navigationBar = NearbyNavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(navigationBar)

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        navigationBar.configure(
            leftItem: .back,
            centerItem: .title("페이지 제목"),
            rightItems: [.alarm]
        )

        navigationBar.leftButtonAction = {
            print("뒤로가기 탭")
        }

        navigationBar.rightFirstButtonAction = {
            print("알림 탭")
        }

        navigationBar.rightSecondButtonAction = {
            print("설정 탭")
        }
    }
}
