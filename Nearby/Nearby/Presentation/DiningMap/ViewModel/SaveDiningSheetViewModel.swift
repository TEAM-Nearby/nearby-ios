//
//  SaveDiningSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine

final class SaveDiningSheetViewModel: BaseViewModelType {
    
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
    
    let output: Output
    
    // MARK: - Properties
    
    var restaurantCount: Int { output.restaurants.value.count }
    
    // MARK: - Initializer
    
    init(restaurants: [NearDiningCellItem] = SaveDiningSheetViewModel.mockRestaurants) {
        output = Output(restaurants: CurrentValueSubject(restaurants))
    }
    
    // MARK: - Methods
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        output.restaurants.value[index]
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .categoryDidSelect(let category):
            output.selectedCategory.send(category)
        case .restaurantDidSelect(let index):
            output.selectedRestaurant.send(restaurant(at: index))
        case .bookmarkDidTap(let index):
            var restaurants = output.restaurants.value
            guard restaurants.indices.contains(index) else { return }
            restaurants.remove(at: index)
            output.restaurants.send(restaurants)
        }
    }
}

// MARK: - Mock Data

private extension SaveDiningSheetViewModel {
    static let mockRestaurants = (0..<4).map { _ in
        NearDiningCellItem(name: "시우다드 콘달", category: "마라탕", businessStatus: "영업중", distance: "0.8km", address: "Rambla de Catalunya, 18, Eixample, 08007 Barcelona", rating: 5, reviewCount: 22_870, images: [.restaurantPlaceholder, .restaurantPlaceholder, .restaurantPlaceholder], isBookmarked: true)
    }
}
