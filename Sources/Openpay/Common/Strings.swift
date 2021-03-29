//
//  Strings.swift
//  Openpay
//
//  Created by june chen on 3/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

// swiftlint:disable convenience_type
class Strings {
    static let bundle = OPBundleLocator.resourcesBundle

    static var errorTitle: String {
        NSLocalizedString("errorTitle", bundle: bundle, comment: "")
    }

    static var actionRetry: String {
        NSLocalizedString("actionRetry", bundle: bundle, comment: "")
    }

    static var actionCancel: String {
        NSLocalizedString("actionCancel", bundle: bundle, comment: "")
    }

    static var actionYes: String {
        NSLocalizedString("actionYes", bundle: bundle, comment: "")
    }

    static var actionNo: String {
        NSLocalizedString("actionNo", bundle: bundle, comment: "")
    }

    static var dismissCheckoutViewConfirmationTitle: String {
        NSLocalizedString("dismissCheckoutViewConfirmationTitle", bundle: bundle, comment: "")
    }

    static var loadCheckoutViewFailedMessage: String {
        NSLocalizedString("loadCheckoutViewFailedMessage", bundle: bundle, comment: "")
    }

    static var fatalErrorInitCoderNotImplemented: String {
        NSLocalizedString("fatalErrorInitCoderNotImplemented", bundle: bundle, comment: "")
    }

    static var paymentButtonAccessibilityLabel: String {
        NSLocalizedString("paymentButtonAccessibilityLabel", bundle: bundle, comment: "")
    }

    static var badgeAccessibilityLabel: String {
        NSLocalizedString("badgeAccessibilityLabel", bundle: bundle, comment: "")
    }
}
