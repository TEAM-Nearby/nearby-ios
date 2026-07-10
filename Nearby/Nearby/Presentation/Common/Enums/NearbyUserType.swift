//
//  NearbyUserType.swift
//  Nearby
//
//  Created by h2e on 7/10/26.
//

enum NearbyUserType {
    case host
    case participant
    
    var reviewPostCompletionTitle: String {
        switch self {
        case .host:
            return "동행 마치기"
        case .participant:
            return "후기 저장하기"
        }
    }
    
    // TODO: - model 구현 후 정의
//    func currentType(for post: Post) {
//        post.hostID == mockMyUserID ? .host : .participant
//        return .host
//    }
}
