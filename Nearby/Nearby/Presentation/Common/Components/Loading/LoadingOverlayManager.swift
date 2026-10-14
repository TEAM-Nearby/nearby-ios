//
//  LoadingOverlayManager.swift
//  Nearby
//
//  Created by soomin on 10/13/26.
//

import Combine
import UIKit

@MainActor
final class LoadingOverlayManager {
    
    // MARK: - Properties
    
    static let shared = LoadingOverlayManager()

    private final class Entry {
        weak var owner: UIViewController?
        weak var button: NearbyButton?
        var state: CTARequestState.State
        let order: Int

        init(owner: UIViewController, button: NearbyButton?, state: CTARequestState.State, order: Int) {
            self.owner = owner
            self.button = button
            self.state = state
            self.order = order
        }
    }

    private var entries: [UUID: Entry] = [:]
    private var overlays: [ObjectIdentifier: LoadingView] = [:]
    private var alerts: [UUID: UIAlertController] = [:]
    private var alertWindows: [UUID: ObjectIdentifier] = [:]
    private var nextOrder = 0
    
    // MARK: - Initializer

    private init() {}

    // MARK: - Methods
    
    private func render(_ state: CTARequestState.State, runner: RequestRunner, owner: UIViewController) {
        switch state {
        case .idle, .connectionFailure:
            entries.removeValue(forKey: runner.id)?.button?.isRequestInProgress = false
        default:
            if let entry = entries[runner.id] {
                entry.state = state
            } else {
                nextOrder += 1
                let button = NearbyButton.currentActionButton
                button?.isRequestInProgress = true
                entries[runner.id] = Entry(owner: owner, button: button, state: state, order: nextOrder)
            }
        }
        updateOverlays()
        
        if state == .connectionFailure { showNetworkAlert(for: runner, owner: owner) }
    }

    private func updateOverlays() {
        entries = entries.filter { $0.value.owner != nil }
        var visibleWindows = Set<ObjectIdentifier>()
        
        let orderedEntries = entries.values.sorted {
            let leftPriority = $0.state == .networkLoading ? 1 : 0
            let rightPriority = $1.state == .networkLoading ? 1 : 0
            return leftPriority == rightPriority ? $0.order < $1.order : leftPriority < rightPriority
        }
        
        for entry in orderedEntries {
            guard let owner = entry.owner, let window = owner.viewIfLoaded?.window else { continue }
            let message: String
            let isFullScreen: Bool
            switch entry.state {
            case .loading(let text):
                message = text
                isFullScreen = false
            case .networkLoading:
                message = "연결이 원활하지 않아요.\n잠시만 기다려주세요"
                isFullScreen = true
            default: continue
            }
            
            let windowID = ObjectIdentifier(window)
            guard !alertWindows.values.contains(windowID) else { continue }
            visibleWindows.insert(windowID)
            
            let overlay = overlays[windowID] ?? LoadingView(frame: window.bounds)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.configure(message: message, isFullScreen: isFullScreen)
            
            if overlay.superview == nil {
                owner.view.endEditing(true)
                window.addSubview(overlay)
            }
            overlays[windowID] = overlay
        }
        for id in Array(overlays.keys) where !visibleWindows.contains(id) {
            overlays.removeValue(forKey: id)?.removeFromSuperview()
        }
    }

    private func showNetworkAlert(for runner: RequestRunner, owner: UIViewController) {
        guard let window = owner.viewIfLoaded?.window, owner.presentedViewController == nil,
              !alertWindows.values.contains(ObjectIdentifier(window)) else {
            runner.dismissFailure()
            return
        }
        let id = runner.id
        let alert = UIAlertController(title: "네트워크에 연결되어 있지 않습니다", message: "인터넷 설정을 확인해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self, weak runner] _ in
            self?.alerts.removeValue(forKey: id)
            self?.alertWindows.removeValue(forKey: id)
            runner?.dismissFailure()
        })
        alerts[id] = alert
        alertWindows[id] = ObjectIdentifier(window)
        updateOverlays()
        owner.present(alert, animated: true)
    }

    func bind(_ runner: RequestRunner, to owner: UIViewController) -> AnyCancellable {
        let id = runner.id
        let subscription = runner.state.sink { [weak self, weak owner, weak runner] state in
            guard let self, let owner, let runner else { return }
            render(state, runner: runner, owner: owner)
        }
        return AnyCancellable { [weak self] in
            subscription.cancel()
            Task { @MainActor in self?.remove(id: id) }
        }
    }

    func remove(id: UUID) {
        entries.removeValue(forKey: id)?.button?.isRequestInProgress = false
        alerts.removeValue(forKey: id)?.dismiss(animated: false)
        alertWindows.removeValue(forKey: id)
        updateOverlays()
    }
}
