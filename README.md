# Openpay iOS SDK
![Build and Test](https://github.com/openpay-innovations/sdk-ios/actions/workflows/build-test.yml/badge.svg)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Openpay)
![CocoaPods Platform](https://img.shields.io/cocoapods/p/Openpay)
![License](https://img.shields.io/github/license/openpay-innovations/sdk-ios)
![Forks](https://img.shields.io/github/forks/openpay-innovations/sdk-ios)

The Openpay SDK for iOS allows you to integrate Openpay with ease. It provides a framework and documentation for developers to enable payments for customers.

# Table of Contents

- [Openpay iOS SDK](#openpay-ios-sdk)
- [Table of Contents](#table-of-contents)
- [Integration](#integration)
    - [Requirements](#requirements)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
    - [Manually](#manually)
      - [XCFramework](#xcframework)
      - [Git Submodule](#git-submodule)
- [Examples](#examples)
- [Building](#building)
    - [Mint](#mint)
- [Features](#features)
  - [Web Checkout View](#web-checkout-view)
    - [Swift - UIKit](#swift---uikit)
    - [Objective-C](#objective-c)
    - [SwiftUI](#swiftui)
  - [Openpay Payment Button](#openpay-payment-button)
    - [Amber with Granite Grey](#amber-with-granite-grey)
    - [Granite Grey with White](#granite-grey-with-white)
    - [Example](#example)
  - [Openpay Badge](#openpay-badge)
    - [Amber with Granite Grey](#amber-with-granite-grey-1)
    - [Light](#light)
    - [Example](#example-1)
  - [Themes](#themes)
- [Contributing](#contributing)
- [License](#license)

# Integration

### Requirements
- iOS 13 or later
- Swift 5.3 or later
- Xcode 12 or later


### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. For installation and usage instructions, please visit their website for details. To integrate the Openpay SDK into your Xcode project using CocoaPods, add it to your `Podfile`:
```
pod 'Openpay', '~> 0.1.0'
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a dependency manager that builds your dependencies to provide you with binary frameworks. To integrate the Openpay SDK into your Xcode project using Carthage, add it to your `Cartfile`:
```
github "openpay-innovations/sdk-ios" ~> 0.1.0
```

### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. 

---
**NOTE**

When you add the SDK from Xcode -> File -> Swift Packages -> Add Package Dependency and select the version you want, Xcode will automatically suggest the current version `Up to Next Major`. 

We strongly suggest that while the iOS Openpay SDK is on a `0.x.y` version scheme, you should select `Up to Next Minor`, because we will still be releasing breaking changes on minor versions.

---

To integrate Openpay SDK into your Xcode project using SPM, add it to your `Package.swift`:
```
dependencies: [
    .package(url: "https://github.com/openpay-innovations/sdk-ios.git", .upToNextMinor(from: "0.1.0"))
]
```


### Manually

#### XCFramework
The XCFramework of the Openpay SDK can be generated by following the [official documentation](https://help.apple.com/xcode/mac/11.4/#/dev544efab96).
#### Git Submodule
Follow the steps below to add the Openpay SDK as a [git submodule](https://git-scm.com/docs/git-submodule):
- Navigate to the root of your working directory
- Run the command to add the SDK as a submodule
    
    ```
    git submodule add https://github.com/openpay-innovations/sdk-ios.git Openpay
    ```
- Open the new `Openpay` folder and drag `Openpay.xcodeproj` into the Project Navigator of your application's Xcode project.
- Select `Openpay.xcodeproj` in the Project Navigator and make sure that the deployment target matches that of your application target.
- Select your application project and navigate to the target configuration window.
- Select the application target under the "Targets" heading in the sidebar.
- Open the "General" panel in the tab bar at the top of that window.
- Click on the `+` button under the "Frameworks, Libraries, and Embedded Content" section.
- Select `Openpay.framework`.

That's all you need to import the Openpay SDK and you can now build it on the device and simulator.

# Examples
The [example project](https://github.com/openpay-innovations/sdk-ios/tree/main/Example) gives an example of how the payment flow works with the web checkout.

To run the example app, open `Openpay.xcworkspace` and the example project can be built and run via the Example target.

---
**NOTE**

To be able to see the web checkout view, you need to provide the order ID, transaction token and the base handover URL in [Configuration.swift](https://github.com/openpay-innovations/sdk-ios/Example/Sources/Example/Configuration.swift). The order ID, transaction token and handover URL can be obtained via the merchant server calling the [Openpay create order endpoint](https://developer.openpay.com.au/api.html#tag/Orders/paths/~1orders/post).

```
/// Insert your order Id, transaction token and handover URL to see the web checkout view.
let createOrderResponse = CreateOrderResponse(
    orderId: "",
    transactionToken: "",
    handoverURL: URL(string: "https://example.com/")!
)
```

---


# Building
### Mint
[Mint](https://github.com/yonaskolb/Mint) is a package manager that installs and runs Swift command line tool packages. The Openpay SDK uses Mint to install and run the packages listed in the `Mintfile` such as [SwiftLint](https://github.com/realm/SwiftLint).

You can simply build the SDK project with Cmd + B or run the [bootstrap-tools](https://github.com/openpay-innovations/sdk-ios/tree/main/Support/Scripts/BuildPhase/bootstrap-tools) script to install all the Swift command line tool packages before the first build to speed up the build time.

You do not need to install Mint manually as an extra step because a pre-compiled Mint executable file is included under the directory [Tools/mint](https://github.com/openpay-innovations/sdk-ios/tree/main/Tools/mint).

# Features
## Web Checkout View
The web checkout view can be modally presented, passing the URL-encoded transaction token and the base handover URL. When the web checkout flow is completed, the web view will be dismissed and return the checkout result.

The transaction token and the base handover URL are generated via the `/orders` endpoint on the Openpay backend. Note that the transaction token returned from the Openpay backend is already URL-encoded so you do not need to encode it again.

### Swift - UIKit
```
    final class CheckoutViewController: UIViewController {
        private func presentCheckoutWebView(transactionToken: String, handoverURL: URL) {
            Openpay.presentWebCheckoutView(
                over: self,
                transactionToken: transactionToken,
                handoverURL: handoverURL,
                completion: { result in
                    switch result {
                    case .success(.webLodged(let planId, _)):
                        // Handle the successful result
                    case .failure(let failure):
                        // Handle the failure result
                    }
                }
            )
        }
    }
```

### Objective-C
```
  + (void)presentWebCheckoutViewOverViewController:(UIViewController *)viewController
                                  transactionToken:(NSString *)token
                                       handoverURL:(NSURL *)url
                                          animated:(BOOL)flag
                                  webLodgedHandler:(WebLodgedHandler)webLodgedHandler {

      void (^completion)(OPWebCheckoutResult *) = ^(OPWebCheckoutResult *result) {
          OPSuccess *success = [(OPWebCheckoutResultSuccess *)result status];

          // Handle the successful result
          if ([success isKindOfClass:[OPWebLodged class]]) {
              OPWebLodged *webLodged = (OPWebLodged *)success;
              webLodgedHandler([webLodged planId], [webLodged orderId]);
              return;
          }

          OPFailure *failure = [(OPWebCheckoutResultFailure *)result status];
          // Handle different types of failure
          if ([failure isKindOfClass:[OPWebCancelled class]]) {
              OPWebCancelled *webCancelled = (OPWebCancelled *)failure;
              webCancelledHandler([webCancelled planId], [webCancelled orderId]);
              return;
          }
          ...
      };
      [OPOpenpay presentWebCheckoutViewOverViewController:viewController
                                         transactionToken:token
                                              handoverURL:url
                                                 animated:flag
                                               completion:completion];
  }
```

### SwiftUI
```
    struct MainView: View {
        @State private var checkoutItem = CheckoutItem(transactionToken: "", handoverURL: "")
        var body: View {
          SomeCheckoutView()
          .openpayWebCheckoutView(checkoutItem: $checkoutItem) { result in
              // Handle the checkout result
          }
        }
    }
```

## Openpay Payment Button
The Openpay SDK provides several payment buttons you can use to allow people to make payments with Openpay. The button styles below are available in the SDK.

For more details about the payment button see [SDK Styleguide](Support/Images/styleguide.pdf).

### Amber with Granite Grey

| Granite on Amber | Amber on Granite |
| ---------------- | ---------------- |
| ![Payment Button Granite On Amber](Support/Images/payment_button_graniteOnAmber.svg) | ![Payment Button Amber On Granite](Support/Images/payment_button_amberOnGranite.svg) |

### Granite Grey with White

| Granite on White | White on Granite |
| ---------------- | ---------------- |
| ![Payment Button Granite On White](Support/Images/payment_button_graniteOnWhite.svg) | ![Payment Button White On Granite](Support/Images/payment_button_whiteOnGranite.svg) |

Maintain the minimum button size around the button in iOS. Use the following values for guidance.
| Minimum Width | Maximum Width | Minimum Height |
| ------------- | ------------- | -------------- |
| 218pt         | 380pt         |      48pt      |

You get the following advantages by using the Openpay payment button:
- Support for configuring the button’s corner radius to match the style of your UI
- Support for accessibility label that lets VoiceOver describe the button
- Support for light and dark modes
- Adjust the corner radius to match the appearance of other buttons in your app

### Example
```
// Initialize an Openpay checkout button using graniteOnAmber theme in light mode and amberOnGranite theme in dark mode.
// The OpenpayPaymentButton is a subclass of UIButton
let checkoutButton = OpenpayPaymentButton(theme: .dynamic(light: .graniteOnAmber, dark: .amberOnGranite))
```

## Openpay Badge
The Openpay SDK provides four different color schemes for the badge view. The following button styles are available in the SDK.

For more details about the badge see [SDK Styleguide](Support/Images/styleguide.pdf).

### Amber with Granite Grey
| Granite on Amber | Amber on Granite | Minimum Width |
| --- | ----------- | ----------- |
| ![Payment Button Granite On Amber](Support/Images/badge_graniteOnAmber.svg) | ![Payment Button Amber On Granite](Support/Images/badge_amberOnGranite.svg) | 75pt          |

### Light
The badge is just the Openpay logo and the background is transparent.

| White | Granite | Minimum Width |
| --- | ----------- | ----------- |
| ![Payment Button Granite](Support/Images/badge_granite.svg) | ![Payment Button White](Support/Images/badge_white.svg) | 80pt          |

You get the following advantages by using the Openpay badge:
- The badge view can be scaled to to match the style of your UI
- Support for accessibility label that lets VoiceOver describe the badge
- Support for light and dark modes

### Example
```
// Initialize an Openpay badge using graniteOnAmber color scheme in light mode and amberOnGranite color scheme in dark mode.
// The OpenpayBadge is a subclass of UIView
let openpayBadge = OpenpayBadge(theme: .dynamic(light: .graniteOnAmber, dark: .amberOnGranite))
```

## Themes
The Openpay SDK allow developers to apply different color schemes for different user interfaces. The following themes are available in the SDK:
- Universal
  
  The universal theme uses a static color scheme and does not adapt to light and dark interfaces. 
- Dynamic
  
  The dynamic theme adapts to light and dark interfaces.

# Contributing
All contributions are welcome! Please refer to our [contribution guide](https://github.com/openpay-innovations/sdk-ios/blob/main/CONTRIBUTING.md) before making a submission.

# License
This project is released under the terms of the Apache 2.0 license. See [LICENSE](https://github.com/openpay-innovations/sdk-ios/blob/main/LICENSE) file for details.