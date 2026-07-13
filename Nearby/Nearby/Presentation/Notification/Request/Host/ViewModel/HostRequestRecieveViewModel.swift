//
//  HostRequestRecieveViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestRecieveViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case rejectButtonDidTap
        case allowButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let showHostRejectView = PassthroughSubject<Void, Never>()
        let showHostAllowView = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    struct DisplayData {
        let image: UIImage
        let name: String
        let profile: UIImage
        let gender: String
        let level: String
        let title: String
        let subtitle: String
        let location: String
        let date: String
    }

    // MARK: - Properties

    let output = Output()

    let applicationId: Int
    private(set) var applicantNickname: String = ""
    private(set) var placeName: String = ""
    private(set) var meetingAt: String = ""
    private(set) var matchId: Int?
    private let repository: HostCompanionRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer

    init(applicationId: Int, repository: HostCompanionRepository) {
        self.applicationId = applicationId
        self.repository = repository
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchDetail()

        case .rejectButtonDidTap:
            output.showHostRejectView.send(())
            
        case .allowButtonDidTap:
            allowApplication()
        }
    }
    
    // MARK: - Methods

    private func fetchDetail() {
        Task {
            do {
                let DTO = try await repository.fetchHostCompanionDetail(applicationId: applicationId)
                let data = DisplayData(
                    image: .illustLetterProfile,
                    name: DTO.applicantProfile.nickname,
                    profile: .imgProfileDefault,   // TODO: kingfisher 적용 후 교체
                    gender: DTO.applicantProfile.gender.rawValue,
                    level: "\(DTO.applicantProfile.mannerScore)",
                    title: "함께 동행을 원하는 분이 있어요",
                    subtitle: "대화를 나눈 후 일정을 확정해보세요",
                    location: DTO.placeName,
                    date: DTO.meetingAt.toDate()?.meetingDisplayText ?? ""
                )
                applicantNickname = DTO.applicantProfile.nickname
                placeName = DTO.placeName
                meetingAt = DTO.meetingAt
                output.displayData.send(data)
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Method

    private func allowApplication() {
        Task {
            do {
                let response = try await repository.allowApplication(applicationId: applicationId)
                matchId = response.matchId
                output.showHostAllowView.send(())
            } catch {
                AppLogger.error(error)
            }
        }
    }
}
