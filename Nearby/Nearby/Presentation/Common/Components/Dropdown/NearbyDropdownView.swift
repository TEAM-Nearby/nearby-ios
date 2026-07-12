//
//  NearbyDropdownView.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import UIKit

import SnapKit
import Then

final class NearbyDropdownView: BaseView {
    
    // MARK: - Properties
    
    private let items: [String]
    private var selectedItem: String
    private var isExpanded = false
    
    var onItemSelected: ((String) -> Void)?
    
    // MARK: - UI Components
    
    private let selectButton = UIButton()
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let menuContainerView = UIView()
    private let tableView = UITableView()
    
    // MARK: - Initializer
    
    init(items: [String], selectedItem: String) {
        self.items = items
        self.selectedItem = selectedItem
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        menuContainerView.layer.shadowPath = UIBezierPath(roundedRect: menuContainerView.bounds, cornerRadius: menuContainerView.layer.cornerRadius).cgPath
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event) || (isExpanded && menuContainerView.frame.contains(point))
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        clipsToBounds = false
        
        selectButton.do {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.chipBorderGrey.cgColor
            $0.layer.cornerRadius = 16
        }
        
        titleLabel.do {
            $0.setFont(.b3Sb14, text: selectedItem, textColor: .grey70)
        }
        
        arrowImageView.do {
            $0.image = .chevronDownIcon
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .grey80
        }
        
        menuContainerView.do {
            $0.alpha = 0
            $0.isHidden = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 8
        }
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.separatorColor = .grey5
            $0.separatorInset = .zero
            $0.rowHeight = 40
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.register(NearbyDropdownCell.self)
        }
    }
    
    override func setUI() {
        addSubviews(selectButton, menuContainerView)
        selectButton.addSubviews(titleLabel, arrowImageView)
        menuContainerView.addSubview(tableView)
    }
    
    override func setLayout() {
        snp.makeConstraints {
            $0.width.equalTo(89)
            $0.height.equalTo(32)
        }
        
        selectButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(16)
        }
        
        menuContainerView.snp.makeConstraints {
            $0.top.equalTo(selectButton.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.width.equalTo(114)
            $0.height.equalTo(items.count * 40)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setAddTarget() {
        selectButton.addAction(UIAction { [weak self] _ in
            self?.setExpanded(!(self?.isExpanded ?? false), animated: true)
        }, for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    private func setExpanded(_ isExpanded: Bool, animated: Bool) {
        self.isExpanded = isExpanded
        menuContainerView.isHidden = false
        
        let changes = {
            self.menuContainerView.alpha = isExpanded ? 1 : 0
            self.arrowImageView.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        
        let completion: (Bool) -> Void = { [weak self] _ in
            self?.menuContainerView.isHidden = !isExpanded
        }
        
        guard animated else {
            changes()
            completion(true)
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: changes, completion: completion)
    }
    
    func updateSelectedItem(_ item: String) {
        guard items.contains(item) else { return }
        selectedItem = item
        titleLabel.text = item
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension NearbyDropdownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NearbyDropdownCell.self, for: indexPath)
        let item = items[indexPath.row]
        cell.configure(title: item, isSelected: item == selectedItem)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NearbyDropdownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        updateSelectedItem(item)
        onItemSelected?(item)
        setExpanded(false, animated: true)
    }
}
