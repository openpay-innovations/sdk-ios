//
//  CheckoutViewController.swift
//  Example
//
//  Copyright © 2021 Openpay. All rights reserved.
//  Created by june chen on 9/2/21.
//

import Openpay
import OSLog
import UIKit

final class CheckoutViewController: UIViewController {

    private var checkoutView: CheckoutView!
    private let viewModel: CheckoutViewModel

    init(apiService: APIService) {
        self.viewModel = CheckoutViewModel(paymentRepo: MockPaymentRepo(apiService: apiService))
        super.init(nibName: nil, bundle: nil)

        title = "CHECKOUT"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        checkoutView = CheckoutView()
        checkoutView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkoutView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            checkoutView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            checkoutView.topAnchor.constraint(equalTo: guide.topAnchor),
            checkoutView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            checkoutView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutView.checkoutButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        checkoutView.textFields.forEach { item in
            item.delegate = self
        }

        checkoutView.customerDetailsView.statePickerView.delegate = self
        checkoutView.customerDetailsView.statePickerView.dataSource = self

        registerKeyboardNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkoutView.checkoutButton.isEnabled = viewModel.isValid
        checkoutView.customerDetailsView.update(customerDetails: viewModel.customerDetails)
        checkoutView.summaryView.update(amount: viewModel.totalAmountDisplayValue)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

    // MARK: - Checkout

    @objc
    private func buttonTapped() {
        ActivityIndicatorViewController.present(fromViewController: self, loadingText: "Creating order...") { [viewModel] activityIndicator in
            viewModel.checkout(successHandler: { [weak self] transactionToken, handoverURL in
                DispatchQueue.main.async {
                    activityIndicator.dismiss()
                    self?.presentCheckoutWebView(transactionToken: transactionToken, handoverURL: handoverURL)
                }
            }, errorHandler: { [weak self] error in
                DispatchQueue.main.async {
                    activityIndicator.dismiss()
                    let alert: UIAlertController
                    if let modelError = error as? CheckoutViewModel.CheckoutError {
                        switch modelError {
                        case .mockResponseMissing:
                            alert = AlertHelper.simple(title: "Error", message: "Please insert a valid transaction token, order Id and handover URL in the Configuration.swift.")
                        }
                    } else {
                        alert = AlertHelper.simple(title: "Error", message: "Failed to fetch the checkout URL: \(error.localizedDescription)")
                    }
                    self?.present(alert, animated: true, completion: nil)
                }
            })
        }
    }

    private func presentCheckoutWebView(transactionToken: String, handoverURL: URL) {
        let webLodgedHandler: (String) -> Void = { [weak self] planId in
            os_log("The plan submission is lodged successfully. PlanID: %@", log: .general, type: .debug, planId)
            self?.makePayment(planID: planId)
        }

        switch viewModel.programmingLanguage {
        case .swift:
            Openpay.presentWebCheckoutView(
                over: self,
                transactionToken: transactionToken,
                handoverURL: handoverURL,
                completion: { [weak self] result in
                    switch result {
                    case .success(.webLodged(let planId, _)):
                        webLodgedHandler(planId)
                    case .failure(let failure):
                        self?.handleCheckoutFailure(failure)
                    case .success(.webSuccess(let planId, _)):
                        os_log(
                            "The plan creation type Pending should be used for the plans created in the Online websales journey instead of Instant. PlanID: %@",
                            log: .general,
                            type: .debug,
                            planId
                        )
                    }
                }
            )
        case .objectiveC:
            ObjcExample.presentWebCheckoutViewOverViewController(
                self,
                transactionToken: transactionToken,
                handoverURL: handoverURL,
                animated: true,
                webLodgedHandler: { planId, _ in
                    webLodgedHandler(planId)
                },
                webCancelledHandler: { [weak self] planId, orderId in self?.handleCheckoutFailure(.webCancelled(planId: planId, orderId: orderId)) },
                webFailedHandler: { [weak self] planId, orderId in self?.handleCheckoutFailure(.webFailed(planId: planId, orderId: orderId)) },
                loadWebViewFailedHandler: { [weak self] error in self?.handleCheckoutFailure(.loadWebViewFailed(error)) },
                cancelledHandler: { [weak self] in self?.handleCheckoutFailure(.cancelled) }
            )
        }
    }

    private func makePayment(planID: String) {
        ActivityIndicatorViewController.present(fromViewController: self, loadingText: "Capturing Payment...") { [viewModel] activityIndicator in
            viewModel.makePayment(successHandler: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    activityIndicator.dismiss()
                    let receiptVC = ReceiptViewController(planID: planID, totalAmount: self.viewModel.totalAmountDisplayValue)
                    self.navigationController?.pushViewController(receiptVC, animated: true)
                }
            }, errorHandler: { [weak self] error in
                DispatchQueue.main.async {
                    activityIndicator.dismiss()
                    let alert = AlertHelper.simple(title: "Error", message: "Failed to make the payment. Error: \(error.localizedDescription)")
                    self?.present(alert, animated: true, completion: nil)
                }
            })
        }
    }

    private func handleCheckoutFailure(_ failure: WebCheckoutResult.Failure) {
        let errorMessage: String

        switch failure {
        case .webCancelled(let planId, _):
            errorMessage = "The plan submission is cancelled. Plan ID: \(planId)"
        case .webFailed(let planId, _):
            errorMessage = "The plan submission failed. Plan ID: \(planId)"
        case .loadWebViewFailed(let error):
            errorMessage = error.localizedDescription
        case .invalidURL:
            errorMessage = "The checkout URL is invalid."
        case .cancelled:
            errorMessage = "The web checkout view has been dismissed by the user."
        }
        let alert = AlertHelper.simple(title: "Error", message: "Openpay Checkout Failed: \(errorMessage)")
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Keyboard
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUIForKeyboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUIForKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc
    private func updateUIForKeyboard(notification: Notification) {
        let scrollView = checkoutView.scrollView
        let textField = checkoutView.textFields.first { $0.isFirstResponder }
        guard notification.name != UIResponder.keyboardWillHideNotification,
              let keyboardHeight = notification.keyboardHeight,
              let activeTextField = textField else {
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = .zero
            return
        }

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        let origin = activeTextField.frame.origin
        if view.frame.contains(origin) == false {
            let offset = CGPoint(x: 0, y: origin.y - keyboardHeight)
            scrollView.setContentOffset(offset, animated: true)
        }
    }
}

