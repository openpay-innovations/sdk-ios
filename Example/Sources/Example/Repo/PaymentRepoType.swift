//
//  PaymentRepoType.swift
//  Example
//
//  Created by june chen on 11/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import Openpay

protocol PaymentRepoType {
    func createNewOrder(purchasePrice: Int, customerDetails: CustomerDetails, completion: @escaping (Result<CreateOrderResponse, Error>) -> Void)
    func capturePayment(orderId: String, completion: @escaping (Result<CapturePaymentResponse, Error>) -> Void)
}

final class MockPaymentRepo: PaymentRepoType {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func createNewOrder(
        purchasePrice: Int,
        customerDetails: CustomerDetails,
        completion: @escaping (Result<CreateOrderResponse, Error>) -> Void
    ) {
        completion(.success(createOrderResponse))
    }

    func capturePayment(orderId: String, completion: @escaping (Result<CapturePaymentResponse, Error>) -> Void) {
        completion(.success(capturePaymentResponse))
    }
}
