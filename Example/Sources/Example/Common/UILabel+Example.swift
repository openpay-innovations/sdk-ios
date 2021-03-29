//
//  UILabel+Example.swift
//  Example
//
//  Created by june chen on 9/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

extension UILabel {
    static var exampleBody: UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }

    static var exampleHeadline: UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }
}
