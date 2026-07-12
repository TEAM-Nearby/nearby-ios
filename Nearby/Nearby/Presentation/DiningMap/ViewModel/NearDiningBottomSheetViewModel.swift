//
//  NearDiningBottomSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine

final class NearDiningBottomSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case categoryDidSelect(DiningCategory)
        case restaurantDidSelect(Int)
        case bookmarkDidTap(Int)
    }

    // MARK: - Output
    
    struct Output {
        let selectedCategory = CurrentValueSubject<DiningCategory, Never>(.restaurant)
        let restaurants: CurrentValueSubject<[NearDiningCellItem], Never>
        let selectedRestaurant = PassthroughSubject<NearDiningCellItem, Never>()
    }
    
    // MARK: - Properties

    let output: Output

    var restaurantCount: Int { output.restaurants.value.count }

    // MARK: - Initializer
    
    init(restaurants: [NearDiningCellItem] = NearDiningBottomSheetViewModel.mockRestaurants) {
        output = Output(restaurants: CurrentValueSubject(restaurants))
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .categoryDidSelect(let category):
            output.selectedCategory.send(category)
        case .restaurantDidSelect(let index):
            output.selectedRestaurant.send(restaurant(at: index))
        case .bookmarkDidTap(let index):
            var restaurants = output.restaurants.value
            let item = restaurants[index]
            restaurants[index] = NearDiningCellItem(name: item.name, category: item.category, businessStatus: item.businessStatus, distance: item.distance, address: item.address, rating: item.rating, reviewCount: item.reviewCount, images: item.images, isBookmarked: !item.isBookmarked)
            output.restaurants.send(restaurants)
        }
    }

    // MARK: - Method
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        output.restaurants.value[index]
    }
}

private extension NearDiningBottomSheetViewModel {
    static let mockRestaurants = (0..<4).map { _ in
        NearDiningCellItem(
            name: "시우다드 콘달",
            category: "마라탕",
            businessStatus: "영업 중",
            distance: "0.8km",
            address: "Rambla de Catalunya, 18, Eixample, 08007 Barcelona",
            rating: 5,
            reviewCount: 22_870,
            images: [.restaurantPlaceholder, .restaurantPlaceholder, .restaurantPlaceholder],
            isBookmarked: false
        )
    }
}
