//
//  CurrencyFormatter.swift
//  Example
//
//  Created by june chen on 18/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

struct CurrencyFormatter {
    private static let formatter = NumberFormatter()

    /// Returns a string representation of a given decimal formatted using a given currency code. It will produce a string containing the currency symbol of the given currency code if the given currency code is the same as the user's region's currency. Otherwise it will produce a string containing the corresponding ISO 4217 currency code.
    ///
    /// For example, the number 15.22 is represented as $15.22 if both the given currency code and the user's region's currency code is AUD. If the user's region's currency code is different, it uses the corresponding ISO 4217 currency code so the number is represented as AUD 15.22.
    ///
    /// - Parameters:
    ///   - decimal: The decimal to format
    ///   - currencyCode: The code of the currency whose format you want
    func string(from decimal: Decimal, currencyCode: String? = nil) -> String {
        let formatter = Self.formatter
        guard let currencyCode = currencyCode else {
            formatter.numberStyle = .currency
            return formatter.string(from: decimal as NSDecimalNumber)!
        }

        formatter.currencyCode = currencyCode
        formatter.numberStyle = Locale.current.currencyCode == currencyCode ? .currency : .currencyISOCode
        return formatter.string(from: decimal as NSDecimalNumber)!
    }

    /// Returns an integer value in the lowest denomination of a given currency code for the provided decimal.
    ///
    /// For example, the decimal 15.22 is converted to 1522 when the given currency code is `AUD`.
    ///
    /// - Parameters:
    ///   - decimal: The decimal to format
    ///   - currencyCode: The code of the currency that indicates the lowest denomination you want
    func fractionalMonetaryUnit(from decimal: Decimal, currencyCode: String? = nil) -> Int {
        let code = currencyCode ?? Locale.current.currencyCode
        let decimalPlaces: Int
        switch code {
        case "AUD", "GBP":
            decimalPlaces = 2
        default:
            fatalError("Please provide the decimal places of the given currency code \(String(describing: code)).")
        }
        let integer = NSDecimalNumber(decimal: decimal * pow(10, decimalPlaces))
        return Int(truncating: integer)
    }
}
