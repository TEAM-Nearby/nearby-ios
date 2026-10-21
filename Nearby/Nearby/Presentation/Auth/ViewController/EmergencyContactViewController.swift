//
//  EmergencyContactViewController.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

final class EmergencyContactViewController: BaseViewController<EmergencyContactViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onRegistrationCompleted: (() -> Void)?

    // MARK: - UI Component

    private let emergencyContactView = EmergencyContactView()

    // MARK: - Life Cycle

    override func loadView() {
        view = emergencyContactView
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        emergencyContactView.nameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)

        emergencyContactView.phoneTextField.addTarget(self, action: #selector(phoneDidChange), for: .editingChanged)

        emergencyContactView.nameClearButton.addTarget(self, action: #selector(nameClearButtonDidTap), for: .touchUpInside)

        emergencyContactView.phoneClearButton.addTarget(self, action: #selector(phoneClearButtonDidTap), for: .touchUpInside)

        emergencyContactView.bottomButton.addTarget(self, action: #selector(bottomButtonDidTap), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissEmergencyContactKeyboard))

        tapGesture.cancelsTouchesInView = false
        emergencyContactView.addGestureRecognizer(tapGesture)
    }

    override func bindAction() {
        super.bindAction()

        emergencyContactView.navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
    }

    override func bindState() {
        viewModel.output.isBottomButtonEnabled = { [weak self] isEnabled in
            self?.emergencyContactView.updateBottomButton(isEnabled: isEnabled)
        }

        viewModel.output.registrationDidComplete = { [weak self] in
            self?.onRegistrationCompleted?()
        }
    }
    
    override func setDelegate() {
        emergencyContactView.nameTextField.delegate = self
        emergencyContactView.phoneTextField.delegate = self
    }

    // MARK: - Action

    @objc
    private func nameDidChange() {
        let name = emergencyContactView.nameTextField.text ?? ""

        viewModel.action(.nameDidChange(name))
        emergencyContactView.updateClearButtons()
    }

    @objc
    private func phoneDidChange() {
        let phoneNumber = emergencyContactView.phoneTextField.text ?? ""

        viewModel.action(.phoneDidChange(phoneNumber))
        emergencyContactView.updateClearButtons()
    }

    @objc
    private func nameClearButtonDidTap() {
        emergencyContactView.nameTextField.text = ""

        viewModel.action(.nameDidChange(""))
        emergencyContactView.updateClearButtons()
    }

    @objc
    private func phoneClearButtonDidTap() {
        emergencyContactView.phoneTextField.text = ""

        viewModel.action(.phoneDidChange(""))
        emergencyContactView.updateClearButtons()
    }

    @objc
    private func bottomButtonDidTap() {
        viewModel.action(.bottomButtonDidTap)
    }
    
    @objc
    private func dismissEmergencyContactKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension EmergencyContactViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
