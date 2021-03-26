//
//  OpenpayThemeTests.swift
//  OpenpayTests
//
//  Created by june chen on 19/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

@testable import Openpay
import XCTest

class OpenpayThemeTests: XCTestCase {

    func testPaymentButtonColor_universal() throws {
        let colorScheme: OpenpayPaymentButton.ColorScheme = .amberOnGranite
        let theme: OpenpayTheme = .universal(colorScheme)

        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        let darkTraitButtonColor = theme.colorScheme(with: darkTrait)

        XCTAssertEqual(darkTraitButtonColor, colorScheme)

        let lightTrait = UITraitCollection(userInterfaceStyle: .light)
        let lightTraitButtonColor = theme.colorScheme(with: lightTrait)

        XCTAssertEqual(lightTraitButtonColor, colorScheme)
    }

    func testPaymentButtonColor_dynamic() throws {
        let lightColorScheme: OpenpayPaymentButton.ColorScheme = .amberOnGranite
        let darkColorScheme: OpenpayPaymentButton.ColorScheme = .graniteOnAmber
        let theme: OpenpayTheme = .dynamic(light: lightColorScheme, dark: darkColorScheme)

        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        let darkTraitButtonColor = theme.colorScheme(with: darkTrait)

        XCTAssertEqual(darkTraitButtonColor, darkColorScheme)

        let lightTrait = UITraitCollection(userInterfaceStyle: .light)
        let lightTraitButtonColor = theme.colorScheme(with: lightTrait)

        XCTAssertEqual(lightTraitButtonColor, lightColorScheme)
    }
}
