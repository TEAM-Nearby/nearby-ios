//
//  WrittenPostViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import Foundation

final class WrittenPostViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case findCompanionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        var writtenPostItems: (([WrittenPostItem]) -> Void)?
        var errorMessage: ((String) -> Void)?
        var backButtonDidTap: (() -> Void)?
        var findCompanionButtonDidTap: (() -> Void)?
    }
    
    // MARK: - Properties
    
    var output = Output()
    
    private var writtenPostItems: [WrittenPostItem] = []
    private let repository: MyPageRepository
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Initializer
    
    init(repository: MyPageRepository) {
        self.repository = repository
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMyCompanionPosts()
            
        case .backButtonDidTap:
            output.backButtonDidTap?()
            
        case .findCompanionButtonDidTap:
            output.findCompanionButtonDidTap?()
        }
    }
    
    // MARK: - Method
    
    func fetchMyCompanionPosts() {
        fetchTask?.cancel()
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                let response = try await repository.fetchMyCompanionPosts()
                guard !Task.isCancelled else { return }
                
                writtenPostItems = response.posts.map(WrittenPostItem.init(response:))
                
                await MainActor.run {
                    output.writtenPostItems?(writtenPostItems)
                }
            } catch {
                guard !Task.isCancelled else { return }
                
                let message = (error as? LocalizedError)?.errorDescription ?? "내가 작성한 모집글을 불러오지 못했습니다."
                
                await MainActor.run {
                    output.errorMessage?(message)
                }
            }
        }
    }
}
