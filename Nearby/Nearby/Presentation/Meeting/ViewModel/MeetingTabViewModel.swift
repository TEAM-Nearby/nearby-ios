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
    private var cancellables = Set<AnyCancellable>()
    
    var items: [MeetingItem] { output.items.value }
    
    // MARK: - Initializer
    
    init(repository: MeetingRepository) {
        self.repository = repository
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
                output.items.send(items)
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func makeMeetingItem(from DTO: MeetingResponseDTO) -> MeetingItem {
        let meetingDate = DTO.meetingAt.toDate() ?? Date()
        let timeText = meetingDate.meetingDisplayText
        
        return MeetingItem(
            id: DTO.meetingId,
            matchId: DTO.matchId,
            name: DTO.companion.nickname,
            gender: DTO.companion.gender.genderDisplayText,
            profileImageUrl: DTO.companion.profileImageUrl,
            information: "\(DTO.placeName) · \(timeText)",
            meetingDate: meetingDate,
            postType: DTO.meetingTimeType,
            isCheckedIn: DTO.isCheckedIn
        )
    }
}
