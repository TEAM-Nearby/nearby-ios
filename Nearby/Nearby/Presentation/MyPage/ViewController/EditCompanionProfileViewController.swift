//
//  EditCompanionProfileViewController.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

final class EditCompanionProfileViewController:
    BaseViewController<EditCompanionProfileViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onProfileUpdateDidComplete: (() -> Void)?

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
}
