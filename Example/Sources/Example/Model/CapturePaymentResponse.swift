//
//  CapturePaymentResponse.swift
//  Example
//
//  Created by june chen on 17/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

struct CapturePaymentResponse: Decodable {
    let orderId: String
    let purchasePrice: Int
}
