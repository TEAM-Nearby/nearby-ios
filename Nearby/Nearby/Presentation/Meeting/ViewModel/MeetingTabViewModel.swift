//
//  MeetingTabViewModel.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine
import Foundation

final class MeetingTabViewModel: BaseViewModelType {

    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let items = CurrentValueSubject<[MeetingItem], Never>([])
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    
    var items: [MeetingItem] { output.items.value }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // TODO: - 서버 연동 예정
            let mockItems: [MeetingItem] = [
                MeetingItem(id: 1, name: "정지영", gender: "여성",
                    information: "시우다드 콘달 · 오후 4:30", meetingDate: Date(), step: .verification
                ),
                MeetingItem(id: 2, name: "장현준", gender: "남성",
                    information: "북극 · 오후 2:00", meetingDate: Date().addingTimeInterval(86400 * 3), step: .verification
                )
            ]
            output.items.send(mockItems)
        }
    }
    
    // MARK: - Method
    
    func item(at index: Int) -> MeetingItem {
        items[index]
    }
}
