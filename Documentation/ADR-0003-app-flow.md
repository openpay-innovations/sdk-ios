# ADR-0003: Developer Experience and Example App Flow

## Context
The Example Application is used to set an example of how to use the SDK APIs.

### Developer Experience
**Steps to complete a purchase workflow:**

1. The app obtains the transaction token and handover URL via the merchant server calling the Openpay create order endpoint
2. The app passes the data to the SDK to present the web checkout view 
3. After completing the payment flow, the result can be returned from the webview by checking the URL parameters of the final payment flow URL
4. The app lets the merchant server know to proceed with the payment

**Openpay Webview**

From the Openpay payment button, a modal webview can be presented for the user to log into Openpay. The SDK will compose the checkout URL by using the transaction token and base handover URL provided by the app.

## Decision

**Example App Workflow**

Based on the workflow above, the Example app will follow the steps below to set an example of the app flow:

1. Integrate the Openpay iOS SDK to the app
2. Build the shopping checkout page, including the Openpay payment button and badge provided by the SDK
3. On tapping "pay with Openpay" button, the app will pass data to the merchant server in order to call the Openpay create order endpoints (`/orders`) with information about the amount and customer details
4. Receive the transaction token and handover URL from the merchant server
5. Feed the transaction token and handover URL into the SDK to present the web checkout view modally
6. Receive a success or a failure callback after the payment flow in the webview is completed
7. If the result is success, capture the payment via the merchant server calling the Openpay capture payment endpoint
8. If the result is failure, display the error message via an alert view

**Run Example App**

The Example app will need an Example server to do a full demo, however to make it simple and easier to maintain, we decided not to implement an Example server for it.

Note that we try to avoid an example app calling the Openpay endpoint directly, skipping the merchant server, because it might give developers the wrong impression that it is acceptable for the API secret key to be saved on the client side. However, the API key should always be stored on the server side for security reasons.

*You should never store the Openpay API key on the client side.*

Hence, to be able to see the web checkout view, the user needs to provide the order Id, transaction token and the base handover URL in [Configuration.swift]().
```
/// Insert your order Id, transaction token and handover URL to see the web checkout view.
let createOrderResponse = CreateOrderResponse(
    orderId: "",
    transactionToken: "",
    handoverURL: URL(string: "https://example.com/")!
)
```