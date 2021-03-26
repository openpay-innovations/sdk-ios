//
//  SwiftUIViewModel.swift
//  Example
//
//  Created by june chen on 1/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import Openpay
import SwiftUI

final class SwiftUIViewModel: ObservableObject {
    struct Alert: Identifiable {
        var id = UUID()
        let title: String
        let subtitle: String
    }

    @Published var checkoutItem: CheckoutItem?
    @Published var alert: Alert?
    @Published var isLoading: Bool = false

    private let totalAmount: Decimal = 150.20
    private let paymentRepo: PaymentRepoType
    private var orderId: String?

    var totalAmountDisplayValue: String {
        let formatter = CurrencyFormatter()
        return formatter.string(from: totalAmount)
    }

    init(paymentRepo: PaymentRepoType) {
        self.paymentRepo = paymentRepo
    }

    func checkoutCompletion(_ result: WebCheckoutResult) {
        switch result {
        case .success(.webLodged(let planId, _)):
            alert = Alert(title: "The plan has been submitted successfully.", subtitle: "PlanID: \(planId)")
        default:
            alert = Alert(title: "The plan submission failed.", subtitle: "")
        }
    }

    func checkout() {
        let formatter = CurrencyFormatter()
        let integerAmount = formatter.fractionalMonetaryUnit(from: totalAmount, currencyCode: "AUD")
        isLoading = true
        paymentRepo.createNewOrder(purchasePrice: integerAmount, customerDetails: CustomerDetails.default()) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.orderId = response.orderId
                    self?.checkoutItem = CheckoutItem(transactionToken: response.transactionToken, handoverURL: response.handoverURL)
                case .failure(let error):
                    self?.alert = Alert(title: "Fetch Checkout URL Error", subtitle: error.localizedDescription)
                }
            }
        }
    }
}
