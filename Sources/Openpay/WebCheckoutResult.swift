//
//  WebCheckoutResult.swift
//  Openpay
//
//  Created by june chen on 16/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

@frozen
public enum WebCheckoutResult {

    @frozen
    public enum Success {
        /// A success status, storing a planId and an orderId.
        ///
        /// If the plan creation type is `Instant`, the web view returns the status code `SUCCESS` when the plan is submitted successfully.
        case webSuccess(planId: String, orderId: String?)
        /// A lodged status, storing a planId and an orderId.
        ///
        /// If the plan creation type is `Pending`, the web view returns the status code `LODGED` when the plan is submitted successfully.
        case webLodged(planId: String, orderId: String?)
    }

    @frozen
    public enum Failure {
        /// A cancelled status, storing a planId and an orderId.
        ///
        /// The web view returns the status code `CANCELLED` when the plan submission is cancelled.
        case webCancelled(planId: String, orderId: String?)
        /// A failed status, storing a planId and an orderId.
        ///
        /// The web view returns the status code `FAILURE` when the plan submission fails.
        case webFailed(planId: String, orderId: String?)
        /// A status when the web view fails to load.
        case loadWebViewFailed(Error)
        /// A status when composing the checkout URL with the provided transaction token and handover URL fails.
        case invalidURL
        /// A status when the user dismisses the web view.
        case cancelled
    }

    case success(Success)
    case failure(Failure)
}
