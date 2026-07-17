//
//  MeetingEventCenter.swift
//  Nearby
//
//  Created by h2e on 7/17/26.
//

import Combine

final class MeetingEventCenter {
    let meetingCompleted = PassthroughSubject<Int, Never>()

    /// 이번 세션에 동행 마치기를 완료한 matchId (서버 리스트가 완료 행을 제외할 때까지의 재조회 방어용)
    private(set) var completedMatchIds = Set<Int>()

    func notifyCompleted(matchId: Int) {
        completedMatchIds.insert(matchId)
        meetingCompleted.send(matchId)
    }
}
