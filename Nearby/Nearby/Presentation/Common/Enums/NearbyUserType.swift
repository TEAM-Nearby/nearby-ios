//
//  NearbyUserType.swift
//  Nearby
//
//  Created by h2e on 7/10/26.
//

enum NearbyUserType: String, Decodable {
    case host = "HOST"
    case participant = "GUEST"
    
    var reviewPostCompletionTitle: String {
        switch self {
        case .host:
            return "동행 마치기"
        case .participant:
            return "후기 저장하기"
        }
    }
}
