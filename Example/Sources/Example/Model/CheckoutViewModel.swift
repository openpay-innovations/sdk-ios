//
//  CheckoutViewModel.swift
//  Example
//
//  Created by june chen on 15/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

enum LocationState: String, CaseIterable {
    case victoria = "VIC"
    case newSouthWales = "NSW"
    case australianCapitalTerritory = "ACT"
    case northernTerritory = "NT"
    case queensland = "QLD"
    case tasmania = "TAS"
    case southAustralia = "SA"
    case westernAustralia = "WA"
}

final class CheckoutViewModel {

    enum CheckoutError: Error {
        case mockResponseMissing
    }

    private let paymentRepo: PaymentRepoType
    private var orderId: String?
    private let totalAmount: Decimal = 50.00

    // Output

    let programmingLanguage: ProgrammingLanguage = .swift

    var totalAmountDisplayValue: String {
        let formatter = CurrencyFormatter()
        return formatter.string(from: totalAmount)
    }

    var isValid: Bool {
        customerDetails.isValid
    }

    var customerDetails = CustomerDetails.default()

    let states = LocationState.allCases

    init(paymentRepo: PaymentRepoType) {
        self.paymentRepo = paymentRepo
    }

    func checkout(successHandler: @escaping (_ transactionToken: String, _ handoverURL: URL) -> Void, errorHandler: @escaping (Error) -> Void) {

        guard !createOrderResponse.transactionToken.isEmpty, !createOrderResponse.orderId.isEmpty else {
            errorHandler(CheckoutError.mockResponseMissing)
            return
        }

        let formatter = CurrencyFormatter()
        let integerAmount = formatter.fractionalMonetaryUnit(from: totalAmount, currencyCode: "AUD")
        // Merchant Server Call
        paymentRepo.createNewOrder(purchasePrice: integerAmount, customerDetails: customerDetails) { [weak self] result in
            switch result {
            case .success(let response):
                self?.orderId = response.orderId
                successHandler(response.transactionToken, response.handoverURL)
            case .failure(let error):
                errorHandler(error)
            }
        }
    }

    func makePayment(successHandler: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let orderId = orderId else {
            return
        }
        // Merchant Server Call
        paymentRepo.capturePayment(orderId: orderId) { result in
            switch result {
            case .success:
                successHandler()
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}

private extension CustomerDetails {
    var isValid: Bool {
        [firstName, familyName, email, street, suburb, postcode, state]
        .allSatisfy { item -> Bool in
            !item.isEmpty
        }
    }
}
