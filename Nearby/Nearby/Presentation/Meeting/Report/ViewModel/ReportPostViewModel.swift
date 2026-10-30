//
//  ReportPostViewModel.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import Foundation

final class ReportPostViewModel: BaseViewModelType, RequestRunning {
    let requestRunner = RequestRunner()
    
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
        let detailPlaceholder = PassthroughSubject<String, Never>()
        let clearDetailText = PassthroughSubject<Void, Never>()
        let submitSuccess = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
    
    let output: Output = Output()
    let reasons = ReportReason.allCases
    
    private let target: MeetingReportTarget
    private let repository: MeetingRepository
    private(set) var selectedReasons = Set<Int>()
    private var detailText: String = ""
    private var isSubmitting = false
    
    var detailPlaceholder: String {
        if isNicknameRequired {
            return "신고할 사용자의 닉네임과 상세 내용을 입력해주세요"
        }
        return isEtcSelected ? "신고와 관련된 상세 내용을 입력해주세요." : "신고와 관련된 상세 내용을 입력해주세요. (선택)"
    }
    
    private var isNicknameRequired: Bool {
        target.reportedUserID == nil
    }
    
    private var isEtcSelected: Bool {
        selectedReasons.contains(ReportReason.extra.rawValue)
    }
    
    private var isDetailRequired: Bool {
        isNicknameRequired || isEtcSelected
    }
    
    private var trimmedDetailText: String {
        detailText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var isReportValid: Bool {
        guard !selectedReasons.isEmpty else { return false }
        return !isDetailRequired || !trimmedDetailText.isEmpty
    }
    
    // MARK: - Initializer
    
    init(target: MeetingReportTarget, repository: MeetingRepository) {
        self.target = target
        self.repository = repository
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .reasonDidTap(let index):
            let changed = toggleReason(index)
            output.reloadReasons.send(changed)
            if !isDetailRequired {
                detailText = ""
                output.clearDetailText.send(())
            }
            output.detailPlaceholder.send(detailPlaceholder)
            updateReportState()
            
        case .detailTextChanged(let text):
            detailText = text
            syncEtcWithDetailText()
            updateReportState()
            
        case .reportButtonDidTap:
            guard isReportValid, !isSubmitting else { return }
            submitReport()
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
    
    private func syncEtcWithDetailText() {
        let shouldSelectEtc = !trimmedDetailText.isEmpty
        guard shouldSelectEtc != isEtcSelected else { return }
        if shouldSelectEtc {
            selectedReasons.insert(ReportReason.extra.rawValue)
        } else {
            selectedReasons.remove(ReportReason.extra.rawValue)
        }
        output.reloadReasons.send([ReportReason.extra.rawValue])
        output.detailPlaceholder.send(detailPlaceholder)
    }

    private func updateReportState() {
        output.isReportButtonEnabled.send(isReportValid)
    }
    
    private func submitReport() {
        let report = MeetingReport(
            reportedUserID: target.reportedUserID,
            reasons: selectedReasons.sorted().compactMap(ReportReason.init(rawValue:)),
            detail: trimmedDetailText.isEmpty ? nil : trimmedDetailText
        )

        requestRunner.run(
            onStart: { [self] in
                isSubmitting = true
            },
            operation: { [self] in
                switch target {
                case .meeting(let meetingID, _):
                    try await repository.report(meetingId: meetingID, report: report)
                case .match(let matchID, _):
                    try await repository.report(matchId: matchID, report: report)
                }
            },
            onSuccess: { [self] _ in
                output.submitSuccess.send(())
            },
            onFailure: { error in
                AppLogger.error(error)
            },
            onFinish: { [self] in
                isSubmitting = false
            }
        )
    }
}
