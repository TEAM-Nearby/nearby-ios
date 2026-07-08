//
//  ReviewProfileCell.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit
import SnapKit

final class ReviewProfileCell: UITableViewCell {
    
    // MARK: - Property
    
    var onNextButtonDidTap: (() -> Void)?
    
    // MARK: - UI Component
    
    private let profileView = ReviewProfileView()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onNextButtonDidTap = nil
    }
    
    // MARK: - Methods
    
    private func setUI() {
        contentView.addSubview(profileView)
    }
    
    private func setLayout() {
        profileView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func bindAction() {
        profileView.onNextButtonDidTap = { [weak self] in
            self?.onNextButtonDidTap?()
        }
    }
    
    func configure(with item: ReviewItem) {
        profileView.configure(
            image: item.image,
            name: item.name,
            information: item.information
        )
    }
}
