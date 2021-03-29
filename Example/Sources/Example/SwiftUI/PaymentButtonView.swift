//
//  PaymentButtonView.swift
//  Example
//
//  Created by june chen on 16/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import Openpay
import SwiftUI

struct PaymentButtonView: UIViewRepresentable {
    let action: () -> Void
    let colorTheme: OpenpayTheme<OpenpayPaymentButton.ColorScheme>

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let button = OpenpayPaymentButton(theme: colorTheme)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        button.addTarget(context.coordinator, action: #selector(Coordinator.action(_ :)), for: .touchUpInside)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject {
        let parent: PaymentButtonView

        init(_ parent: PaymentButtonView) {
            self.parent = parent
        }

        @objc
        func action(_ sender: Any) {
            parent.action()
        }
    }
}
