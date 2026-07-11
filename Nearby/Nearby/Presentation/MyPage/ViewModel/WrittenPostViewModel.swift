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
        var backButtonDidTap: (() -> Void)?
        var findCompanionButtonDidTap: (() -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private var writtenPostItems: [WrittenPostItem] = []

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.writtenPostItems?(
                writtenPostItems
            )

        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .findCompanionButtonDidTap:
            output.findCompanionButtonDidTap?()
        }
    }
}
