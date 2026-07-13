//
//  TravelStyleKeyword.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

enum TravelStyleKeyword: String {
    case extroverted = "EXTROVERTED"
    case introverted = "INTROVERTED"
    case planned = "PLANNED"
    case spontaneous = "SPONTANEOUS"
    case cafeTour = "CAFE_TOUR"
    case walkingTour = "WALKING_TOUR"
    case photoSpotTour = "PHOTO_SPOT_TOUR"
    case foodie = "FOODIE"
    case dessertLover = "DESSERT_LOVER"
    case propShopTour = "PROP_SHOP_TOUR"
    case nightViewLover = "NIGHT_VIEW_LOVER"
    case historyTour = "HISTORY_TOUR"
    case exhibitionLover = "EXHIBITION_LOVER"
    case slowTravel = "SLOW_TRAVEL"
    case activeTravel = "ACTIVE_TRAVEL"
    case drinkingLover = "DRINKING_LOVER"
    case nonDrinker = "NON_DRINKER"

    var title: String {
        switch self {
        case .extroverted: return "외향형"
        case .introverted: return "내향형"
        case .planned: return "계획형"
        case .spontaneous: return "즉흥형"
        case .cafeTour: return "감성 카페 투어"
        case .walkingTour: return "도보여행"
        case .photoSpotTour: return "사진 맛집 투어"
        case .foodie: return "미식 탐방"
        case .dessertLover: return "디저트 중독"
        case .propShopTour: return "소품샵 투어"
        case .nightViewLover: return "야경 러버"
        case .historyTour: return "역사 탐방"
        case .exhibitionLover: return "전시장 러버"
        case .slowTravel: return "한 곳 오래"
        case .activeTravel: return "많이 돌아다니는"
        case .drinkingLover: return "음주 애호가"
        case .nonDrinker: return "음주 비선호"
        }
    }

    static func titles(for serverKeys: [String]) -> [String] {
        serverKeys.map { serverKey in
            TravelStyleKeyword(rawValue: serverKey)?.title ?? serverKey
        }
    }
}
