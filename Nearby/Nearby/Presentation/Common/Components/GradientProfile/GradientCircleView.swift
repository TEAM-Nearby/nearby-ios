//
//  GradientCircleView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class GradientCircleView: BaseView {

    // MARK: - Properties

    private let diameter: CGFloat
    private let borderWidth: CGFloat = 2
    private let gap: CGFloat = 2

    // MARK: - UI Components

    private let gradientLayer = NearbyGradient.profileBorderLayer(frame: .zero)
    private let whiteCircleView = UIView()
    private let innerCircleView = UIView()
    private let imageView = UIImageView()

    // MARK: - Initializer

    init(diameter: CGFloat = 100) {
        self.diameter = diameter
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = diameter / 2
        layer.cornerRadius = diameter / 2

        let whiteRadius = (diameter - borderWidth * 2) / 2
        whiteCircleView.layer.cornerRadius = whiteRadius

        let innerRadius = (diameter - (borderWidth + gap) * 2) / 2
        innerCircleView.layer.cornerRadius = innerRadius
        imageView.layer.cornerRadius = innerRadius
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear

        whiteCircleView.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
        }

        innerCircleView.do {
            $0.backgroundColor = .primary10
            $0.clipsToBounds = true
        }

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }

    override func setUI() {
        layer.addSublayer(gradientLayer)
        addSubview(whiteCircleView)
        whiteCircleView.addSubview(innerCircleView)
        innerCircleView.addSubview(imageView)
    }

    override func setLayout() {
        snp.makeConstraints {
            $0.size.equalTo(diameter)
        }

        whiteCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(borderWidth)
        }

        innerCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(gap)
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Method

    // TODO: - Kinfisher 사용
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
