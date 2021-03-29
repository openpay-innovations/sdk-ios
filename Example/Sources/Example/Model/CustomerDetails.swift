//
//  CustomerDetails.swift
//  Example
//
//  Created by june chen on 10/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

struct CustomerDetails {
    var firstName: String
    var familyName: String
    var email: String
    var street: String
    var suburb: String
    var state: String
    var postcode: String

    static func `default`() -> Self {
        return CustomerDetails(
            firstName: "John",
            familyName: "Smith",
            email: "AppTestUser@xx.yy",
            street: "100 Bourke Street",
            suburb: "Melbourne",
            state: "VIC",
            postcode: "3000"
        )
    }
}
