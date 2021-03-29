//
//  Bundle+Example.swift
//  Example
//
//  Created by june chen on 16/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

public extension Bundle {
    var openpayAPIVersion: String {
        // swiftlint:disable force_cast
        object(forInfoDictionaryKey: "OpenpayAPI version") as! String
    }
}
