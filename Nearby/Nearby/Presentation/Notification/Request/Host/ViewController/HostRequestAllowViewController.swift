//
//  HostRequestAllowViewController.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit
import SafariServices

final class HostRequestAllowViewController: BaseViewController<HostRequestAllowViewModel> {

    // MARK: - UI Component

    private let hostRequestAllowView = HostRequestAllowView()

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

        viewModel.output.showOpenChat
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                let safariViewController = SFSafariViewController(url: url)
                self?.present(safariViewController, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.showChatLinkPopup
            .receive(on: DispatchQueue.main)
            .sink { [weak self] link in
                self?.presentChatLinkPopup(link: link)
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Method
    
    private func presentChatLinkPopup(link: String) {
        let alert = UIAlertController(title: "오픈채팅 링크", message: link, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "링크 복사", style: .default) { _ in
            UIPasteboard.general.string = link
        })
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        present(alert, animated: true)
    }
}
