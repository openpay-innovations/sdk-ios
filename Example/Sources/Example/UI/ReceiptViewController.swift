//
//  ReceiptViewController.swift
//  Example
//
//  Created by june chen on 9/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

final class ReceiptViewController: UIViewController {
    private var receiptView: ReceiptView!
    private let planID: String
    private let totalAmount: String

    init(planID: String, totalAmount: String) {
        self.planID = planID
        self.totalAmount = totalAmount
        super.init(nibName: nil, bundle: nil)

        title = "RECEIPT"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground

        receiptView = ReceiptView()
        receiptView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(receiptView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            receiptView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            receiptView.topAnchor.constraint(equalTo: guide.topAnchor),
            receiptView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            receiptView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        receiptView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        receiptView.update(title: "Order Completed", planID: planID, totalAmount: totalAmount)
    }

    @objc
    private func doneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

private class ReceiptView: UIView {
    let doneButton: UIButton = { button in
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(UIColor.graniteGrey, for: .normal)
        button.backgroundColor = UIColor.aussieAmber
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }(UIButton())

    private let titleLabel = UILabel.exampleBody
    private let planIDLabel = UILabel.exampleBody
    private let totalAmountLabel = UILabel.exampleBody

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [titleLabel, planIDLabel, totalAmountLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
        ])

        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(title: String, planID: String, totalAmount: String) {
        titleLabel.text = title
        planIDLabel.text = "PlanID: #\(planID)"
        totalAmountLabel.text = "Total: \(totalAmount)"
    }
}
