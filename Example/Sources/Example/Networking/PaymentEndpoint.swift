//
//  PaymentEndpoint.swift
//  Example
//
//  Created by june chen on 12/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var body: Data? { get }
}

/// Merchant Server Endpoint
enum PaymentEndpoint: Endpoint {
    case createNewOrder(purchasePrice: Int, customerDetails: CustomerDetails)
    case capturePayment(orderId: String)

    var path: String {
        switch self {
        case .createNewOrder:
            return "/orders"
        case .capturePayment(let orderId):
            return "/orders/\(orderId)/capture"
        }
    }

    var method: String {
        switch self {
        case .createNewOrder, .capturePayment:
            return "POST"
        }
    }

    var body: Data? {
        switch self {
        case .createNewOrder(let purchasePrice, let customerDetails):
            let request = CreateOrderRequest.make(purchasePrice: purchasePrice, customerDetails: customerDetails)
            return try? JSONEncoder().encode(request)
        default:
            return nil
        }
    }
}
