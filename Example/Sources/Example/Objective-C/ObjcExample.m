//
//  ObjcExample.m
//  Example
//
//  Created by june chen on 25/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjcExample.h"
#import <Openpay/Openpay-Swift.h>

@implementation ObjcExample

+ (void)presentWebCheckoutViewOverViewController:(UIViewController *)viewController
                                transactionToken:(NSString *)token
                                     handoverURL:(NSURL *)url
                                        animated:(BOOL)flag
                                webLodgedHandler:(WebLodgedHandler)webLodgedHandler
                             webCancelledHandler:(WebCancelledHandler)webCancelledHandler
                                webFailedHandler:(WebFailedHandler)webFailedHandler
                        loadWebViewFailedHandler:(LoadWebViewFailedHandler)loadWebViewFailedHandler
                                cancelledHandler:(CancelledHandler)cancelledHandler {

    void (^completion)(OPWebCheckoutResult *) = ^(OPWebCheckoutResult *result) {
        OPSuccess *success = [(OPWebCheckoutResultSuccess *)result status];

        if ([success isKindOfClass:[OPWebLodged class]]) {
            OPWebLodged *webLodged = (OPWebLodged *)success;
            webLodgedHandler([webLodged planId], [webLodged orderId]);
            return;
        }

        OPFailure *failure = [(OPWebCheckoutResultFailure *)result status];
        if ([failure isKindOfClass:[OPWebCancelled class]]) {
            OPWebCancelled *webCancelled = (OPWebCancelled *)failure;
            webCancelledHandler([webCancelled planId], [webCancelled orderId]);
            return;
        }

        if ([failure isKindOfClass:[OPWebFailed class]]) {
            OPWebFailed *webFailed = (OPWebFailed *)failure;
            webCancelledHandler([webFailed planId], [webFailed orderId]);
            return;
        }

        if ([failure isKindOfClass:[OPLoadWebViewFailed class]]) {
            OPLoadWebViewFailed *loadWebViewFailed = (OPLoadWebViewFailed *)failure;
            loadWebViewFailedHandler([loadWebViewFailed error]);
            return;
        }

        if ([failure isKindOfClass:[OPCancelled class]]) {
            cancelledHandler();
            return;
        }
    };
    [OPOpenpay presentWebCheckoutViewOverViewController:viewController transactionToken:token handoverURL:url animated:flag completion:completion];
}

@end

