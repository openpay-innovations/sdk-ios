//
//  CreateOrderRequest.swift
//  Example
//
//  Created by june chen on 15/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

struct CreateOrderRequest: Encodable {
    let customerJourney: CustomerJourney
    let purchasePrice: Int

    struct CustomerJourney: Encodable {
        enum Origin: String, Encodable {
            case online = "Online"
        }

        struct Online: Encodable {
            let callbackUrl: String
            let cancelUrl: String
            let failUrl: String
            let planCreationType: String
            let customerDetails: CustomerDetails
        }

        struct CustomerDetails: Encodable {
            let firstName: String
            let familyName: String
            let email: String
            let deliveryAddress: DeliveryAddress
        }

        struct DeliveryAddress: Encodable {
            let line1: String
            let suburb: String
            let state: String
            let postCode: String
        }

        let origin: Origin
        let online: Online
    }

    static func make(purchasePrice: Int, customerDetails: CustomerDetails) -> Self {
        let customerDetails = CustomerJourney.CustomerDetails(
            firstName: customerDetails.firstName,
            familyName: customerDetails.familyName,
            email: customerDetails.email,
            deliveryAddress: CustomerJourney.DeliveryAddress(
                line1: customerDetails.street,
                suburb: customerDetails.suburb,
                state: customerDetails.state,
                postCode: customerDetails.postcode
            )
        )
        let customerJourney = CustomerJourney(
            origin: .online,
            online: CustomerJourney.Online(
                callbackUrl: "https://example.com",
                cancelUrl: "https://example.com",
                failUrl: "https://example.com",
                planCreationType: "pending",
                customerDetails: customerDetails
            )
        )
        return CreateOrderRequest(customerJourney: customerJourney, purchasePrice: purchasePrice)
    }
}
