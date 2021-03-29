//
//  CheckoutView.swift
//  Example
//
//  Created by june chen on 10/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import Openpay

final class CheckoutView: UIView {

    let checkoutButton = OpenpayPaymentButton(theme: .dynamic(light: .graniteOnAmber, dark: .amberOnGranite))

    let summaryView = SummaryView()

    let customerDetailsView: CustomerDetailsView = { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }(CustomerDetailsView())

    let scrollView = UIScrollView()

    var textFields: [UITextField] {
        [
        customerDetailsView.firstNameTextFieldView.textField,
        customerDetailsView.lastNameTextFieldView.textField,
        customerDetailsView.emailTextFieldView.textField,
        customerDetailsView.streetTextFieldView.textField,
        customerDetailsView.suburbTextFieldView.textField,
        customerDetailsView.postcodeTextFieldView.textField,
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        addSubview(checkoutButton)
        NSLayoutConstraint.activate([
            checkoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: -16),
        ])

        addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            summaryView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        ])

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [summaryView, customerDetailsView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SummaryView: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 50)
    }

    let amountLabel = UILabel.exampleHeadline
    let openpayBadge = OpenpayBadge(theme: .dynamic(light: .graniteOnAmber, dark: .amberOnGranite))

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [openpayBadge, amountLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            openpayBadge.widthAnchor.constraint(equalToConstant: 84),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(amount: String) {
        amountLabel.text = "Total: \(amount)"
    }
}

final class CustomerDetailsView: UIView {
    let firstNameTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "First Name"
        view.textField.placeholder = "required"
        return view
    }(FormTextFieldView())

    let lastNameTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "Last Name"
        view.textField.placeholder = "required"
        return view
    }(FormTextFieldView())

    let emailTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "Email Address"
        view.textField.placeholder = "required"
        view.textField.keyboardType = .emailAddress
        return view
    }(FormTextFieldView())

    let streetTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "Street"
        view.textField.placeholder = "required"
        return view
    }(FormTextFieldView())

    let suburbTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "Suburb"
        view.textField.placeholder = "required"
        return view
    }(FormTextFieldView())

    let postcodeTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "Post code"
        view.textField.placeholder = "required"
        return view
    }(FormTextFieldView())

    let stateTextFieldView: FormTextFieldView = { view in
        view.titleLabel.text = "State"
        view.textField.placeholder = "required"
        return view
    }(FormTextFieldView())

    let statePickerView = UIPickerView()

    @objc
    private func doneButtonTappedOnPicker() {
        endEditing(true)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTappedOnPicker))
        let accessoryView = UIToolbar()
        accessoryView.sizeToFit()
        accessoryView.setItems([doneItem], animated: false)
        stateTextFieldView.textField.inputView = statePickerView
        stateTextFieldView.textField.inputAccessoryView = accessoryView

        let textFields = [
            firstNameTextFieldView,
            lastNameTextFieldView,
            emailTextFieldView,
            stateTextFieldView,
            streetTextFieldView,
            suburbTextFieldView,
            postcodeTextFieldView,
        ]

        textFields.forEach { item in
            item.textField.returnKeyType = .done
        }

        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(customerDetails: CustomerDetails) {
        firstNameTextFieldView.textField.text = customerDetails.firstName
        lastNameTextFieldView.textField.text = customerDetails.familyName
        emailTextFieldView.textField.text = customerDetails.email
        streetTextFieldView.textField.text = customerDetails.street
        suburbTextFieldView.textField.text = customerDetails.suburb
        postcodeTextFieldView.textField.text = customerDetails.postcode
        stateTextFieldView.textField.text = customerDetails.state
    }

    func formFieldView(key textField: UITextField) -> FormTextFieldView {
        switch textField {
        case firstNameTextFieldView.textField:
            return firstNameTextFieldView
        case lastNameTextFieldView.textField:
            return lastNameTextFieldView
        case emailTextFieldView.textField:
            return emailTextFieldView
        case streetTextFieldView.textField:
            return streetTextFieldView
        case suburbTextFieldView.textField:
            return suburbTextFieldView
        case postcodeTextFieldView.textField:
            return postcodeTextFieldView
        default:
            fatalError("The text field \(textField) is not handled.")
        }
    }
}
