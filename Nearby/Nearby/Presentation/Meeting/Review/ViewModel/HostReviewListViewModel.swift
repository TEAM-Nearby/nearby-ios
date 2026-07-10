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
        case completionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let headerInfo = PassthroughSubject<HeaderInfo, Never>()
        let items = CurrentValueSubject<[ReviewItem], Never>([])
        let showReviewWrite = PassthroughSubject<ReviewItem, Never>()
        let showCompletion = PassthroughSubject<Void, Never>()
    }
    
    struct HeaderInfo {
        let people: String
        let information: String
        let location: String
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    
    var items: [ReviewItem] { output.items.value }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // TODO: - 서버 연동 예정
            output.headerInfo.send(
                HeaderInfo(
                    people: "정지영 외 1명과의 동행",
                    information: "바르셀로나 · 2026년 6월 18일",
                    location: "시우다드 콘달"
                )
            )
            output.items.send([
                ReviewItem(id: 1, image: .imgProfileDefault, name: "정지영", information: "바르셀로나 · 2026년 6월 18일"),
                ReviewItem(id: 2, image: .imgProfileDefault, name: "장현준", information: "바르셀로나 · 2026년 6월 18일")
            ])
            
        case .profileDidTap(let item):
            output.showReviewWrite.send(item)
            
        case .completionButtonDidTap:
            output.showCompletion.send(())
        }
    }
    
    // MARK: - Method
    
    func item(at index: Int) -> ReviewItem {
        items[index]
    }
}
