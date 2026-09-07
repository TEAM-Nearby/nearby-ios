//
//  HostRequestReceiveViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestReceiveViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case rejectButtonDidTap
        case allowButtonDidTap
        case nextButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let showHostRejectView = PassthroughSubject<Void, Never>()
        let showHostAllowView = PassthroughSubject<Void, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
        let showApplicantProfile = PassthroughSubject<Int, Never>()
    }

    struct DisplayData {
        let image: UIImage
        let name: String
        let profileImageUrl: String?
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
    private(set) var meetingTimeType: PostType = .scheduled
    private(set) var applicantProfileImageUrl: String?
    private(set) var applicantProfileId: Int?
    private(set) var openChatUrl: String = ""
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
            
        case .nextButtonDidTap:
            guard let applicantProfileId else { return }
            output.showApplicantProfile.send(applicantProfileId)
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
                    profileImageUrl: DTO.applicantProfile.profileImageUrl,
                    gender: DTO.applicantProfile.gender.genderDisplayText,
                    level: String(format: "%.1f", DTO.applicantProfile.mannerScore),
                    title: "함께 동행을 원하는 분이 있어요",
                    subtitle: "대화를 나눈 후 일정을 확정해보세요",
                    location: DTO.placeName,
                    date: DTO.meetingAt.toDate()?.meetingDisplayText ?? ""
                )
                applicantNickname = DTO.applicantProfile.nickname
                applicantProfileImageUrl = DTO.applicantProfile.profileImageUrl
                applicantProfileId = DTO.applicantProfile.profileId
                placeName = DTO.placeName
                meetingAt = DTO.meetingAt
                meetingTimeType = DTO.meetingTimeType
                openChatUrl = DTO.openChatUrl ?? ""
                output.displayData.send(data)
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }

    private func allowApplication() {
        Task {
            do {
                let response = try await repository.allowApplication(applicationId: applicationId)
                matchId = response.matchId
                output.showHostAllowView.send(())
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
}
