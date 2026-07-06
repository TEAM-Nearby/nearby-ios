//
//  UIViewController+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

extension UIViewController {
    func addKeyboardDismissGesture() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
