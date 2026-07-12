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
    private let googlePlaceService = GooglePlaceService()

    private var placeSearchWorkItem: DispatchWorkItem?

    private let userLatitude = 41.389458
    private let userLongitude = 2.168289

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
            guard let self else { return }

            viewModel.action(.placeQueryDidChange(query))
            searchPlacesWithDebounce(query: query)
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

private extension RecruitCompanionViewController {
    func searchPlacesWithDebounce(query: String) {
        placeSearchWorkItem?.cancel()

        let trimmedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedQuery.isEmpty else {
            rootView.updatePlaceSuggestions([])
            return
        }

        let workItem = DispatchWorkItem { [weak self] in
            self?.searchPlaces(query: trimmedQuery)
        }

        placeSearchWorkItem = workItem

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.4,
            execute: workItem
        )
    }

    func searchPlaces(query: String) {
        googlePlaceService.searchPlaces(
            query: query,
            latitude: userLatitude,
            longitude: userLongitude
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let suggestions):
                    self.rootView.updatePlaceSuggestions(suggestions)

                case .failure:
                    self.rootView.updatePlaceSuggestions([])
                }
            }
        }
    }
}
