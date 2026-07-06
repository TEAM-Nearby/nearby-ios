//
//  Reusable.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {}
extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
