//
//  MatchingViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import Foundation

final class MatchingViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case cardDidTap(Int)
        case alarmButtonDidTap
        case findCompanionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let items = CurrentValueSubject<[MatchingMatchedCardItem], Never>([])
        let showScheduleDetail = PassthroughSubject<Int, Never>()
        let showAlarm = PassthroughSubject<Void, Never>()
        let showCompanionTab = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let repository: MatchedCompanionListRepository
    private let eventCenter: MeetingEventCenter
    private var cancellables = Set<AnyCancellable>()
    
    var items: [MatchingMatchedCardItem] {
        return output.items.value
    }
    
    // MARK: - Initializer
    
    init(repository: MatchedCompanionListRepository, eventCenter: MeetingEventCenter) {
        self.repository = repository
        self.eventCenter = eventCenter
        bindMeetingEvents()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMatches()
            
        case .cardDidTap(let index):
            guard items.indices.contains(index) else { return }
            output.showScheduleDetail.send(items[index].matchId)
            
        case .alarmButtonDidTap:
            output.showAlarm.send(())
            
        case .findCompanionButtonDidTap:
            output.showCompanionTab.send(())
        }
    }
    
    // MARK: - Methods
    
    func item(at index: Int) -> MatchingMatchedCardItem {
        return items[index]
    }
    
    private func fetchMatches() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                AppLogger.data("매칭된 동행 목록 조회를 시작합니다.")
                let response = try await repository.fetchMatches()
                let items = response.matches.map { $0.toMatchedCardItem() }
                    .filter { !eventCenter.completedMatchIds.contains($0.matchId) }
                AppLogger.data("매칭된 동행 목록 \(items.count)개를 조회했습니다.")
                output.items.send(items)
            } catch {
                AppLogger.error(error, message: "매칭된 동행 목록 조회에 실패했습니다.")
                output.items.send([])
            }
        }
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

private extension MatchedCompanionListResponseDTO.Match {
    func toMatchedCardItem(type: NearbyUserType = .participant) -> MatchingMatchedCardItem {
        return MatchingMatchedCardItem(
            matchId: Int(matchId),
            content: MatchingMatchedCardContentModel(
                profileImageUrl: hostProfileImageUrl, name: hostNickname, participantCount: 1,
                gender: hostGender.displayTitle, uploadedTime: createdAt.uploadedTimeTitle, place: placeName ?? "",
                meetingTime: meetingAt?.meetingTimeTitle ?? meetingTimeType.displayTitle, description: content
            ),
            matchStatus: matchStatus.rawValue, type: type
        )
    }
}

private extension HostGender {
    var displayTitle: String {
        switch self {
        case .male:
            return "남성"
        case .female:
            return "여성"
        }
    }
}

private extension MeetingTimeType {
    var displayTitle: String {
        switch self {
        case .now:
            return "지금 바로"
        case .scheduled:
            return ""
        case .undecided:
            return "시간 미정"
        }
    }
}

private extension String {
    var uploadedTimeTitle: String {
        guard let date = isoDate else { return self }
        let elapsedTime = abs(date.timeIntervalSinceNow)
        let minute = Int(elapsedTime / 60)
        
        if minute < 1 {
            return "방금 전 올림"
        }
        
        if minute < 60 {
            return "\(minute)분 전 올림"
        }
        
        let hour = minute / 60
        if hour < 24 {
            return "\(hour)시간 전 올림"
        }
        
        let day = hour / 24
        return "\(day)일 전 올림"
    }
    
    var meetingTimeTitle: String {
        guard let date = isoDate else { return self }
        return date.timeDisplayText
    }
    
    var isoDate: Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: self) {
            return date
        }
        
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: self) {
            return date
        }
        
        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = .nearbyAPITimeZone

        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm"
        ]
        
        for dateFormat in dateFormats {
            localFormatter.dateFormat = dateFormat
            if let date = localFormatter.date(from: self) {
                return date
            }
        }
        
        return nil
    }
}
