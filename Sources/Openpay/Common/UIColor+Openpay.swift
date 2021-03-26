//
//  UIColor+Openpay.swift
//  Openpay
//
//  Created by june chen on 18/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let bundle = OPBundleLocator.resourcesBundle

    static var aussieAmber: UIColor {
        UIColor(named: "aussieAmber", in: bundle, compatibleWith: nil)!
    }

    static var graniteGrey: UIColor {
        UIColor(named: "graniteGrey", in: bundle, compatibleWith: nil)!
    }
}
