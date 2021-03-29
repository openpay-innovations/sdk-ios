//
//  UIImage+Openpay.swift
//  Openpay
//
//  Created by june chen on 1/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static let bundle = OPBundleLocator.resourcesBundle

    static func opImage(_ named: String) -> UIImage {
        return UIImage(named: named, in: bundle, compatibleWith: nil)!
    }
}
