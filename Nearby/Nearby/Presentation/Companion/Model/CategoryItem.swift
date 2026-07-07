//
//  CategoryItem.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

struct CategoryItem {
    let title: String
    let icon: UIImage
    let iconColor: UIColor
    
    static let categoryItems: [CategoryItem] = [
        CategoryItem(title: "식당", icon: .icRestaurant, iconColor: .chipIcOrange),
        CategoryItem(title: "카페", icon: .icCafe, iconColor: .chipIcOrange),
        CategoryItem(title: "펍", icon: .icPub, iconColor: .chipIcOrange),
        CategoryItem(title: "박물관", icon: .icMuseum, iconColor: .primary40),
        CategoryItem(title: "사진 명소", icon: .icCamera, iconColor: .primary40),
        CategoryItem(title: "기타", icon: .peopleIcon, iconColor: .primary40)
    ]
}
