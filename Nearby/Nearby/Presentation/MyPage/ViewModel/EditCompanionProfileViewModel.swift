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
        case viewDidLoad
        case nicknameDidChange(String)
        case introductionDidChange(String)
        case keywordButtonDidTap(String)
        case profileImageURLDidChange(String?)
        case profileImageDidSelect(Data)
        case saveButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var profileDidLoad: ((CompanionProfile) -> Void)?
        var selectedKeywordsDidChange: ((Set<String>) -> Void)?
        var keywordSelectionDidFail: ((String) -> Void)?
        var profileUpdateDidFail: ((String) -> Void)?
        var profileUpdateDidComplete: (() -> Void)?
        var isLoading: ((Bool) -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private let repository: CompanionProfileRepository
    private let profileID: Int
    private var originalProfile: CompanionProfile?

    private var nickname = ""
    private var introduction = ""
    private var selectedKeywords: Set<TravelStyleKeyword> = []
    private var profileImageURL: String?
    private var selectedProfileImageData: Data?

    private var fetchTask: Task<Void, Never>?
    private var updateTask: Task<Void, Never>?
    private var isUpdating = false

    // MARK: - Initializer

    init(repository: CompanionProfileRepository, profileID: Int) {
        self.repository = repository
        self.profileID = profileID
    }

    deinit {
        fetchTask?.cancel()
        updateTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchProfile()

        case .nicknameDidChange(let value):
            nickname = value

        case .introductionDidChange(let value):
            introduction = value

        case .keywordButtonDidTap(let title):
            toggleKeyword(title)

        case .profileImageURLDidChange(let url):
            profileImageURL = url
            
        case .profileImageDidSelect(let data):
            selectedProfileImageData = data

        case .saveButtonDidTap:
            updateProfile()
        }
    }

    // MARK: - Methods

    func currentSelectedKeywordTitles() -> Set<String> {
        Set(selectedKeywords.map(\.title))
    }
}

// MARK: - Private Methods

private extension EditCompanionProfileViewModel {

    func fetchProfile() {
        fetchTask?.cancel()
        output.isLoading?(true)

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let profile = try await repository.fetchCompanionProfile(
                    profileID: profileID
                )

                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.originalProfile = profile
                    self.nickname = profile.nickname
                    self.introduction = profile.intro ?? ""
                    self.selectedKeywords = Set(profile.travelStyleKeywords)
                    self.profileImageURL = profile.profileImageURL

                    self.output.profileDidLoad?(profile)
                    self.output.isLoading?(false)
                }
            } catch {
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.output.isLoading?(false)
                    self.output.profileUpdateDidFail?(
                        "프로필 정보를 불러오지 못했습니다."
                    )
                }
            }
        }
    }

    func toggleKeyword(_ title: String) {
        guard originalProfile != nil else { return }

        guard let keyword = TravelStyleKeyword.allCases.first(
            where: { $0.title == title }
        ) else {
            return
        }

        if selectedKeywords.contains(keyword) {
            selectedKeywords.remove(keyword)
        } else {
            guard selectedKeywords.count < 6 else {
                output.keywordSelectionDidFail?("여행 스타일 키워드는 최대 6개까지 선택할 수 있어요.")
                return
            }

            selectedKeywords.insert(keyword)
        }

        output.selectedKeywordsDidChange?(
            currentSelectedKeywordTitles()
        )
    }

    func updateProfile() {
        guard originalProfile != nil else {
            output.profileUpdateDidFail?("프로필 정보를 불러온 후 다시 시도해주세요.")
            return
        }

        guard !isUpdating else { return }

        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedNickname.isEmpty else {
            output.profileUpdateDidFail?("닉네임을 입력해주세요.")
            return
        }

        let trimmedIntroduction = introduction.trimmingCharacters(in: .whitespacesAndNewlines)

        isUpdating = true
        output.isLoading?(true)

        updateTask = Task { [weak self] in
            guard let self else { return }

            do {
                var imageURL = profileImageURL

                if let imageData = selectedProfileImageData {
                    imageURL = try await repository.uploadProfileImage(data: imageData, fileName: "\(UUID().uuidString).jpeg", contentType: "image/jpeg")
                }

                guard !Task.isCancelled else { return }

                let update = CompanionProfileUpdate(nickname: trimmedNickname, intro: trimmedIntroduction, profileImageURL: imageURL, travelStyleKeywords: TravelStyleKeyword.allCases.filter {self.selectedKeywords.contains($0)})

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

                AppLogger.error(error, message: "동행 프로필 수정 API 오류")

                await MainActor.run {
                    self.isUpdating = false
                    self.updateTask = nil
                    self.output.isLoading?(false)
                    self.output.profileUpdateDidFail?("프로필을 수정하지 못했습니다.")
                }
            }
        }
    }
}
