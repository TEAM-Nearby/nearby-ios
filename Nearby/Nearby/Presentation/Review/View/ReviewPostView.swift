//
//  ReviewPostView.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class ReviewPostView: BaseView {
    
    // MARK: - Property
    
    // MARK: - UI Components
    
    private let profileView = UIStackView()
    
    private let starView = UIView()
    private let starTitleLabel = UILabel()
    private let starRating = StarRatingView()
    
    private let reviewView = UIView()
    private let reviewTitleLabel = UILabel()
    private let reviewSubtitleLabel = UILabel()
    
    private let firstCategoryLabel = UILabel()
    private let secondCategoryLabel = UILabel()
    
    private let reportView = UIView()
    private let reportTitleLabel = UILabel()
    private let reportSubtitleLabel = UILabel()
    private let reportButton = UIButton()
    
    private let completionButton = NearbyButton(style: .primary, title: "")
    
    // MARK: - Custom Methods
}
