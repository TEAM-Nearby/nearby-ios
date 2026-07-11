//
//  MatchingScheduleModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingScheduleModel: Decodable {
    let place: MatchingSchedulePlaceModel
    let scheduledAt: String
}
