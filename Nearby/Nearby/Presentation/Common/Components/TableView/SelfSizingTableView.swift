//
//  SelfSizingTableView.swift
//  Nearby
//
//  Created by h2e on 9/23/26.
//

import UIKit

/// 스크롤 없이 내용 전체 높이만큼 자리를 차지하는 테이블뷰
final class SelfSizingTableView: UITableView {
    
    // MARK: - Initializer
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override var intrinsicContentSize: CGSize {
        contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
