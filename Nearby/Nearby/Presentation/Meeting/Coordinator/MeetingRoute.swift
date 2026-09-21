//
//  MeetingRoute.swift
//  Nearby
//
//  Created by soomin on 9/14/26.
//

enum MeetingRoute {
    case notification
    case companionTab
    case progress(MeetingItem)
    case previous
    case report
    case reportCompletion
    case dismissReport
    case participantReview(ReviewItem)
    case hostReviewList(Int)
    case hostReview(ReviewItem, Bool)
    case reviewCompletion
    case checkInSuccess
    case error(String)
}
