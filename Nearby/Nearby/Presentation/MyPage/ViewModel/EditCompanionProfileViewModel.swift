//
//  EditCompanionProfileViewModel.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import Foundation

final class EditCompanionProfileViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case nicknameDidChange(String)
        case introductionDidChange(String)
        case keywordButtonDidTap(String)
        case profileImageURLDidChange(String?)
        case saveButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var selectedKeywordsDidChange: ((Set<String>) -> Void)?
        var keywordSelectionDidFail: ((String) -> Void)?
        var profileUpdateDidFail: ((String) -> Void)?
        var profileUpdateDidComplete: (() -> Void)?
        var isLoading: ((Bool) -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private let repository: CompanionProfileRepository
    private let originalProfile: CompanionProfile

    private var nickname: String
    private var introduction: String
    private var selectedKeywords: Set<TravelStyleKeyword>
    private var profileImageURL: String?

    private var updateTask: Task<Void, Never>?
    private var isUpdating = false

    // MARK: - Initializer

    init(repository: CompanionProfileRepository, profile: CompanionProfile) {
        self.repository = repository
        self.originalProfile = profile

        nickname = profile.nickname
        introduction = profile.intro ?? ""
        selectedKeywords = Set(profile.travelStyleKeywords)
        profileImageURL = profile.profileImageURL
    }

    deinit {
        updateTask?.cancel()
    }

    // MARK: - Actions

    func action(_ trigger: Input) {
        switch trigger {
        case .nicknameDidChange(let value):
            nickname = value

        case .introductionDidChange(let value):
            introduction = value

        case .keywordButtonDidTap(let title):
            toggleKeyword(title)

        case .profileImageURLDidChange(let url):
            profileImageURL = url

        case .saveButtonDidTap:
            updateProfile()
        }
    }

    // MARK: - Methods

    func currentProfile() -> CompanionProfile {
        originalProfile
    }

    func currentSelectedKeywordTitles() -> Set<String> {
        Set(selectedKeywords.map(\.title))
    }
}

// MARK: - Private Methods

private extension EditCompanionProfileViewModel {

    func toggleKeyword(_ title: String) {
        guard let keyword = TravelStyleKeyword.allCases.first(
            where: { $0.title == title }
        ) else {
            return
        }

        if selectedKeywords.contains(keyword) {
            selectedKeywords.remove(keyword)
        } else {
            guard selectedKeywords.count < 6 else {
                output.keywordSelectionDidFail?(
                    "여행 스타일 키워드는 최대 6개까지 선택할 수 있어요."
                )
                return
            }

            selectedKeywords.insert(keyword)
        }

        output.selectedKeywordsDidChange?(currentSelectedKeywordTitles())
    }

    func updateProfile() {
        guard !isUpdating else { return }

        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedNickname.isEmpty else {
            output.profileUpdateDidFail?("닉네임을 입력해주세요.")
            return
        }

        let trimmedIntroduction = introduction.trimmingCharacters(in: .whitespacesAndNewlines)

        let update = CompanionProfileUpdate(nickname: trimmedNickname, intro: trimmedIntroduction, profileImageURL: profileImageURL, travelStyleKeywords: TravelStyleKeyword.allCases.filter {
                selectedKeywords.contains($0)
            }
        )

        isUpdating = true
        output.isLoading?(true)

        updateTask = Task { [weak self] in
            guard let self else { return }

            do {
                _ = try await repository.updateCompanionProfile(update)

                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.isUpdating = false
                    self.updateTask = nil
                    self.output.isLoading?(false)
                    self.output.profileUpdateDidComplete?()
                }
            } catch {
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.isUpdating = false
                    self.updateTask = nil
                    self.output.isLoading?(false)
                    self.output.profileUpdateDidFail?(
                        "프로필을 수정하지 못했습니다."
                    )
                }
            }
        }
    }
}
