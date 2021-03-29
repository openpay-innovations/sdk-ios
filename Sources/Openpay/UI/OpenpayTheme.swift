//
//  OpenpayTheme.swift
//  Openpay
//
//  Created by june chen on 15/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

public protocol OpenpayColorScheme {}

public enum OpenpayTheme<T: OpenpayColorScheme> {
    /// The universal theme uses a static color scheme and does not adapt to light and dark interfaces.
    case universal(T)
    /// The dynamic theme adapts to light and dark interfaces.
    case dynamic(light: T, dark: T)

    func colorScheme(with traitCollection: UITraitCollection) -> T {
        switch self {
        case .universal(let scheme):
            return scheme
        case .dynamic(let lightScheme, let darkScheme):
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightScheme
            case .dark:
                return darkScheme
            default:
                return lightScheme
            }
        }
    }
}
