//
//  NotificationRoute.swift
//  Nearby
//
//  Created by soomin on 9/14/26.
//

enum NotificationRoute {
    case previous
    case companionTab
    case recruitCompanion
    case scheduleDetail(Int)
    case manageSchedule(Int)
    case hostRequestDecline(applicantName: String, applicationId: Int)
    case hostRequestAllow(applicantName: String, applicantProfileImageUrl: String?, locationName: String, meetingAt: String, matchId: Int?, postType: PostType, openChatUrl: String)
    case applicantProfile(Int)
}
