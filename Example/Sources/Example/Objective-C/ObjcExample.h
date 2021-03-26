//
//  ObjcExample.h
//  Example
//
//  Created by june chen on 25/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcExample: NSObject

typedef void (^ WebLodgedHandler)(NSString *, NSString *);
typedef void (^ WebCancelledHandler)(NSString *, NSString *);
typedef void (^ WebFailedHandler)(NSString *, NSString *);
typedef void (^ LoadWebViewFailedHandler)(NSError *);
typedef void (^ CancelledHandler)(void);

+ (void)presentWebCheckoutViewOverViewController:(UIViewController *)viewController
                                transactionToken:(NSString *)token
                                     handoverURL:(NSURL *)url
                                        animated:(BOOL)flag
                                webLodgedHandler:(WebLodgedHandler)webLodgedHandler
                             webCancelledHandler:(WebCancelledHandler)webCancelledHandler
                                webFailedHandler:(WebFailedHandler)webFailedHandler
                        loadWebViewFailedHandler:(LoadWebViewFailedHandler)loadWebViewFailedHandler
                                cancelledHandler:(CancelledHandler)cancelledHandler;

@end

NS_ASSUME_NONNULL_END
