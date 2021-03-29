//
//  Configuration.swift
//  Example
//
//  Created by june chen on 12/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

/// Insert your order Id, transaction token and handover URL to see the web checkout view.
let createOrderResponse = CreateOrderResponse(
    orderId: "",
    transactionToken: "",
    handoverURL: URL(string: "https://example.com/")!
)

/// Insert your order Id and purchase price to capture the payment after the web checkout view returns success.
let capturePaymentResponse = CapturePaymentResponse(orderId: "", purchasePrice: 0)
