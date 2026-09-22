//
//  UIViewController+Alert.swift
//  Nearby
//
//  Created by h2e on 9/22/26.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
