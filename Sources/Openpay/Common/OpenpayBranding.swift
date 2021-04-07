//
//  OpenpayBranding.swift
//  Openpay
//
//  Created by june chen on 6/4/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

/// Keys that specify an Openpay branding which affects the style of the payment button and badges.
@frozen
public enum OpenpayBranding {
    // An AU or UK merchant should set the SDK branding to `openpay`
    // For more details about the `openpay` branding style see: /Support/Images/styleguide_openpay.pdf
    case openpay
    // A US merchant should set the SDK branding to `opy`
    // For more details about the `opy` branding style see: /Support/Images/styleguide_opy.pdf
    case opy
}
