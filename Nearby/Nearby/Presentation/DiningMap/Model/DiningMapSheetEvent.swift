//
//  DiningMapSheetEvent.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

enum DiningMapSheetEvent {
    case restaurantSelected(NearDiningCellItem)
    case markersChanged([CompanionMapMarkerData])
    case favoriteUpdated(placeId: Int, isFavorite: Bool)
    case closeDetail
}

enum DiningMapBottomSheetEvent {
    case screenStateChanged(DiningMapScreenState)
    case bottomSheetStateChanged(BottomSheetState)
    case markersChanged([CompanionMapMarkerData])
}
