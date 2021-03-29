//
//  WebCheckoutViewController.swift
//  Openpay
//
//  Created by june chen on 10/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import UIKit
import WebKit

final class WebCheckoutViewController: UIViewController {

    private var webView: WKWebView!
    private let checkoutURL: URL?
    private let completion: (_ result: WebCheckoutResult) -> Void

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let topVC = parent ?? self
        topVC.presentationController?.delegate = self

        // Dark mode is not supported on the web checkout page yet.
        parent?.view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // The checkout website does not support dark mode so the user interface style is hardcoded to be light.
        overrideUserInterfaceStyle = .light

        presentationController?.delegate = self
        webView.navigationDelegate = self
        webView.allowsLinkPreview = false

        loadWebView()
    }

    init(transactionToken: String, handoverURL: URL, completion: @escaping (_ result: WebCheckoutResult) -> Void) {
        var component = URLComponents(url: handoverURL, resolvingAgainstBaseURL: false)
        component?.percentEncodedQuery = "TransactionToken=\(transactionToken)"
        self.checkoutURL = component?.url

        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(Strings.fatalErrorInitCoderNotImplemented)
    }

    override func loadView() {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view = webView
    }

    private func loadWebView() {
        guard let checkoutURL = checkoutURL else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: checkoutURL)
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension WebCheckoutViewController: WKNavigationDelegate {

    private struct WebCompletion {
        let status: Status
        let planId: String
        let orderId: String?

        enum QueryItem: String {
            case status
            case planId = "planid"
            case orderId = "orderid"
        }

        enum Status: String {
            case success = "SUCCESS"
            case lodged = "LODGED"
            case cancelled = "CANCELLED"
            case failed = "FAILURE"
        }

        init?(url: URL) {
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            guard let statusValue = queryItems?.first(where: { $0.name == QueryItem.status.rawValue })?.value, let status = Status(rawValue: statusValue) else {
                return nil
            }
            self.status = status
            self.planId = queryItems?.first { $0.name == QueryItem.planId.rawValue }?.value ?? ""
            self.orderId = queryItems?.first { $0.name == QueryItem.orderId.rawValue }?.value
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presentRetryAlert(webView: webView, with: error)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return decisionHandler(.allow)
        }
        let isExternalLink = navigationAction.targetFrame == nil
        guard !isExternalLink else {
            UIApplication.shared.open(url)
            return decisionHandler(.cancel)
        }

        guard let completion = WebCompletion(url: url) else {
            return decisionHandler(.allow)
        }

        switch completion.status {
        case .lodged:
            dismiss(animated: true) {
                self.completion(.success(.webLodged(planId: completion.planId, orderId: completion.orderId)))
            }
        case .success:
            dismiss(animated: true) {
                self.completion(.success(.webSuccess(planId: completion.planId, orderId: completion.orderId)))
            }
        case .failed:
            dismiss(animated: true) {
                self.completion(.failure(.webFailed(planId: completion.planId, orderId: completion.orderId)))
            }
        case .cancelled:
            dismiss(animated: true) {
                self.completion(.failure(.webCancelled(planId: completion.planId, orderId: completion.orderId)))
            }
        }

        decisionHandler(.cancel)
    }

    private func presentRetryAlert(webView: WKWebView, with error: Error) {
        let alertView = UIAlertController(
            title: Strings.errorTitle,
            message: Strings.loadCheckoutViewFailedMessage,
            preferredStyle: .alert
        )

        let dismissHandler: (UIAlertAction) -> Void = { _ in
            self.dismiss(animated: true) { self.completion(.failure(.loadWebViewFailed(error))) }
        }
        let retryHandler: (UIAlertAction) -> Void = {  _ in
            self.loadWebView()
        }
        alertView.addAction(UIAlertAction(title: Strings.actionRetry, style: .default, handler: retryHandler))
        alertView.addAction(UIAlertAction(title: Strings.actionCancel, style: .destructive, handler: dismissHandler))
        present(alertView, animated: true, completion: nil)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension WebCheckoutViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(
      _ presentationController: UIPresentationController
    ) -> Bool {
      return false
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        presentDismissConfirmationAlert()
    }

    private func presentDismissConfirmationAlert() {
        let alertView = UIAlertController(title: Strings.dismissCheckoutViewConfirmationTitle, message: "", preferredStyle: .alert)
        let dismissHandler: (UIAlertAction) -> Void = { _ in
            self.dismiss(animated: true, completion: { self.completion(.failure(.cancelled)) })
        }

        alertView.addAction(UIAlertAction(title: Strings.actionYes, style: .default, handler: dismissHandler))
        alertView.addAction(UIAlertAction(title: Strings.actionNo, style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
}
