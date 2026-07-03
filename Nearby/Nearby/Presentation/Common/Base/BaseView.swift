//
//  BaseView.swift
//  Nearby
//
//  Created by mandoo on 7/2/26.
//

import UIKit

class BaseView: UIView {

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
        registerCells()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    func setStyle() {}
    func setUI() {}
    func setLayout() {}
    func registerCells() {}
}
