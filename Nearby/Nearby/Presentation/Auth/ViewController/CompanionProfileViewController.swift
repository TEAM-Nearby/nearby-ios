//
//  CompanionProfileViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/7/26.
//

import PhotosUI
import UIKit

final class CompanionProfileViewController: BaseViewController<CompanionProfileViewModel> {
    
    // MARK: - UI Component
    
    private let companionProfileView = CompanionProfileView()
    
    // MARK: - Property

    var onProfileCompleted: (() -> Void)?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = companionProfileView
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        companionProfileView.navigationBar.leftButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        companionProfileView.profileImageButton.addTarget(
            self, action: #selector(profileImageButtonDidTap), for: .touchUpInside
        )
        companionProfileView.maleButton.addTarget(
            self, action: #selector(maleButtonDidTap), for: .touchUpInside
        )
        companionProfileView.femaleButton.addTarget(
            self, action: #selector(femaleButtonDidTap), for: .touchUpInside
        )
        companionProfileView.nicknameClearButton.addTarget(
            self, action: #selector(nicknameClearButtonDidTap), for: .touchUpInside
        )
        companionProfileView.introductionTextView.clearButton.addTarget(
            self, action: #selector(introductionClearButtonDidTap), for: .touchUpInside
        )
        companionProfileView.bottomButton.addTarget(
            self, action: #selector(bottomButtonDidTap), for: .touchUpInside
        )
        companionProfileView.keywordButtons.forEach {
            $0.addTarget(self, action: #selector(keywordButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    override func setDelegate() {
        companionProfileView.nicknameTextField.delegate = self
        companionProfileView.introductionTextView.textView.delegate = self
    }
    
    override func bindState() {
        viewModel.output.selectedGender = { [weak self] gender in
            self?.companionProfileView.updateGender(selectedGender: gender)
        }
        
        viewModel.output.selectedKeywords = { [weak self] selectedKeywords in
            self?.companionProfileView.updateSelectedKeywords(selectedKeywords)
        }
        
        viewModel.output.nicknameDidFail = { [weak self] message in
            guard let self else { return }
            
            self.showAlert(title: "닉네임을 확인해주세요", message: message)
        }
        
        viewModel.output.keywordSelectionDidFail = { [weak self] message in
            guard let self else { return }
            
            self.showAlert(title: "여행 스타일을 확인해주세요", message: message)
        }
        
        viewModel.output.onboardingDidFail = { [weak self] message in
            guard let self else { return }
            
            self.showAlert(title: "프로필 등록 실패", message: message)
        }
        
        viewModel.output.onboardingDidComplete = { [weak self] in
            guard let self else { return }
            
            self.onProfileCompleted?()
        }
        
        viewModel.output.isLoading = { [weak self] isLoading in
            guard let self else { return }
            
            self.companionProfileView.bottomButton.isEnabled = !isLoading
        }
    }
    
    // MARK: - Method
    
    private func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func profileImageButtonDidTap() {
        presentPhotoPicker()
    }
    
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

// MARK: - PHPickerViewControllerDelegate

extension CompanionProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self,
                  let image = image as? UIImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }

            let fileName = "\(UUID().uuidString).jpg"

            DispatchQueue.main.async {
                self.companionProfileView.updateProfileImage(image)
                self.viewModel.action(.profileImageDidSelect(data: imageData, fileName: fileName, contentType: "image/jpeg"))
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension CompanionProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        viewModel.action(.nicknameDidChange(text))
    }
}

// MARK: - UITextViewDelegate

extension CompanionProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        companionProfileView.updateIntroductionPlaceholder(isHidden: !text.isEmpty)
        viewModel.action(.introductionDidChange(text))
    }
}
