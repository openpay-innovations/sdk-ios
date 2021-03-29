//
//  UIColor+Example.swift
//  Example
//
//  Created by june chen on 9/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

extension UIColor {
    static var aussieAmber: UIColor {
        UIColor(named: "aussieAmber", in: bundle, compatibleWith: nil)!
    }

    static var graniteGrey: UIColor {
        UIColor(named: "graniteGrey", in: bundle, compatibleWith: nil)!
    }

    static var overlayGrey: UIColor {
        UIColor(named: "overlayGrey", in: bundle, compatibleWith: nil)!
    }
}

private class BundleTag {}

private let bundle = Bundle(for: BundleTag.self)
