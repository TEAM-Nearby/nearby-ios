//
//  Coordinator.swift
//  Nearby
//
//  Created by soomin on 7/3/26.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func start() {
        preconditionFailure("❌ override error")
    }
    
    func finish() {
        preconditionFailure("❌ override error")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        } else {
            print("❌ coordinator 삭제 실패: \(coordinator)")
        }
    }
}
