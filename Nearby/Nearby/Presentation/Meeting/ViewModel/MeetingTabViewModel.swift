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
        case viewWillAppear
        case viewDidDisappear
    }
    
    // MARK: - Output
    
    struct Output {
        let items = CurrentValueSubject<[MeetingItem], Never>([])
        let errorMessage = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let isGuest: Bool
    private let repository: MeetingRepository
    private let eventCenter: MeetingEventCenter
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    private var fetchTask: Task<Void, Never>?
    
    var items: [MeetingItem] { output.items.value }
    
    // MARK: - Initializer

    init(repository: MeetingRepository, eventCenter: MeetingEventCenter, isGuest: Bool = false) {
        self.isGuest = isGuest
        self.repository = repository
        self.eventCenter = eventCenter
        if !isGuest { bindMeetingEvents() }
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchMeetings()
            startTimer()
            
        case .viewDidDisappear:
            timerCancellable = nil
            fetchTask?.cancel()
        }
    }
    
    // MARK: - Methods
    
    private func fetchMeetings() {
        guard !isGuest else {
            output.items.send([])
            return
        }
        fetchTask?.cancel()
        fetchTask = Task {
            do {
                let meetings = try await repository.fetchMeetingList()
                guard !Task.isCancelled else { return }
                let items = meetings.map(makeMeetingItem)
                    .filter { !eventCenter.completedMatchIds.contains($0.matchId) }
                output.items.send(items)
            } catch {
                guard !Task.isCancelled else { return }
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func startTimer() {
        guard !isGuest else { return }
        timerCancellable = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                output.items.send(output.items.value)
            }
    }

    private func makeMeetingItem(from meeting: Meeting) -> MeetingItem {
        MeetingItem(
            id: meeting.meetingID ?? meeting.matchID,
            meetingId: meeting.meetingID,
            matchId: meeting.matchID,
            hostUserID: meeting.companion.userID,
            name: meeting.companion.nickname.displayNickname,
            gender: meeting.companion.gender.genderDisplayText,
            profileImageUrl: meeting.companion.profileImageURL,
            information: MeetingItem.makeInformation(placeName: meeting.placeName, meetingDate: meeting.meetingAt, timeZoneID: meeting.timeZoneID),
            cityName: NearbyCity.koreanName(for: meeting.city),
            placeName: meeting.placeName,
            meetingDate: meeting.meetingAt,
            postType: meeting.meetingTimeType,
            isCheckedIn: meeting.isCheckedIn
        )
    }
    
    private func bindMeetingEvents() {
        eventCenter.meetingCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchId in
                guard let self else { return }
                output.items.send(items.filter { $0.matchId != matchId })
            }
            .store(in: &cancellables)
    }
    
    func item(at index: Int) -> MeetingItem {
        items[index]
    }
}
