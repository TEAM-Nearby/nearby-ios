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
        case bottomButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        var selectedGender: ((NearbyGender) -> Void)?
        var selectedKeywords: ((Set<String>) -> Void)?
    }
    
    // MARK: - Properties
    
    var output: Output
    
    private var nickname = ""
    private var selectedGender: NearbyGender = .female
    private var introduction = ""
    private var selectedKeywords: Set<String> = []
    
    // MARK: - Initializer
    
    init() {
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
            
        case .bottomButtonDidTap:
            // TODO: - Coordinator 연결 후 다음 화면 이동
            break
        }
    }
    
    // MARK: - Method
    
    private func updateSelectedKeywords(_ keyword: String) {
        if selectedKeywords.contains(keyword) {
            selectedKeywords.remove(keyword)
        } else {
            selectedKeywords.insert(keyword)
        }
        
        output.selectedKeywords?(selectedKeywords)
    }
}
