//
//  CompanionDetailState.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

struct CompanionDetailState {
    enum PostType {
        case scheduled
        case immediate(expirationTime: String)
    }

    let postType: PostType
    let isApplicationEnabled: Bool
}
