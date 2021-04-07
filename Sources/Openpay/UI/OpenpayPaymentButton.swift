//
//  OpenpayPaymentButton.swift
//  Openpay
//
//  Created by june chen on 26/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

public final class OpenpayPaymentButton: UIButton {

    public enum ColorScheme: OpenpayColorScheme {
        case graniteOnAmber
        case amberOnGranite
        case whiteOnGranite
        case graniteOnWhite
    }

    private var logoImage: UIImage {
        switch locale {
        case .australia, .greatBritain:
            return UIImage.opImage("payWithOpenpay_logo")
        case .unitedStates:
            return UIImage.opImage("payWithOPY_logo")
        }
    }

    private let minimumWidth: CGFloat = 218
    private let maximumWidth: CGFloat = 380
    private let minimumHeight: CGFloat = 48

    private var buttonImage: (logo: UIImage, backgroundImage: UIImage) {
        let logoColor: UIColor
        let backgroundImage: UIImage
        switch colorScheme {
        case .graniteOnAmber:
            logoColor = .graniteGrey
            backgroundImage = .opImage("background_aussieAmber")
        case .amberOnGranite:
            logoColor = .aussieAmber
            backgroundImage = .opImage("background_graniteGrey")
        case .whiteOnGranite:
            logoColor = .white
            backgroundImage = .opImage("background_graniteGrey")
        case .graniteOnWhite:
            logoColor = .graniteGrey
            backgroundImage = .opImage("background_white")
        }

        return (logoImage.withTintColor(logoColor).withRenderingMode(.alwaysOriginal), backgroundImage)
    }

    /// The default theme is OpenpayTheme.universal(.graniteOnAmber).
    /// Different themes correspond to different payment background images.
    public var theme: OpenpayTheme<ColorScheme> = .universal(.graniteOnAmber) {
        didSet {
            updateButtonImage()
        }
    }

    public var colorScheme: ColorScheme {
        theme.colorScheme(with: traitCollection)
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: minimumWidth, height: minimumHeight)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    /// Initializes a payment button
    /// - Parameter theme: The default theme uses a static background image for light and dark modes.
    public init(theme: OpenpayTheme<ColorScheme> = .universal(.graniteOnAmber)) {
        self.theme = theme
        super.init(frame: .zero)
        commonInit()
    }

    private func commonInit() {
        adjustsImageWhenHighlighted = true
        adjustsImageWhenDisabled = true
        clipsToBounds = true
        layer.cornerRadius = 4

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWidth),
            widthAnchor.constraint(lessThanOrEqualToConstant: maximumWidth),
            heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight),
        ])

        accessibilityLabel = Strings.paymentButtonAccessibilityLabel

        updateButtonImage()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateButtonImage()
    }

    private func updateButtonImage() {
        setBackgroundImage(buttonImage.backgroundImage, for: .normal)
        setImage(buttonImage.logo, for: .normal)
    }
}
