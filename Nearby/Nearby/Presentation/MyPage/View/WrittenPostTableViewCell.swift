//
//  WrittenPostTableViewCell.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class WrittenPostTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = String(describing: WrittenPostTableViewCell.self)

    private let profileAvatarCount = 3

    // MARK: - UI Components

    private let cityInformationStackView = UIStackView()
    private let cityNameLabel = UILabel()
    private let createdDateLabel = UILabel()

    private let mapCardView = NearbyMapView(cornerRadius: 12)

    private let informationStackView = UIStackView()

    private let placeStackView = UIStackView()
    private let placeIconImageView = UIImageView()
    private let placeLabel = UILabel()

    private let dateStackView = UIStackView()
    private let dateIconImageView = UIImageView()
    private let dateLabel = UILabel()

    private let peopleStackView = UIStackView()
    private let peopleIconImageView = UIImageView()
    private let peopleImageStackView = AvatarStackView()
    private let peopleStatusLabel = UILabel()

    private let contentContainerView = UIView()
    private let contentLabel = UILabel()

    private let keywordStackView = UIStackView()

    private let dividerView = UIView()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setUI()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        cityNameLabel.text = nil
        createdDateLabel.text = nil
        placeLabel.text = nil
        dateLabel.text = nil
        peopleStatusLabel.text = nil
        contentLabel.text = nil

        keywordStackView.arrangedSubviews.forEach {
            keywordStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    // MARK: - Methods

    func configure(with item: WrittenPostItem) {
        cityNameLabel.text = item.cityName
        createdDateLabel.text = item.createdDateText

        placeLabel.text = item.placeName
        dateLabel.text = item.meetingDateText

        peopleStatusLabel.text =
            "\(item.currentPeopleCount)/\(item.maximumPeopleCount)명"

        contentLabel.text = item.content

        peopleImageStackView.configureWithDefaultAvatars(
            count: min(
                item.currentPeopleCount,
                profileAvatarCount
            )
        )

        mapCardView.configure(
            latitude: item.latitude,
            longitude: item.longitude,
            placeName: item.placeName,
            placeID: item.placeID,
            zoomLevel: 16,
            showsInfoWindow: false
        )

        configureKeywords(item.keywords)
    }
}

// MARK: - Custom Methods

private extension WrittenPostTableViewCell {

    func setStyle() {
        selectionStyle = .none

        backgroundColor = .white
        contentView.backgroundColor = .white

        cityInformationStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 12
        }

        cityNameLabel.do {
            $0.font = NearbyFont.h3M20.font
            $0.textColor = .grey80
            $0.numberOfLines = 1

            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        createdDateLabel.do {
            $0.font = NearbyFont.b1M18.font
            $0.textColor = .grey30
            $0.numberOfLines = 1
        }

        informationStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 11
        }

        [placeStackView, dateStackView, peopleStackView].forEach {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 12
        }

        placeIconImageView.do {
            $0.image = .smallLocationIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
            $0.contentMode = .scaleAspectFit
        }

        placeLabel.do {
            $0.font = NearbyFont.b2M16.font
            $0.textColor = .grey80
            $0.numberOfLines = 1
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }

        dateIconImageView.do {
            $0.image = .calenderIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
            $0.contentMode = .scaleAspectFit
        }

        dateLabel.do {
            $0.font = NearbyFont.b2M16.font
            $0.textColor = .grey80
            $0.numberOfLines = 1
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }

        peopleIconImageView.do {
            $0.image = .peopleIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
            $0.contentMode = .scaleAspectFit
        }

        peopleStatusLabel.do {
            $0.font = NearbyFont.b2M16.font
            $0.textColor = .grey80
            $0.numberOfLines = 1
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }

        contentContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        contentLabel.do {
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey60
            $0.numberOfLines = 0
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }

        keywordStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 8
        }

        dividerView.do {
            $0.backgroundColor = .grey5
        }
    }

    func setUI() {
        contentView.addSubviews(
            cityInformationStackView, mapCardView, informationStackView,
            contentContainerView, keywordStackView, dividerView
        )

        cityInformationStackView.addArrangedSubviews(cityNameLabel, createdDateLabel)

        placeStackView.addArrangedSubviews(placeIconImageView, placeLabel)

        dateStackView.addArrangedSubviews(dateIconImageView, dateLabel)

        peopleStackView.addArrangedSubviews(
            peopleIconImageView, peopleImageStackView, peopleStatusLabel
        )

        informationStackView.addArrangedSubviews(
            placeStackView, dateStackView, peopleStackView
        )

        contentContainerView.addSubview(contentLabel)
    }

    func setLayout() {
        cityInformationStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        mapCardView.snp.makeConstraints {
            $0.top.equalTo(cityInformationStackView.snp.bottom).offset(24)

            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(211)
        }

        placeIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        dateIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        peopleIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        informationStackView.snp.makeConstraints {
            $0.top.equalTo(mapCardView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(informationStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        keywordStackView.snp.makeConstraints {
            $0.top.equalTo(contentContainerView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.height.equalTo(36)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(keywordStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }

    func configureKeywords(_ keywords: [String]) {
        keywordStackView.arrangedSubviews.forEach {
            keywordStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        keywords.prefix(3).forEach { keyword in
            let keywordChip = makeKeywordChip(title: keyword)
            keywordStackView.addArrangedSubview(keywordChip)
        }
    }

    func makeKeywordChip(title: String) -> UIView {
        let containerView = UIView()
        let titleLabel = UILabel()

        containerView.do {
            $0.backgroundColor = UIColor.primary50.withAlphaComponent(0.10)
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.font = NearbyFont.b3M14.font
            $0.text = title
            $0.textColor = .primary50
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }

        containerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        containerView.snp.makeConstraints {
            $0.height.equalTo(36)
        }

        return containerView
    }
}
