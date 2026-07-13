//
//  CompanionProfileViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/7/26.
//

import Foundation

final class CompanionProfileViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case nicknameDidChange(String)
        case genderButtonDidTap(NearbyGender)
        case introductionDidChange(String)
        case keywordButtonDidTap(String)
        case profileImageDidSelect(data: Data, fileName: String, contentType: String)
        case bottomButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        var selectedGender: ((NearbyGender) -> Void)?
        var selectedKeywords: ((Set<String>) -> Void)?
        
        var nicknameDidFail: ((String) -> Void)?
        var keywordSelectionDidFail: ((String) -> Void)?
        var onboardingDidFail: ((String) -> Void)?
        var onboardingDidComplete: (() -> Void)?
        var isLoading: ((Bool) -> Void)?
    }
    
    // MARK: - Properties
    
    var output: Output
    
    private let authRepository: AuthRepository
    
    private var nickname = ""
    private var selectedGender: NearbyGender = .female
    private var introduction = ""
    private var selectedKeywords: Set<String> = []
    
    private var profileImageData: Data?
    private var profileImageFileName: String?
    private var profileImageContentType: String?
    
    private let maximumKeywordCount = 6
    
    // MARK: - Initializer
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.output = Output()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .nicknameDidChange(let nickname):
            self.nickname = nickname
            
        case .genderButtonDidTap(let gender):
            selectedGender = gender
            output.selectedGender?(gender)
            
        case .introductionDidChange(let introduction):
            self.introduction = introduction
            
        case .keywordButtonDidTap(let keyword):
            updateSelectedKeywords(keyword)
            
        case .profileImageDidSelect(
            let data, let fileName, let contentType
        ):
            updateProfileImage(data: data, fileName: fileName, contentType: contentType)
            
        case .bottomButtonDidTap:
            completeOnboarding()
        }
    }
}

// MARK: - Methods

private extension CompanionProfileViewModel {
    
    func updateSelectedKeywords(_ keyword: String) {
        if selectedKeywords.contains(keyword) {
            selectedKeywords.remove(keyword)
            output.selectedKeywords?(selectedKeywords)
            return
        }
        
        guard selectedKeywords.count < maximumKeywordCount else {
            output.keywordSelectionDidFail?(
                "여행 스타일 키워드는 최대 6개까지 선택할 수 있어요."
            )
            return
        }
        
        selectedKeywords.insert(keyword)
        output.selectedKeywords?(selectedKeywords)
    }
    
    func updateProfileImage(
        data: Data,
        fileName: String,
        contentType: String
    ) {
        profileImageData = data
        profileImageFileName = fileName
        profileImageContentType = contentType
    }
    
    func completeOnboarding() {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let trimmedIntroduction = introduction.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard validateNickname(trimmedNickname) else {
            return
        }
        
        guard trimmedIntroduction.count <= 50 else {
            output.onboardingDidFail?("한줄 소개는 50자 이하로 입력해주세요.")
            return
        }
        
        guard !selectedKeywords.isEmpty else {
            output.keywordSelectionDidFail?("여행 스타일 키워드를 1개 이상 선택해주세요.")
            return
        }
        
        let travelStyleKeywords = makeServerKeywords(from: selectedKeywords)
        
        guard !travelStyleKeywords.isEmpty else {
            output.keywordSelectionDidFail?("선택한 여행 스타일 키워드를 확인해주세요.")
            return
        }
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            output.isLoading?(true)
            
            defer {
                output.isLoading?(false)
            }
            
            do {
                let response = try await authRepository.completeCompanionProfile(
                    nickname: trimmedNickname,
                    gender: selectedGender,
                    intro: trimmedIntroduction.isEmpty ? nil : trimmedIntroduction,
                    travelStyleKeywords: travelStyleKeywords,
                    imageData: profileImageData,
                    imageFileName: profileImageFileName,
                    imageContentType: profileImageContentType
                )
                
                guard response.onboardingStatus == .completed else {
                    output.onboardingDidFail?("온보딩 완료 상태를 확인하지 못했습니다.")
                    return
                }
                
                output.onboardingDidComplete?()
            } catch {
                handleOnboardingError(error)
            }
        }
    }
    
    func validateNickname(_ nickname: String) -> Bool {
        guard !nickname.isEmpty else {
            output.nicknameDidFail?("닉네임을 입력해주세요.")
            return false
        }
        
        guard nickname.count <= 15 else {
            output.nicknameDidFail?("닉네임은 15자 이하로 입력해주세요.")
            return false
        }
        
        return true
    }
    
    func makeServerKeywords(from selectedKeywords: Set<String>) -> [String] {
        let displayOrder = [
            "외향형",
            "내향형",
            "계획형",
            "즉흥형",
            "느좋 카페 투어",
            "도보여행",
            "사진 맛집 투어",
            "미식 탐방",
            "디저트 중독",
            "소품샵 투어",
            "야경 러버",
            "역사 탐방",
            "전시장 러버",
            "한 곳 오래",
            "많이 도는형",
            "음주 애호가",
            "음주 비선호"
        ]
        
        let mappedKeywords: [String] = displayOrder.compactMap { keyword -> String? in
            guard selectedKeywords.contains(keyword) else {
                return nil
            }
            
            return serverKeyword(from: keyword)
        }
        
        var result: [String] = []
        
        mappedKeywords.forEach { keyword in
            guard !result.contains(keyword) else {
                return
            }
            
            result.append(keyword)
        }
        
        return result
    }
    
    func serverKeyword(from keyword: String) -> String? {
        TravelStyleKeyword.allCases
            .first { $0.title == keyword }?
            .rawValue
    }
    
    func handleOnboardingError(_ error: Error) {
        AppLogger.error(error, message: "동행 프로필 등록 및 온보딩 완료 실패")
        
        guard let networkError = error as? NetworkError else {
            output.onboardingDidFail?(
                """
                동행 프로필 등록에 실패했습니다.

                \(String(describing: error))
                """
            )
            return
        }
        
        switch networkError {
        case .badRequest(let code, let message):
            if code == "VALIDATION_ERROR" {
                output.onboardingDidFail?("입력한 프로필 정보를 다시 확인해주세요.")
            } else {
                output.onboardingDidFail?(message)
            }
            
        case .unauthorized(_, let message):
            output.onboardingDidFail?(
                message.isEmpty ? "로그인이 필요합니다." : message
            )
            
        case .conflict(let code, let message):
            switch code {
            case "PHONE_VERIFICATION_REQUIRED":
                output.onboardingDidFail?("휴대폰 인증이 완료되지 않았습니다.")
                
            case "DUPLICATE_NICKNAME":
                output.nicknameDidFail?("이미 사용 중인 닉네임입니다.")
                
            default:
                output.onboardingDidFail?(message)
            }
            
        default:
            output.onboardingDidFail?(
                networkError.localizedDescription
            )
        }
    }
}
