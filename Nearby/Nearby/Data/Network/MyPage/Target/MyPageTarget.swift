//
//  MyPageTarget.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

import Alamofire

enum MyPageTarget {
    case fetchMyPage
}

extension MyPageTarget: BaseTargetType {

    var path: String {
        switch self {
        case .fetchMyPage:
            return "/api/users/me/mypage"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMyPage:
            return .get
        }
    }
}

