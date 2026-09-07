//
//  NearbyTab.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

enum NearbyTabItem: Int, CaseIterable {
    case companion = 0
    case diningMap
    case matching
    case meeting
    case myPage
    
    // MARK: - Properties
    
    var title: String {
        switch self {
        case .companion:
            return "동행 찾기"
        case .diningMap:
            return "혼밥 지도"
        case .matching:
            return "매칭"
        case .meeting:
            return "만남"
        case .myPage:
            return "마이페이지"
        }
    }
    
    var defaultImage: UIImage {
        switch self {
        case .companion:
            return .findIcon.withRenderingMode(.alwaysOriginal)
        case .diningMap:
            return .mapIcon.withRenderingMode(.alwaysOriginal)
        case .matching:
            return .matchingIcon.withRenderingMode(.alwaysOriginal)
        case .meeting:
            return .meetIcon.withRenderingMode(.alwaysOriginal)
        case .myPage:
            return .mypageIcon.withRenderingMode(.alwaysOriginal)
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .companion:
            return .findSelectedIcon.withRenderingMode(.alwaysOriginal)
        case .diningMap:
            return .mapSelectedIcon.withRenderingMode(.alwaysOriginal)
        case .matching:
            return .matchingSelectedIcon.withRenderingMode(.alwaysOriginal)
        case .meeting:
            return .meetSelectedIcon.withRenderingMode(.alwaysOriginal)
        case .myPage:
            return .mypageSelectedIcon.withRenderingMode(.alwaysOriginal)
        }
    }
    
}
