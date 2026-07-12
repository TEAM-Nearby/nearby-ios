//
//  NearbyDropdownCell.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import UIKit

import SnapKit
import Then

final class NearbyDropdownCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let checkImageView = UIImageView()
    
    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.selectionStyle = .none
        }
        
        titleLabel.do {
            $0.textColor = .grey70
        }

        checkImageView.do {
            $0.image = .dropdownCheck.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
    }

    private func setUI() {
        contentView.addSubviews(titleLabel, checkImageView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(40)
        }
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.font = isSelected ? NearbyFont.b3Sb14.font : NearbyFont.b3M14.font
        checkImageView.isHidden = !isSelected
    }
}
