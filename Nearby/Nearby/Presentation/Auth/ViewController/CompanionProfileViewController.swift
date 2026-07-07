//
//  CompanionProfileViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/7/26.
//

import UIKit

final class CompanionProfileViewController: BaseViewController<CompanionProfileViewModel> {
    
    // MARK: - UI Component
    
    private let companionProfileView = CompanionProfileView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = companionProfileView
    }
    
    // MARK: - Custom Method
    
    override func setAddTarget() {
        companionProfileView.navigationBar.leftButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        companionProfileView.maleButton.addTarget(
            self,
            action: #selector(maleButtonDidTap),
            for: .touchUpInside
        )
        
        companionProfileView.femaleButton.addTarget(
            self,
            action: #selector(femaleButtonDidTap),
            for: .touchUpInside
        )
        
        companionProfileView.nicknameClearButton.addTarget(
            self,
            action: #selector(nicknameClearButtonDidTap),
            for: .touchUpInside
        )
        
        companionProfileView.introductionClearButton.addTarget(
            self,
            action: #selector(introductionClearButtonDidTap),
            for: .touchUpInside
        )
        
        companionProfileView.bottomButton.addTarget(
            self,
            action: #selector(bottomButtonDidTap),
            for: .touchUpInside
        )
        
        companionProfileView.keywordButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(keywordButtonDidTap(_:)),
                for: .touchUpInside
            )
        }
    }
    
    override func setDelegate() {
        companionProfileView.nicknameTextField.delegate = self
        companionProfileView.introductionTextView.delegate = self
    }
    
    override func bindState() {
        viewModel.output.selectedGender = { [weak self] gender in
            self?.companionProfileView.updateGender(selectedGender: gender)
        }
        
        viewModel.output.selectedKeywords = { [weak self] selectedKeywords in
            self?.companionProfileView.updateSelectedKeywords(selectedKeywords)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func maleButtonDidTap() {
        viewModel.action(.genderButtonDidTap(.male))
    }
    
    @objc
    private func femaleButtonDidTap() {
        viewModel.action(.genderButtonDidTap(.female))
    }
    
    @objc
    private func nicknameClearButtonDidTap() {
        companionProfileView.clearNicknameText()
        viewModel.action(.nicknameDidChange(""))
    }
    
    @objc
    private func introductionClearButtonDidTap() {
        companionProfileView.clearIntroductionText()
        viewModel.action(.introductionDidChange(""))
    }
    
    @objc
    private func keywordButtonDidTap(_ sender: NearbyChipButton) {
        viewModel.action(.keywordButtonDidTap(sender.chipTitle))
    }
    
    @objc
    private func bottomButtonDidTap() {
        viewModel.action(.bottomButtonDidTap)
    }
}

// MARK: - UITextFieldDelegate

extension CompanionProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        companionProfileView.nicknameClearButton.isHidden = text.isEmpty
        viewModel.action(.nicknameDidChange(text))
    }
}

// MARK: - UITextViewDelegate

extension CompanionProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        companionProfileView.introductionClearButton.isHidden = text.isEmpty
        companionProfileView.updateIntroductionPlaceholder(isHidden: !text.isEmpty)
        viewModel.action(.introductionDidChange(text))
    }
}
