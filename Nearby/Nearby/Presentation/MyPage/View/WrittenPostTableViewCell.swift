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

    private let profileAvatarCount = 4
    private var keywords: [String] = []
    private var keywordCollectionHeightConstraint: Constraint?

    // MARK: - UI Components

    private let cityNameLabel = UILabel()

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
    private let overflowCountLabel = UILabel()
    private let peopleStatusLabel = UILabel()
    private let peopleSpacerView = UIView()

    private let contentContainerView = UIView()
    private let contentLabel = UILabel()

    private lazy var keywordCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeKeywordLayout()
    )

    private let dividerView = UIView()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setUI()
        setLayout()
        setCollectionView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        cityNameLabel.text = nil
        placeLabel.text = nil
        dateLabel.text = nil
        peopleStatusLabel.text = nil
        overflowCountLabel.text = nil
        overflowCountLabel.isHidden = true
        contentLabel.text = nil

        keywords = []
        keywordCollectionView.reloadData()
        keywordCollectionHeightConstraint?.update(offset: 0)
    }

    // MARK: - Methods

    func configure(with item: WrittenPostItem) {
        cityNameLabel.text = "바르셀로나"

        placeLabel.text = item.placeName
        dateLabel.text = item.meetingDateText

        peopleStatusLabel.text =
            "\(item.currentPeopleCount)/\(item.maximumPeopleCount)명"

        contentLabel.text = item.content

        peopleImageStackView.configure(
            withImageURLs: Array(
                item.participantImageURLs.prefix(profileAvatarCount)
            )
        )
        configureOverflowCount(item.currentPeopleCount)

        if let latitude = item.latitude, let longitude = item.longitude {
            mapCardView.isHidden = false
            mapCardView.snp.updateConstraints { $0.height.equalTo(211) }
            mapCardView.configure(
                latitude: latitude,
                longitude: longitude,
                placeName: item.placeName,
                placeID: item.placeID,
                zoomLevel: 16,
                showsInfoWindow: false
            )
        } else {
            mapCardView.isHidden = true
            mapCardView.snp.updateConstraints { $0.height.equalTo(0) }
        }

        configureKeywords(item.keywords)
    }
}

// MARK: - Custom Methods

private extension WrittenPostTableViewCell {

    func setStyle() {
        selectionStyle = .none

        backgroundColor = .white
        contentView.backgroundColor = .white

        cityNameLabel.do {
            $0.font = NearbyFont.h3M20.font
            $0.textColor = .grey80
            $0.numberOfLines = 1

            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
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

        overflowCountLabel.do {
            $0.setFont(.b2M16, textColor: .grey40)
            $0.isHidden = true
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        peopleStatusLabel.do {
            $0.font = NearbyFont.b2M16.font
            $0.textColor = .grey80
            $0.numberOfLines = 1
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
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

        keywordCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }

        dividerView.do {
            $0.backgroundColor = .grey5
        }
    }

    func setUI() {
        contentView.addSubviews(
            cityNameLabel, mapCardView, informationStackView,
            contentContainerView, keywordCollectionView, dividerView
        )

        placeStackView.addArrangedSubviews(placeIconImageView, placeLabel)

        dateStackView.addArrangedSubviews(dateIconImageView, dateLabel)

        peopleStackView.addArrangedSubviews(
            peopleIconImageView,
            peopleImageStackView,
            overflowCountLabel,
            peopleStatusLabel,
            peopleSpacerView
        )

        informationStackView.addArrangedSubviews(
            placeStackView, dateStackView, peopleStackView
        )

        contentContainerView.addSubview(contentLabel)
    }

    func setLayout() {
        cityNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        mapCardView.snp.makeConstraints {
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(24)

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

        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentContainerView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            keywordCollectionHeightConstraint = $0.height.equalTo(0).constraint
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(keywordCollectionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }

    func configureKeywords(_ keywords: [String]) {
        self.keywords = keywords
        keywordCollectionView.reloadData()
        keywordCollectionView.collectionViewLayout.invalidateLayout()

        contentView.layoutIfNeeded()
        keywordCollectionView.layoutIfNeeded()

        let contentHeight = keywordCollectionView.collectionViewLayout
            .collectionViewContentSize.height
        keywordCollectionHeightConstraint?.update(offset: contentHeight)
    }

    func configureOverflowCount(_ participantCount: Int) {
        let overflowCount = max(participantCount - profileAvatarCount, 0)
        overflowCountLabel.text = overflowCount > 0 ? "+\(overflowCount)" : nil
        overflowCountLabel.isHidden = overflowCount == 0

        peopleStackView.setCustomSpacing(
            overflowCount > 0 ? 0 : 6,
            after: peopleImageStackView
        )
        peopleStackView.setCustomSpacing(6, after: overflowCountLabel)
    }

    func makeKeywordLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }

    func setCollectionView() {
        keywordCollectionView.dataSource = self
        keywordCollectionView.delegate = self
        keywordCollectionView.register(
            WrittenPostKeywordCell.self,
            forCellWithReuseIdentifier: WrittenPostKeywordCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource

extension WrittenPostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keywords.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WrittenPostKeywordCell.identifier,
            for: indexPath
        ) as? WrittenPostKeywordCell else {
            return UICollectionViewCell()
        }

        cell.configure(title: keywords[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WrittenPostTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = keywords[indexPath.item]
        let titleWidth = (title as NSString).size(
            withAttributes: [.font: NearbyFont.b3M14.font]
        ).width
        let availableWidth = collectionView.bounds.width

        return CGSize(
            width: min(ceil(titleWidth + 32), availableWidth),
            height: 36
        )
    }
}
