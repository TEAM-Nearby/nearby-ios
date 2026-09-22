//
//  ReviewErrorAlert.swift
//  Nearby
//
//  Created by h2e on 9/22/26.
//

struct ReviewErrorAlert {
    let title: String
    let message: String
    
    static func fetchTargets(_ message: String) -> Self {
        Self(title: "후기 대상을 불러오지 못했어요", message: message)
    }
    
    static func createReview(_ message: String) -> Self {
        Self(title: "후기 등록에 실패했어요", message: message)
    }
    
    static func completeMeeting(_ message: String) -> Self {
        Self(title: "동행을 마치지 못했어요", message: message)
    }
}
