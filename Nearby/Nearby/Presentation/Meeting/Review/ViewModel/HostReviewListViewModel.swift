//
//  HostReviewListViewModel.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class HostReviewListViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case profileDidTap(ReviewItem)
        case reviewSaved(ReviewItem)
        case completionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let headerInfo = PassthroughSubject<HeaderInfo, Never>()
        let items = CurrentValueSubject<[ReviewItem], Never>([])
        let showReviewWrite = PassthroughSubject<(item: ReviewItem, isLast: Bool), Never>()
        let showCompletion = PassthroughSubject<Void, Never>()
        let reviewedIDs = CurrentValueSubject<Set<Int>, Never>([])
    }
    
    struct HeaderInfo {
        let people: String
        let information: String
        let location: String
        let avatarImages: [UIImage?]
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    
    var items: [ReviewItem] { output.items.value }
    
    private var remainingItems: [ReviewItem] {
        items.filter { !output.reviewedIDs.value.contains($0.id) }
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // TODO: - 서버 연동 예정
            output.headerInfo.send(
                HeaderInfo(
                    people: "정지영 외 3명과의 동행",
                    information: "바르셀로나 · 2026년 6월 18일",
                    location: "시우다드 콘달",
                    avatarImages: [.imgProfileDefault, .imgProfileDefault, .imgProfileDefault, .imgProfileDefault]
                )
            )
            output.items.send([
                ReviewItem(id: 1, image: .imgProfileDefault, name: "정지영", information: "바르셀로나 · 2026년 6월 18일"),
                ReviewItem(id: 2, image: .imgProfileDefault, name: "장현준", information: "바르셀로나 · 2026년 6월 18일")
            ])
            
        case .profileDidTap(let item):
            guard !output.reviewedIDs.value.contains(item.id) else { return }
            let isLast = remainingItems.count == 1 && remainingItems.first?.id == item.id
            output.showReviewWrite.send((item, isLast))
            
        case .reviewSaved(let item):
            var reviewed = output.reviewedIDs.value
            reviewed.insert(item.id)
            output.reviewedIDs.send(reviewed)
            
        case .completionButtonDidTap:
            output.showCompletion.send(())
        }
    }
    
    // MARK: - Method
    
    func item(at index: Int) -> ReviewItem {
        items[index]
    }
}
