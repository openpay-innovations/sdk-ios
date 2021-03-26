//
//  Notification+Keyboard.swift
//  Example
//
//  Created by june chen on 10/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

extension Notification {
    var keyboardHeight: CGFloat? {
        let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return frame?.cgRectValue.height
    }
}
