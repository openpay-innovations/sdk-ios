//
//  FormTextFieldView.swift
//  Example
//
//  Created by june chen on 10/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

final class FormTextFieldView: UIView {
    enum State {
        case unfocused
        case focused
        case error
    }

    let titleLabel = UILabel.exampleHeadline

    let textField = UITextField()

    let underline = UIView()

    var state: State = .unfocused {
        didSet {
            switch state {
            case .unfocused:
                underline.backgroundColor = .separator
            case .focused:
                underline.backgroundColor = .systemBlue
            case .error:
                underline.backgroundColor = .systemRed
            }
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        underline.backgroundColor = .systemGray4

        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, underline])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill

        addSubview(stackView)

        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
