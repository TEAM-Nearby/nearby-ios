//
//  ReportPostView.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class ReportPostView: BaseView {
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let reasonTableView = UITableView()
    
    // MARK: - Property
    
    private var selectedReasons = Set<Int>()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("신고하기"))
        }
    }
    
    override func setUI() {
        
    }
    
    override func setLayout() {
        
    }
}
