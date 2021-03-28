//
//  Logging.swift
//  Example
//
//  Created by june chen on 15/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    static let general = OSLog(subsystem: "com.openpay.Example", category: "General")
}
