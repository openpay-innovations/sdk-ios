//
//  Openpay.swift
//  Openpay
//
//  Created by june chen on 9/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

/// Present an Openpay Web Checkout View modally over the specified view controller and load the
/// checkout URL generated by the provided transaction token and handover URL.
/// - Parameters:
///   - viewController: The viewController on which `UIViewController.present` will be called.
///   The Openpay Checkout View Controller will be presented modally over this view controller
///   or the closest parent that is able to handle the presentation.
///   - transactionToken: The URL encoded token used to compose the checkout URL as a query parameter, generated via the /orders
///   endpoint on the Openpay backend. The token received from the backend is already URL encoded.
///   - handoverURL: The base URL used to compose the checkout URL,
///   generated via the /orders endpoint on the Openpay backend.
///   - animated: Pass true to animate the presentation; otherwise, pass false.
///   - completion: The block object to be executed when the checkout is completed.
public func presentWebCheckoutView(
    over viewController: UIViewController,
    transactionToken: String,
    handoverURL: URL,
    animated: Bool = true,
    completion: @escaping (_ result: WebCheckoutResult) -> Void
) {
    let checkoutVC = WebCheckoutViewController(
        transactionToken: transactionToken,
        handoverURL: handoverURL,
        completion: completion
    )
    viewController.present(checkoutVC, animated: animated, completion: nil)
}

private(set) var locale: OpenpayLocale = .australia

public func setLocale(_ locale: OpenpayLocale) {
    Openpay.locale = locale
}
