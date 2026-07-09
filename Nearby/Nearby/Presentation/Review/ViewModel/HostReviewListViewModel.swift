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
    
     let firstTagTitles = [
        "연락이 빨라요", "매너가 좋아요", "대화가 잘 통해요",
        "입담이 좋아요", "유용한 정보를 많이 알아요"
    ]
    
    let secondTagTitles = [
        "시간 약속을 잘 지켜요", "늦어도 미리 알려줘요",
        "약속 시간보다 일찍 와요"
    ]
    
    private(set) var firstSelectedTags = Set<Int>()
    private(set) var secondSelectedTags = Set<Int>()
    
    private var cancellables = Set<AnyCancellable>()
    
    var items: [ReviewItem] { output.items.value }
    
    // MARK: - Methods
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // TODO: - 서버 연동 예정
            output.headerInfo.send(
                HeaderInfo(
                    people: "정지영님 외 1명과의 동행",
                    information: "바르셀로나 · 2026년 6월 18일",
                    location: "시우다드 콘달"
                )
            )
            output.items.send([
                ReviewItem(id: 1, image: .imgProfileDefault, name: "정지영 님", information: "바르셀로나 · 2026년 6월 18일"),
                ReviewItem(id: 2, image: .imgProfileDefault, name: "장현준 님", information: "바르셀로나 · 2026년 6월 18일")
            ])
            
        case .profileDidTap(let item):
            output.showReviewWrite.send(item)
            
        case .completionButtonDidTap:
            output.showCompletion.send(())
        }
    }
    
    func item(at index: Int) -> ReviewItem {
        items[index]
    }
    
    func toggleFirstTag(_ index: Int) {
        if firstSelectedTags.contains(index) {
            firstSelectedTags.remove(index)
        } else {
            guard firstSelectedTags.count < 3 else { return }
            firstSelectedTags.insert(index)
        }
        updateCompletionState()
    }

    func toggleSecondTag(_ index: Int) {
        secondSelectedTags = secondSelectedTags.contains(index) ? [] : [index]
        updateCompletionState()
    }
}
