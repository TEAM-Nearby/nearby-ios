//
//  MatchingManageScheduleRequestModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingManageScheduleRequestModel: Encodable {
    let scheduledAt: String
    let place: MatchingManageSchedulePlaceRequestModel
    let openChatUrl: String
}
