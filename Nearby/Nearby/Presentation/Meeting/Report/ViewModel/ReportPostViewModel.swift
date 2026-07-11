//
//  ReportPostViewModel.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class ReportPostViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case reasonDidTap(Int)
        case detailTextChanged(String)
        case reportButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadReasons = PassthroughSubject<[Int], Never>()
        let isReportButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        let submitSuccess = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
    
    let output: Output = Output()
    let reasons = ReportReason.allCases
    
    private(set) var selectedReasons = Set<Int>()
    private var detailText: String = ""
    
    private var isEtcSelected: Bool {
        selectedReasons.contains(ReportReason.extra.rawValue)
    }
    
    private var isReportValid: Bool {
        guard !selectedReasons.isEmpty else { return false }
        if isEtcSelected {
            return !detailText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .reasonDidTap(let index):
            let changed = toggleReason(index)
            output.reloadReasons.send(changed)
            updateReportState()
            
        case .detailTextChanged(let text):
            detailText = text
            updateReportState()
            
        case .reportButtonDidTap:
            guard isReportValid else { return }
            // TODO: - 신고 API 연동 (selectedReasons, detailText)
            output.submitSuccess.send(())
        }
    }
    
    // MARK: - Methods
    
    private func toggleReason(_ index: Int) -> [Int] {
        if selectedReasons.contains(index) {
            selectedReasons.remove(index)
        } else {
            selectedReasons.insert(index)
        }
        return [index]
    }
    
    private func updateReportState() {
        output.isReportButtonEnabled.send(isReportValid)
    }
}
