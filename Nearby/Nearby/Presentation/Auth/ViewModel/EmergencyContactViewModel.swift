//
//  EmergencyContactViewModel.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import Foundation

final class EmergencyContactViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case nameDidChange(String)
        case phoneDidChange(String)
        case bottomButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var isBottomButtonEnabled: ((Bool) -> Void)?
        var registrationDidComplete: (() -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private var name = ""
    private var phoneNumber = ""

    // MARK: - Methods

    func action(_ trigger: Input) {
        switch trigger {
        case .nameDidChange(let name):
            self.name = name
            updateButtonState()

        case .phoneDidChange(let phoneNumber):
            self.phoneNumber = phoneNumber
            updateButtonState()

        case .bottomButtonDidTap:
            guard isValidInput else { return }
            output.registrationDidComplete?()
        }
    }

    // MARK: - Custom Methods

    private var isValidInput: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValidName = !trimmedName.isEmpty

        let isValidPhone = phoneNumber.count == 11
            && phoneNumber.hasPrefix("010")
            && phoneNumber.allSatisfy { $0.isNumber }

        return isValidName && isValidPhone
    }

    private func updateButtonState() {
        output.isBottomButtonEnabled?(isValidInput)
    }
}
