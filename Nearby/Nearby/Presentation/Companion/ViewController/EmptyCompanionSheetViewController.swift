//
//  EmptyCompanionSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

final class EmptyCompanionSheetViewController: BaseViewController<EmptyViewModel> {
    
    // MARK: - Property
    
    private let emptyCompanionSheetView = EmptyCompanionSheetView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = emptyCompanionSheetView
    }

    // MARK: - Method

    func restartAnimation() {
        loadViewIfNeeded()
        emptyCompanionSheetView.restartAnimation()
    }
}
