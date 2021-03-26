//
//  WebCheckoutViewWrapper.swift
//  Openpay
//
//  Created by june chen on 1/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct WebCheckoutView: UIViewControllerRepresentable {

    private let transactionToken: String
    private let handoverURL: URL
    private let completion: (WebCheckoutResult) -> Void

    init(transactionToken: String, handoverURL: URL, completion: @escaping (WebCheckoutResult) -> Void) {
        self.transactionToken = transactionToken
        self.handoverURL = handoverURL
        self.completion = completion
    }

    func makeUIViewController(context: Context) -> WebCheckoutViewController {
        return WebCheckoutViewController(transactionToken: transactionToken, handoverURL: handoverURL, completion: completion)
    }

    func updateUIViewController(_ uiViewController: WebCheckoutViewController, context: Context) {}
}
