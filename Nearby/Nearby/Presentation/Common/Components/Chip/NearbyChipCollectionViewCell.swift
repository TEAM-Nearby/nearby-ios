//
//  NearbyChipCollectionViewCell.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import SnapKit
import UIKit

final class NearbyChipCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Component
    
    private var iconChip: NearbyIconChip?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        contentView.clipsToBounds = false
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconChip?.removeFromSuperview()
        iconChip = nil
    }
    
    // MARK: - Method
    
    func configure(style: NearbyChipStyle, title: String, icon: UIImage, iconColor: UIColor) {
        iconChip?.removeFromSuperview()
        
        let iconChip = NearbyIconChip(style: style, title: title, icon: icon, iconColor: iconColor)
        iconChip.isUserInteractionEnabled = false
        
        contentView.addSubview(iconChip)
        
        iconChip.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.iconChip = iconChip
    }
}
