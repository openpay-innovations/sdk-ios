//
//  SwiftUIExample.swift
//  Example
//
//  Created by june chen on 1/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Openpay
import SwiftUI

struct SwiftUIExample: View {

    @ObservedObject var viewModel: SwiftUIViewModel

    var body: some View {
        NavigationView {
            SwiftUICheckoutView(
                alert: $viewModel.alert,
                totalAmount: viewModel.totalAmountDisplayValue,
                checkout: viewModel.checkout,
                isLoading: $viewModel.isLoading
            )
            .navigationViewTitle("Checkout Page")
            .openpayWebCheckoutView(checkoutItem: $viewModel.checkoutItem) { result in
                viewModel.checkoutCompletion(result)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct SwiftUICheckoutView: View {
    @Binding var alert: SwiftUIViewModel.Alert?
    let totalAmount: String
    let checkout: () -> Void
    @Binding var isLoading: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    BadgeView(colorTheme: .dynamic(light: .graniteOnAmber, dark: .amberOnGranite))
                        .frame(width: 75, height: 24)

                    Text("Total Amount: \(totalAmount)").font(.headline)
                }
                PaymentButtonView(
                    action: checkout,
                    colorTheme: .dynamic(light: .graniteOnAmber, dark: .amberOnGranite)
                )
                .frame(width: 218, height: 48)
                .alert(item: $alert) { item -> Alert in
                    Alert(title: Text(item.title), message: Text(item.subtitle))
                }
            }
            if #available(iOS 14.0, *) {
                if isLoading {
                    ProgressView()
                }
            } else {
                ActivityIndicator(isAnimating: $isLoading, style: .large)
            }
        }
    }
}

private extension View {
    func navigationViewTitle(_ titleKey: LocalizedStringKey) -> some View {
        if #available(iOS 14.0, *) {
            // AnyView can be removed when using Xcode 12 beta 5
            return AnyView(navigationTitle(titleKey))
        } else {
            return AnyView(navigationBarTitle(titleKey))
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct SwiftUIExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SwiftUIExample(viewModel: SwiftUIViewModel(paymentRepo: MockPaymentRepo(apiService: HTTPSAPIService(baseURL: URL(string: "https://merchant-server.test/")!))))

            SwiftUIExample(viewModel: SwiftUIViewModel(paymentRepo: MockPaymentRepo(apiService: HTTPSAPIService(baseURL: URL(string: "https://merchant-server.test/")!))))
                .preferredColorScheme(.dark)
        }
    }
}
