//
//  HostRequestRecieveViewModel.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import Combine
import UIKit

final class HostRequestRecieveViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case rejectButtonDidTap
        case allowButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let showHostRejectView = PassthroughSubject<Void, Never>()
        let showHostAllowView = PassthroughSubject<Void, Never>()
    }

    struct DisplayData {
        let image: UIImage
        let name: String
        let profile: UIImage
        let gender: String
        let level: String
        let title: String
        let subtitle: String
        let location: String
        let date: String
    }

    // MARK: - Properties

    let output = Output()

    private let applicantName: String
    private let locationName: String
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer

    init(applicantName: String, locationName: String) {
        self.applicantName = applicantName
        self.locationName = locationName
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            let data = DisplayData(
                image: .illustLetterProfile,
                name: "\(applicantName)",
                profile: .imgProfileDefault,
                gender: "여성",
                level: "4",
                title: "함께 동행을 원하는 분이 있어요",
                subtitle: "대화를 나눈 후 일정을 확정해보세요",
                location: "\(locationName)",
                date: "6월 18일 (목) 오후 4시 30분"
            )
            output.displayData.send(data)

        case .rejectButtonDidTap:
            output.showHostRejectView.send(())
        case .allowButtonDidTap:
            output.showHostAllowView.send(())
        }
    }
}