extension CheckoutViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text: String = textField.text ?? ""
        let state: FormTextFieldView.State = text.isEmpty ? .error : .unfocused
        let view = checkoutView.customerDetailsView
        let formTextView = checkoutView.customerDetailsView.formFieldView(key: textField)
        formTextView.state = state

        switch textField {
        case view.firstNameTextFieldView.textField:
            viewModel.customerDetails.firstName = text
        case view.lastNameTextFieldView.textField:
            viewModel.customerDetails.familyName = text
        case view.emailTextFieldView.textField:
            viewModel.customerDetails.email = text
        case view.streetTextFieldView.textField:
            viewModel.customerDetails.street = text
        case view.suburbTextFieldView.textField:
            viewModel.customerDetails.suburb = text
        case view.postcodeTextFieldView.textField:
            viewModel.customerDetails.postcode = text
        default:
            fatalError("The text field \(textField) is not handled.")
        }

        checkoutView.checkoutButton.isEnabled = viewModel.isValid
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let formTextView = checkoutView.customerDetailsView.formFieldView(key: textField)
        formTextView.state = .focused
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension CheckoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.states.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.states[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedState = viewModel.states[row].rawValue
        checkoutView.customerDetailsView.stateTextFieldView.textField.text = selectedState
        viewModel.customerDetails.state = selectedState
    }

}
