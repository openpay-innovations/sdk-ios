//
//  Alert.swift
//  Example
//
//  Created by june chen on 19/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import UIKit

final class AlertHelper: NSObject {
    static func simple(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
