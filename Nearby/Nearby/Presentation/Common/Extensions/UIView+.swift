//
//  UIView+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

import SnapKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func showToast(title: String, above anchor: UIView, spacing: CGFloat = 16) {
        for case let toastView as ToastMessageView in subviews {
            toastView.removeFromSuperview()
        }

        let toastMessageView = ToastMessageView(title: title)
        addSubview(toastMessageView)

        toastMessageView.snp.makeConstraints {
            $0.bottom.equalTo(anchor.snp.top).offset(-spacing)
            $0.centerX.equalTo(anchor)
            $0.height.equalTo(44)
        }

        toastMessageView.setCornerRadius(22)

        toastMessageView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            toastMessageView.alpha = 1
        }
        UIView.animate(withDuration: 0.1, delay: 1.0, options: []) {
            toastMessageView.alpha = 0
        } completion: { _ in
            toastMessageView.removeFromSuperview()
        }
    }
}
