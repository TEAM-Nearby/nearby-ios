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
        let errorMessage = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let repository: MeetingRepository
    private let eventCenter: MeetingEventCenter
    private var cancellables = Set<AnyCancellable>()
    
    var items: [MeetingItem] { output.items.value }
    
    // MARK: - Initializer

    init(repository: MeetingRepository, eventCenter: MeetingEventCenter) {
        self.repository = repository
        self.eventCenter = eventCenter
        startTimer()
        bindMeetingEvents()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMeetings()
        }
    }
    
    // MARK: - Methods
    
    func item(at index: Int) -> MeetingItem {
        items[index]
    }
    
    private func fetchMeetings() {
        Task {
            do {
                let meetings = try await repository.fetchMeetingList()
                let items = meetings.map(makeMeetingItem)
                    .filter { !eventCenter.completedMatchIds.contains($0.matchId) }
                output.items.send(items)
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func startTimer() {
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                output.items.send(output.items.value)
            }
            .store(in: &cancellables)
    }

    private func makeMeetingItem(from DTO: MeetingResponseDTO) -> MeetingItem {
        let meetingDate = DTO.meetingAt?.toDate()
        let information = [DTO.placeName, meetingDate?.timeDisplayText]
            .compactMap { $0 }
            .joined(separator: " · ")

        return MeetingItem(
            id: DTO.meetingId ?? DTO.matchId,
            meetingId: DTO.meetingId,
            matchId: DTO.matchId,
            name: DTO.companion.nickname,
            gender: DTO.companion.gender.genderDisplayText,
            profileImageUrl: DTO.companion.profileImageUrl,
            information: information,
            meetingDate: meetingDate,
            postType: DTO.meetingTimeType,
            isCheckedIn: DTO.isCheckedIn
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
}
