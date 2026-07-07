//
//  BaseViewController.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import Combine
import UIKit

class BaseViewController<VM: BaseViewModelType>: UIViewController {
    
    // MARK: - Properties
    
    private(set) var viewModel: VM
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        setAddTarget()
        setDelegate()
        bindAction()
        bindState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLogger.lifecycle("viewWillAppear 호출 - \(type(of: self))")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppLogger.lifecycle("viewDidAppear 호출 - \(type(of: self))")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppLogger.lifecycle("viewWillDisappear 호출 - \(type(of: self))")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppLogger.lifecycle("viewDidDisappear 호출 - \(type(of: self))")
    }

    // MARK: - Custom Methods
    
    func setUI() {}
    func setLayout() {}
    func setAddTarget() {}
    func setDelegate() {}
    func bindAction() {}
    func bindState() {}
}
