//
//  AppIntroductionPage.swift
//  Nearby
//
//  Created by soomin on 10/2/26.
//

import Foundation

struct AppIntroductionPage {
    let title: String
    let highlightedTexts: [String]
    let description: String
    let imageName: String
}

extension AppIntroductionPage {
    static let pages: [AppIntroductionPage] = [
        AppIntroductionPage(
            title: "혼자 떠났다고 모든 순간까지\n혼자일 필요는 없으니까.",
            highlightedTexts: [],
            description: "지금 내 주변의 여행자를 만나 원하는 순간만 함께해요.",
            imageName: "app_introduction_1"
        ),
        AppIntroductionPage(
            title: "내 주변의 동행을\n한눈에 찾아보세요.",
            highlightedTexts: ["한눈에"],
            description: "지도에서 가까운 여행자가 올린 글을 실시간으로 확인해요.",
            imageName: "app_introduction_2"
        ),
        AppIntroductionPage(
            title: "마음에 드는 동행을\n빠르게 만나요.",
            highlightedTexts: ["빠르게"],
            description: "버튼 하나로 끝나는 간단한 매칭으로 시간을 아껴요.",
            imageName: "app_introduction_3"
        ),
        AppIntroductionPage(
            title: "함께할 땐 함께,\n혼자일 땐 든든하게.",
            highlightedTexts: ["든든하게."],
            description: "검증된 여행자들이 추천하는 혼밥 맛집을 한눈에 확인해요.",
            imageName: "app_introduction_4"
        ),
        AppIntroductionPage(
            title: "새로운 여행자와의\n만남도 안심할 수 있어요.",
            highlightedTexts: ["안심"],
            description: "철저한 인증과 리뷰, 신고 기능으로 더 안전하게 동행해요.",
            imageName: "app_introduction_5"
        )
    ]
}
