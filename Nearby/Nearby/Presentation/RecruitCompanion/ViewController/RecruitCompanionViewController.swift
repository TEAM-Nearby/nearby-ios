//
//  RecruitCompanionViewController.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Combine
import UIKit

final class RecruitCompanionViewController: BaseViewController<RecruitCompanionViewModel> {

    // MARK: - Properties

    weak var coordinator: CompanionCoordinator?

    private let rootView = RecruitCompanionView()

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.alpha = 1
        tabBarController?.tabBar.transform = .identity
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        rootView.backButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        rootView.timeTypeDidSelect = { [weak self] type in
            self?.viewModel.action(.timeTypeDidSelect(type))
        }

        rootView.meetingAtDidChange = { [weak self] date in
            self?.viewModel.action(.meetingAtDidChange(date))
        }

        rootView.participantCountDidChange = { [weak self] count in
            self?.viewModel.action(.participantCountDidChange(count))
        }

        rootView.styleKeywordDidTap = { [weak self] keyword in
            self?.viewModel.action(.styleKeywordDidTap(keyword))
        }

        rootView.placeSearchButtonAction = { [weak self] in
            self?.view.endEditing(true)
        }

        rootView.placeQueryDidChange = { [weak self] query in
            self?.viewModel.action(.placeQueryDidChange(query))
        }

        rootView.contentDidChange = { [weak self] content in
            self?.viewModel.action(.contentDidChange(content))
        }

        rootView.openChatURLDidChange = { [weak self] url in
            self?.viewModel.action(.openChatURLDidChange(url))
        }

        rootView.completeButtonAction = { [weak self] in
            self?.viewModel.action(.completeButtonDidTap)
        }

        rootView.placeDidSelect = { [weak self] place in
            self?.viewModel.action(.placeDidSelect(place))
        }
    }

    override func bindState() {
        viewModel.output.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.rootView.update(state: state)
            }
            .store(in: &cancellables)

        viewModel.output.placeSuggestions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] suggestions in
                self?.rootView.updatePlaceSuggestions(suggestions)
            }
            .store(in: &cancellables)

        viewModel.output.completeButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        viewModel.output.showBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.showPrevious()
            }
            .store(in: &cancellables)

        viewModel.action(.viewDidLoad)
    }
}
