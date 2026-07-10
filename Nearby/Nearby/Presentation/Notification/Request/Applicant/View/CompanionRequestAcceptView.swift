//
//  CompanionRequestAcceptView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class CompanionRequestAcceptView: BaseView {
    
    // MARK: - Properties
    
    var onConfirmButtonDidTap: (() -> Void)?
    var onEnterChatButtonDidTap: (() -> Void)?
    var onChatHelpButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let matchedContainer = UIView()
    private let matchedProfileView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let informationView = UIStackView()
    
    private let locationStackView = UIStackView()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let calendarImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let peopleStackView = UIStackView()
    private let peopleImageView = UIImageView()
    private let avatarStackView = UIStackView()
    private let peopleLabel = UILabel()
    
    private let checkListView = UIStackView()
    private let checkListTitleLabel = UILabel()
    private let checkListDescriptionLabel = UILabel()
    
    private let chatContainer = UIView()
    private let chatProfileView = UIView()
    private let chatImageView = UIImageView()
    private let chatTitleLabel = UILabel()
    
    private let chatCardView = UIStackView()
    private let chatDescriptionLabel = UILabel()
    private let enterChatButton = UIButton(type: .system)
    private let chatHelpButton = UIButton(type: .system)
    
    private let confirmButton = NearbyButton(style: .primary, title: "")
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if chatContainer.transform == .identity && matchedContainer.transform == .identity {
            chatContainer.transform = CGAffineTransform(translationX: bounds.width, y: 0)
        }
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
        }
        
        informationView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 10
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        }
        
        locationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        locationImageView.do {
            $0.image = .smallLocationIcon
        }
        
        locationLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        calendarImageView.do {
            $0.image = .calenderIcon
        }
        
        dateLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        peopleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        peopleImageView.do {
            $0.image = .peopleIcon
        }
        
        peopleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        avatarStackView.do {
            $0.axis = .horizontal
            $0.spacing = -6
            $0.alignment = .center
        }
        
        checkListView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 17
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        }
        
        checkListTitleLabel.do {
            $0.setFont(.b2M16, text: "안전 체크리스트", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        checkListDescriptionLabel.do {
            $0.setFont(.b3M14, text:
            """
            1. 숙소 정보는 공유하지 마세요.
            2. 오픈채팅을 제외한 개인 연락처를 강요하거나 반복적으로 요구하지 마세요.
            3. 사람이 많은 곳에서 처음 만나세요.
            4.금전 거래를 요구하는 경우 동행을 중단해주세요.
            5. 불쾌한 언행이나 위험을 느낄 시 즉시 대화와 동행을 종료하고 신고 기능을 이용해주세요.
            6.가족이나 친구에게 일정을 미리 공유하세요.
            """, textColor: .grey40)
            $0.numberOfLines = 8
        }
        
        chatImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        chatTitleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
        }
        
        chatCardView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 28
            $0.alignment = .center
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 32, left: 20, bottom: 32, right: 20)
        }
        
        chatDescriptionLabel.do {
            $0.setFont(.b2M16, text: "(호스트)님이 만남 약속을 위한 오픈채팅방을 열어뒀어요. 입장해서 인사를 나눠보세요!", textColor: .grey60)
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }
        
        enterChatButton.do {
            $0.setTitle("카카오톡 오픈채팅 입장하기", for: .normal)
            $0.titleLabel?.font = NearbyFont.b1M18.font
            $0.setTitleColor(.primary50, for: .normal)
            $0.backgroundColor = .btnChatBg
            $0.layer.cornerRadius = 16
        }
        
        chatHelpButton.do {
            $0.setTitle("오픈채팅이 열리지 않는다면?", for: .normal)
            $0.titleLabel?.font = NearbyFont.b3M14.font
            $0.setTitleColor(.grey50, for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews( matchedContainer, chatContainer, confirmButton)
        
        matchedContainer.addSubviews(matchedProfileView, informationView, checkListView)
        matchedProfileView.addSubviews(imageView, titleLabel)
        informationView.addArrangedSubviews(locationStackView, dateStackView, peopleStackView)
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        dateStackView.addArrangedSubviews(calendarImageView, dateLabel)
        
        (0..<3).forEach { _ in
            let avatar = UIImageView().then {
                $0.image = .avatarStack
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 8
                $0.clipsToBounds = true
                $0.snp.makeConstraints { make in
                    make.size.equalTo(16)
                }
            }
            avatarStackView.addArrangedSubview(avatar)
        }
        
        peopleStackView.addArrangedSubviews(peopleImageView, avatarStackView, peopleLabel)
        peopleStackView.setCustomSpacing(6, after: avatarStackView)
        checkListView.addArrangedSubviews(checkListTitleLabel, checkListDescriptionLabel)
        
        chatContainer.addSubviews(chatProfileView, chatCardView)
        chatProfileView.addSubviews(chatImageView, chatTitleLabel)
        chatCardView.addArrangedSubviews(chatDescriptionLabel, enterChatButton, chatHelpButton)
        chatCardView.setCustomSpacing(12, after: enterChatButton)
    }
    
    override func setLayout() {
        matchedContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }
        
        chatContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top)
        }
        
        matchedProfileView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(74)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        informationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        locationImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        peopleImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        checkListView.snp.makeConstraints {
            $0.top.equalTo(informationView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        chatProfileView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(176)
        }
        
        chatImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        chatTitleLabel.snp.makeConstraints {
            $0.top.equalTo(chatImageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        chatCardView.snp.makeConstraints {
            $0.top.equalTo(chatTitleLabel.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        enterChatButton.snp.makeConstraints {
            $0.width.equalTo(252)
            $0.height.equalTo(45)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        enterChatButton.addTarget(self, action: #selector(enterChatButtonDidTap), for: .touchUpInside)
        chatHelpButton.addTarget(self, action: #selector(chatHelpButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    func configure(with output: CompanionRequestAcceptViewModel.DisplayData) {
        imageView.image = output.image
        titleLabel.text = output.title
        locationLabel.text = output.location
        dateLabel.text = output.date
        peopleLabel.text = output.people
        chatImageView.image = output.image
        chatTitleLabel.text = output.title
        confirmButton.setTitle(output.buttonTitle, for: .normal)
    }
    
    func updateStep(_ step: CompanionRequestAcceptViewModel.Step) {
        let width = bounds.width
        let isChat = step == .chat
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut) {
            if isChat {
                self.matchedContainer.transform = CGAffineTransform(translationX: -width, y: 0)
                self.chatContainer.transform = .identity
            } else {
                self.matchedContainer.transform = .identity
                self.chatContainer.transform = CGAffineTransform(translationX: width, y: 0)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func confirmButtonDidTap() {
        onConfirmButtonDidTap?()
    }
    
    @objc
    private func enterChatButtonDidTap() {
        onEnterChatButtonDidTap?()
    }
    
    @objc
    private func chatHelpButtonDidTap() {
        onChatHelpButtonDidTap?()
    }
}
