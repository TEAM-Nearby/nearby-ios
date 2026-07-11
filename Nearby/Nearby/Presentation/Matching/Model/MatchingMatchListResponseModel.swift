//
//  MatchingMatchListResponseModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingMatchListResponseModel: Decodable {
    let matches: [MatchingMatchSummaryModel]
}
