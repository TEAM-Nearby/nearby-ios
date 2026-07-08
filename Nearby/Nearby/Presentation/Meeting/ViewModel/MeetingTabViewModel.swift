//
//  MeetingTabViewModel.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Combine

final class MeetingTabViewModel {

    @Published private(set) var cellTypes: [MeetingVerificationCellType] = []

    // TODO: - 서버 연동 예정 
    func load() {
        cellTypes = [
            .verifiable,
            .notYet,
            .verifiable,
            .notYet
        ]
    }
}
