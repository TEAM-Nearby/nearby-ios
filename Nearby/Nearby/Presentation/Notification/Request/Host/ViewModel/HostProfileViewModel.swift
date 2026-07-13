//
//  HostProfileViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/12/26.
//

import Combine
import Foundation

final class HostProfileViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case communicationChipDidTap(index: Int)
        case punctualityChipDidTap(index: Int)
        case backButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let selectedReviewState = PassthroughSubject<SelectedReviewState, Never>()
        let backButtonDidTap = PassthroughSubject<Void, Never>()
        let error = PassthroughSubject<Error, Never>()
    }

    struct DisplayData {
        let profileImageURL: URL?
        let nickname: String
        let gender: String
        let personalityKeywords: [String]
        let mannerScore: Int
        let introduction: String
        let communicationKeywords: [String]
        let punctualityKeywords: [String]
    }

    struct SelectedReviewState {
        let selectedCommunicationIndexes: Set<Int>
        let selectedPunctualityIndexes: Set<Int>
    }

    // MARK: - Properties

    let output = Output()

    private var selectedCommunicationIndexes = Set<Int>()
    private var selectedPunctualityIndexes = Set<Int>()
    private let profileId: Int
    private let repository: CompanionProfileRepository
    private var fetchTask: Task<Void, Never>?

    init(profileId: Int, repository: CompanionProfileRepository) {
        self.profileId = profileId
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchProfile()
            sendSelectedReviewState()

        case let .communicationChipDidTap(index):
            toggleCommunicationChip(at: index)

        case let .punctualityChipDidTap(index):
            togglePunctualityChip(at: index)

        case .backButtonDidTap:
            output.backButtonDidTap.send(())
        }
    }
}

// MARK: - Methods

private extension HostProfileViewModel {

    func fetchProfile() {
        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchDetail(profileId: profileId)
                guard !Task.isCancelled else { return }
                output.displayData.send(response.displayData)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }

    func toggleCommunicationChip(at index: Int) {
        if selectedCommunicationIndexes.contains(index) {
            selectedCommunicationIndexes.remove(index)
        } else {
            selectedCommunicationIndexes.insert(index)
        }

        sendSelectedReviewState()
    }

    func togglePunctualityChip(at index: Int) {
        if selectedPunctualityIndexes.contains(index) {
            selectedPunctualityIndexes.remove(index)
        } else {
            selectedPunctualityIndexes.insert(index)
        }

        sendSelectedReviewState()
    }

    func sendSelectedReviewState() {
        let state = SelectedReviewState(
            selectedCommunicationIndexes: selectedCommunicationIndexes,
            selectedPunctualityIndexes: selectedPunctualityIndexes
        )

        output.selectedReviewState.send(state)
    }
}

private extension CompanionProfileResponseDTO {
    var displayData: HostProfileViewModel.DisplayData {
        HostProfileViewModel.DisplayData(
            profileImageURL: profileImageUrl.flatMap(URL.init(string:)),
            nickname: nickname,
            gender: gender == "FEMALE" ? "여성" : "남성",
            personalityKeywords: TravelStyleKeyword.titles(for: keywords),
            mannerScore: Int(mannerScore.rounded()),
            introduction: intro ?? "",
            communicationKeywords: [],
            punctualityKeywords: []
        )
    }
}
