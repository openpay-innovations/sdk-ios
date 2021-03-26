//
//  CreateOrderResponse.swift
//  Example
//
//  Created by june chen on 15/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

struct CreateOrderResponse: Decodable {
    let orderId: String
    let transactionToken: String
    let handoverURL: URL
}
