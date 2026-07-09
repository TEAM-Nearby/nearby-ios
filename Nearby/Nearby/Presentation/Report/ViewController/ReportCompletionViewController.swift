//
//  ReportCompletionViewController.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

final class ReportCompletionViewController: UIViewController {
    
    // MARK: - UI Component
    
    private let reportCompletionView = ReportCompletionView()
    
    // MARK: - Property
    
    weak var coordinator: MeetingTabCoordinator?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = reportCompletionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
    }
    
    // MARK: - Method
    
    private func setAddTarget() {
        reportCompletionView.onConfirmButtonDidTap = { [weak self] in
       self?.coordinator?.dismissReportFlow()
        }
    }
}
