//
//  MeetingTabViewModel.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine

final class MeetingTabViewModel {

    // MARK: - Properties
    @Published private(set) var cellTypes: [MeetingVerificationCellType] = []
    
    var isEmpty: Bool { cellTypes.isEmpty }

    // TODO: - 서버 연동 예정 
    func load() {
        cellTypes = [
//            .verifiable,
//            .notYet,
//            .verifiable,
//            .notYet
        ]
    }
}
