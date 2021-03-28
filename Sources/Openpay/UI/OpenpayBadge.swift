//
//  OpenpayBadge.swift
//  Openpay
//
//  Created by june chen on 19/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

public final class OpenpayBadge: UIView {

    public enum ColorScheme: OpenpayColorScheme {
        case graniteOnAmber
        case amberOnGranite
        case white
        case granite
    }

    struct BadgeImage {
        let image: UIImage
        let minimumWidth: CGFloat

        var aspectRatio: CGFloat {
            image.size.height / image.size.width
        }
    }

    private let badgeImageView = UIImageView()
    private var widthConstraint: NSLayoutConstraint!
    private var aspectRatioConstraint: NSLayoutConstraint!

    private var badgeImage: BadgeImage {
        switch colorScheme {
        case .graniteOnAmber:
            return BadgeImage(image: UIImage.opImage("badge_graniteOnAmber"), minimumWidth: 75)
        case .amberOnGranite:
            return BadgeImage(image: UIImage.opImage("badge_amberOnGranite"), minimumWidth: 75)
        case .white:
            let image = UIImage.opImage("badge_logo").withTintColor(.white)
            return BadgeImage(image: image, minimumWidth: 80)
        case .granite:
            let image = UIImage.opImage("badge_logo").withTintColor(.graniteGrey)
            return BadgeImage(image: image, minimumWidth: 80)
        }
    }

    /// The default theme is OpenpayTheme.universal(.graniteOnAmber).
    /// Different themes correspond to different badge images.
    public var theme: OpenpayTheme<ColorScheme> = .universal(.graniteOnAmber) {
        didSet {
            updateBadgeView(badgeImage)
        }
    }

    public var colorScheme: ColorScheme {
        theme.colorScheme(with: traitCollection)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    /// Initializes a badge view
    /// - Parameter theme: The default theme uses a static background image for light and dark modes.
    public init(theme: OpenpayTheme<ColorScheme> = .universal(.graniteOnAmber)) {
        self.theme = theme
        super.init(frame: .zero)
        commonInit()
    }

    private func commonInit() {
        let badge = badgeImage
        badgeImageView.image = badge.image

        widthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: badge.minimumWidth)
        aspectRatioConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: badge.aspectRatio)

        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeImageView)
        NSLayoutConstraint.activate([
            aspectRatioConstraint,
            widthConstraint,
            badgeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            badgeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            badgeImageView.topAnchor.constraint(equalTo: topAnchor),
            badgeImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        configAccessibility()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBadgeView(badgeImage)
    }

    private func updateBadgeView(_ badge: BadgeImage) {
        badgeImageView.image = badge.image
        widthConstraint.constant = badge.minimumWidth
        aspectRatioConstraint.isActive = false
        aspectRatioConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: badge.aspectRatio)
        aspectRatioConstraint.isActive = true
    }

    private func configAccessibility() {
        accessibilityTraits = [.image]
        isAccessibilityElement = true
        accessibilityLabel = Strings.badgeAccessibilityLabel
    }
}