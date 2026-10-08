//
//  DiningMapViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation

final class DiningMapViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case locationDidUpdate(CLLocationCoordinate2D)
    }
    
    // MARK: - Output
    
    struct Output {
        let mapConfiguration: CompanionMapConfiguration
        let nickname = PassthroughSubject<String, Never>()
        let cityName = CurrentValueSubject<String, Never>("현재 위치")
    }
    
    // MARK: - Properties
    
    let output: Output
    
    private let myPageRepository: MyPageRepository
    private var nicknameTask: Task<Void, Never>?
    
    // MARK: - Initializer
    
    init(myPageRepository: MyPageRepository, mapConfiguration: CompanionMapConfiguration = .diningMap) {
        self.myPageRepository = myPageRepository
        self.output = Output(mapConfiguration: mapConfiguration)
    }
    
    deinit {
        nicknameTask?.cancel()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchNickname()
        case .locationDidUpdate(let coordinate):
            output.cityName.send(DiningMapCity.name(for: coordinate))
        }
    }
    
    // MARK: - Method
    
    func fetchNickname() {
        nicknameTask?.cancel()
        nicknameTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                let response = try await myPageRepository.fetchMyPage()
                guard !Task.isCancelled else { return }
                output.nickname.send(response.nickname)
            } catch {
                guard !Task.isCancelled else { return }
                AppLogger.error(error)
            }
        }
    }
}

private enum DiningMapCity: CaseIterable {
    case barcelona
    case madrid
    case paris
    case london

    private static let maximumDistance: CLLocationDistance = 100_000

    var name: String {
        switch self {
        case .barcelona: return "바르셀로나"
        case .madrid: return "마드리드"
        case .paris: return "파리"
        case .london: return "런던"
        }
    }

    var location: CLLocation {
        switch self {
        case .barcelona: return CLLocation(latitude: 41.3879706, longitude: 2.1671360)
        case .madrid: return CLLocation(latitude: 40.4168, longitude: -3.7038)
        case .paris: return CLLocation(latitude: 48.8566, longitude: 2.3522)
        case .london: return CLLocation(latitude: 51.5074, longitude: -0.1278)
        }
    }

    static func name(for coordinate: CLLocationCoordinate2D) -> String {
        let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let nearestCity = allCases.min(by: { $0.location.distance(from: currentLocation) < $1.location.distance(from: currentLocation) }), nearestCity.location.distance(from: currentLocation) <= maximumDistance else { return "현재 위치" }
        return nearestCity.name
    }
}

private extension CompanionMapConfiguration {
    static var developmentReferenceCoordinate: CLLocationCoordinate2D? {
#if DEBUG
        CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
#else
        nil
#endif
    }

    static let diningMap = CompanionMapConfiguration(
        referenceCoordinate: developmentReferenceCoordinate,
        initialZoom: 16.2,
        smallMarkerMaximumZoom: -1,
        largeMarkerMinimumZoom: 100,
        mediumMarkerSize: 24,
        smallMarkerSize: 10
    )
}
