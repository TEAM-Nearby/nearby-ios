//
//  LinkPresentable.swift
//  Nearby
//
//  Created by h2e on 7/11/26.
//

import Combine
import SafariServices
import UIKit

protocol LinkPresentable {
    func presentSafariViewController(url: URL, asBottomSheet: Bool)
    func presentLinkCopyPopup(title: String, link: String)
}

extension LinkPresentable where Self: UIViewController {
    
    func presentSafariViewController(url: URL, asBottomSheet: Bool = false) {
        let safariViewController = SFSafariViewController(url: url)
        
        if asBottomSheet, let sheet = safariViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(safariViewController, animated: true)
    }
    
    func presentLinkCopyPopup(title: String = "오픈채팅 링크", link: String) {
        let alert = UIAlertController(
            title: title,
            message: link,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "링크 복사", style: .default) { _ in
            UIPasteboard.general.string = link
        })
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        present(alert, animated: true)
    }
    
    func bindOpenChat(_ output: OpenChatDisplayable, cancellables: inout Set<AnyCancellable>) {
        output.showOpenChat
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.presentSafariViewController(url: url, asBottomSheet: false)
            }
            .store(in: &cancellables)
        
        output.showChatLinkPopup
            .receive(on: DispatchQueue.main)
            .sink { [weak self] link in
                self?.presentLinkCopyPopup(title: "오픈채팅 링크", link: link)
            }
            .store(in: &cancellables)
    }
}

extension UIViewController: LinkPresentable {}
