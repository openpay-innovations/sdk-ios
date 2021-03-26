//
//  OPObjCWrapper.swift
//  Openpay
//
//  Created by june chen on 25/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

@objc(OPOpenpay)
public final class OPObjCWrapper: NSObject {
    @objc(presentWebCheckoutViewOverViewController:transactionToken:handoverURL:animated:completion:)
    public static func presentWebCheckoutView(
        over viewController: UIViewController,
        transactionToken: String,
        handoverURL: URL,
        animated: Bool = true,
        completion: @escaping (WebCheckoutResult) -> Void
    ) {
        Openpay.presentWebCheckoutView(
            over: viewController,
            transactionToken: transactionToken,
            handoverURL: handoverURL,
            animated: animated,
            completion: { result in
                switch result {
                case .success(.webLodged(let planId, let orderId)):
                    completion(.success(.webLodged(planId: planId, orderId: orderId)))
                case .success(.webSuccess(let planId, let orderId)):
                    completion(.success(.webSuccess(planId: planId, orderId: orderId)))
                case .failure(.webCancelled(let planId, let orderId)):
                    completion(.failure(.webCancelled(planId: planId, orderId: orderId)))
                case .failure(.webFailed(let planId, let orderId)):
                    completion(.failure(.webFailed(planId: planId, orderId: orderId)))
                case .failure(.loadWebViewFailed(let error)):
                    completion(.failure(.loadWebViewFailed(error)))
                case .failure(.cancelled):
                    completion(.failure(.cancelled()))
                case .failure(.invalidURL):
                    completion(.failure(.invalidURL()))
                }
            }
        )
    }

    @objc(OPWebCheckoutResult)
    public class WebCheckoutResult: NSObject {

        override init() {}

        static func success(_ status: Success) -> WebCheckoutResultSuccess {
            return WebCheckoutResultSuccess(status: status)
        }

        static func failure(_ status: Failure) -> WebCheckoutResultFailure {
            return WebCheckoutResultFailure(status: status)
        }
    }

    // MARK: - Success

    @objc(OPWebCheckoutResultSuccess)
    public class WebCheckoutResultSuccess: WebCheckoutResult {
        @objc public let status: Success

        init(status: Success) {
            self.status = status
        }
    }

    @objc(OPSuccess)
    public class Success: NSObject {
        static func webSuccess(planId: String, orderId: String?) -> WebSuccess {
            return WebSuccess(planId: planId, orderId: orderId)
        }

        static func webLodged(planId: String, orderId: String?) -> WebLodged {
            return WebLodged(planId: planId, orderId: orderId)
        }
    }

    @objc(OPWebSuccess)
    public class WebSuccess: Success {
        @objc public let planId: String
        @objc public let orderId: String?

        init(planId: String, orderId: String?) {
            self.planId = planId
            self.orderId = orderId
        }
    }

    @objc(OPWebLodged)
    public class WebLodged: Success {
        @objc public let planId: String
        @objc public let orderId: String?

        init(planId: String, orderId: String?) {
            self.planId = planId
            self.orderId = orderId
        }
    }

    // MARK: - Failure

    @objc(OPWebCheckoutResultFailure)
    public class WebCheckoutResultFailure: WebCheckoutResult {
        @objc public let status: Failure

        init(status: Failure) {
            self.status = status
        }
    }

    @objc(OPFailure)
    public class Failure: NSObject {
        static func webCancelled(planId: String, orderId: String?) -> WebCancelled {
            return WebCancelled(planId: planId, orderId: orderId)
        }

        static func webFailed(planId: String, orderId: String?) -> WebFailed {
            return WebFailed(planId: planId, orderId: orderId)
        }

        static func loadWebViewFailed(_ error: Error) -> LoadWebViewFailed {
            return LoadWebViewFailed(error: error)
        }

        static func invalidURL() -> InvalidURL {
            return InvalidURL()
        }

        static func cancelled() -> Cancelled {
            return Cancelled()
        }
    }

    @objc(OPWebCancelled)
    public class WebCancelled: Failure {
        @objc public let planId: String
        @objc public let orderId: String?

        init(planId: String, orderId: String?) {
            self.planId = planId
            self.orderId = orderId
        }
    }

    @objc(OPWebFailed)
    public class WebFailed: Failure {
        @objc public let planId: String
        @objc public let orderId: String?

        init(planId: String, orderId: String?) {
            self.planId = planId
            self.orderId = orderId
        }
    }

    @objc(OPLoadWebViewFailed)
    public class LoadWebViewFailed: Failure {
        @objc public let error: Error

        init(error: Error) {
            self.error = error
        }
    }

    @objc(OPInvalidURL)
    public class InvalidURL: Failure {}

    @objc(OPCancelled)
    public class Cancelled: Failure {}
}
