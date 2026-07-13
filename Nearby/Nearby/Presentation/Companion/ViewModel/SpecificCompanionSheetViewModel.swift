//
//  SpecificCompanionSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import Combine

final class SpecificCompanionSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {}
    
    // MARK: - Output
    
    struct Output {
        let companions: CurrentValueSubject<[SpecificCompanionCellItem], Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    
    var companionCount: Int {
        output.companions.value.count
    }
    
    // MARK: - Initializer
    
    init(companions: [SpecificCompanionCellItem] = []) {
        self.output = Output(companions: CurrentValueSubject(companions))
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {}
    
    func companion(at index: Int) -> SpecificCompanionCellItem {
        output.companions.value[index]
    }

    func updateCompanions(_ companions: [SpecificCompanionCellItem]) {
        output.companions.send(companions)
    }
}
