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
        case refreshNotifications
    }
    
    // MARK: - Output
    
    struct Output {
        let items = CurrentValueSubject<[MeetingItem], Never>([])
        let hasUnreadNotifications = CurrentValueSubject<Bool, Never>(false)
        let errorMessage = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let isGuest: Bool
    private let repository: MeetingRepository
    private let notificationRepository: CompanionRequestRepository
    private let eventCenter: MeetingEventCenter
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    private var fetchTask: Task<Void, Never>?
    private var notificationTask: Task<Void, Never>?
    private static let notificationRetryDelays: [Duration] = [.seconds(3), .seconds(10)]
    
    var items: [MeetingItem] { output.items.value }
    
    // MARK: - Initializer

    init(repository: MeetingRepository, notificationRepository: CompanionRequestRepository, eventCenter: MeetingEventCenter, isGuest: Bool = false) {
        self.isGuest = isGuest
        self.repository = repository
        self.notificationRepository = notificationRepository
        self.eventCenter = eventCenter
        if !isGuest { bindMeetingEvents() }
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchMeetings()
            refreshNotifications()
            startTimer()
            
        case .viewDidDisappear:
            timerCancellable = nil
            fetchTask?.cancel()
            notificationTask?.cancel()
            
        case .refreshNotifications:
            refreshNotifications()
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
    
    private func fetchUnreadNotifications(direction: CompanionRequestDirection) async -> Bool? {
        do {
            let response = try await notificationRepository.fetchRequests(direction: direction)
            guard !Task.isCancelled else { return nil }
            let hasUnread = response.requests.contains { !$0.isRead }
            if hasUnread {
                output.hasUnreadNotifications.send(true)
            }
            return hasUnread
        } catch {
            guard !Task.isCancelled else { return nil }
            AppLogger.error(error)
            return nil
        }
    }

    private func refreshNotifications(retryIndex: Int = 0) {
        guard !isGuest else { return }
        notificationTask?.cancel()
        notificationTask = Task { [weak self] in
            guard let self else { return }
            async let sent = fetchUnreadNotifications(direction: .sent)
            async let received = fetchUnreadNotifications(direction: .received)
            let results = await (sent, received)
            guard !Task.isCancelled else { return }
            if results.0 == false, results.1 == false {
                output.hasUnreadNotifications.send(false)
            }
            guard results.0 == nil || results.1 == nil,
                  retryIndex < Self.notificationRetryDelays.count else { return }
            try? await Task.sleep(for: Self.notificationRetryDelays[retryIndex])
            guard !Task.isCancelled else { return }
            refreshNotifications(retryIndex: retryIndex + 1)
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
