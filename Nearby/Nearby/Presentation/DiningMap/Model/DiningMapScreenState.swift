//
//  DiningMapScreenState.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

enum DiningMapListType: Equatable {
    case nearby
    case saved
}

enum DiningMapScreenState {
    case list(DiningMapListType)
    case detail(item: NearDiningCellItem, source: DiningMapListType)
    
    // MARK: - Properties

    var listType: DiningMapListType {
        switch self {
        case .list(let listType), .detail(_, let listType):
            return listType
        }
    }

    var bottomSheetContent: BottomSheetContent {
        switch self {
        case .list(.nearby):
            return .diningMapList
        case .list(.saved):
            return .savedRestaurantList
        case .detail:
            return .diningInfo
        }
    }

    var isBookmarkSelected: Bool {
        listType == .saved
    }

    var hidesTabBar: Bool {
        switch self {
        case .list(.nearby):
            return false
        case .list(.saved), .detail:
            return true
        }
    }
}
