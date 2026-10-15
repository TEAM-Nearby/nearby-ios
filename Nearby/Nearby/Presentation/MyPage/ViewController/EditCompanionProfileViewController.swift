//
//  EditCompanionProfileViewController.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit
import PhotosUI

final class EditCompanionProfileViewController:
    BaseViewController<EditCompanionProfileViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onProfileUpdateDidComplete: (() -> Void)?
    private var profileImageTask: Task<Void, Never>?

    // MARK: - UI Component

    private let editProfileView = EditCompanionProfileView()

    // MARK: - Life Cycles
    
    override func loadView() {
        view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent || isBeingDismissed {
            profileImageTask?.cancel()
        }
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        editProfileView.navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }

        editProfileView.onNicknameDidChange = { [weak self] nickname in
            self?.viewModel.action(.nicknameDidChange(nickname))
        }

        editProfileView.onIntroductionDidChange = { [weak self] introduction in
            self?.viewModel.action(.introductionDidChange(introduction))
        }

        editProfileView.onKeywordButtonDidTap = { [weak self] keyword in
            self?.viewModel.action(.keywordButtonDidTap(keyword))
        }

        editProfileView.onSaveButtonDidTap = { [weak self] in
            self?.viewModel.action(.saveButtonDidTap)
        }
        
        editProfileView.onProfileImageButtonDidTap = { [weak self] in
            self?.presentPhotoPicker()
        }
    }

    override func bindState() {
        viewModel.output.selectedKeywordsDidChange = { [weak self] keywords in
            self?.editProfileView.updateSelectedKeywords(keywords)
        }

        viewModel.output.keywordSelectionDidFail = { [weak self] message in
            self?.showAlert(message: message)
        }

        viewModel.output.profileUpdateDidFail = { [weak self] message in
            self?.showAlert(message: message)
        }

        viewModel.output.profileUpdateDidComplete = { [weak self] in
            self?.onProfileUpdateDidComplete?()
        }

        viewModel.output.isLoading = { [weak self] isLoading in
            self?.editProfileView.bottomButton.isEnabled = !isLoading
        }
        
        viewModel.output.profileDidLoad = { [weak self] profile in
            guard let self else { return }

            editProfileView.configure(nickname: profile.nickname, introduction: profile.intro, selectedKeywords: viewModel.currentSelectedKeywordTitles())

            loadProfileImage(from: profile.profileImageURL)
        }
    }
}

// MARK: - Private Methods

private extension EditCompanionProfileViewController {

    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "확인", style: .default))

        present(alertController, animated: true)
    }
    
    func loadProfileImage(from urlString: String?) {
        profileImageTask?.cancel()

        guard let urlString, let url = URL(string: urlString), url.scheme == "https" else {
            return
        }

        profileImageTask = Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                guard !Task.isCancelled, let image = UIImage(data: data) else {
                    return
                }

                await MainActor.run {
                    self?.editProfileView.updateProfileImage(image)
                }
            } catch {
                // 이미지 로딩 실패 시 기본 프로필 이미지 유지
            }
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension EditCompanionProfileViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard error == nil, let image = object as? UIImage else {
                return
            }

            Task { @MainActor [weak self] in
                self?.editProfileView.updateProfileImage(image)
            }
        }
    }
}

// MARK: - Photo Picker

private extension EditCompanionProfileViewController {

    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        present(picker, animated: true)
    }
}
