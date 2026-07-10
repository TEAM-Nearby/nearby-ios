//
//  ReportCompletionViewController.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class ReportCompletionViewController: BaseViewController<EmptyViewModel> {
    
    // MARK: - UI Component
    
    private let reportCompletionView = ReportCompletionView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = reportCompletionView
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        reportCompletionView.onConfirmButtonDidTap = { [weak self] in
            self?.coordinator?.dismissReportFlow()
        }
    }
}
