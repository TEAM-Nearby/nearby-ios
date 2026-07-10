//
//  EmptyCompanionBottomSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

final class EmptyCompanionBottomSheetViewController: BaseViewController<EmptyViewModel> {
    
    // MARK: - Property
    
    private let emptyCompanionBottomSheetView = EmptyCompanionBottomSheetView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = emptyCompanionBottomSheetView
    }
}
