//
//  OpenpayConfigObserver.swift
//  Openpay
//
//  Created by june chen on 7/4/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

public protocol OpenpayConfigObserver: AnyObject {
    func brandingDidChange(_ previousBranding: OpenpayBranding)
}

public extension OpenpayConfigObserver {
    func brandingDidChange(_ previousBranding: OpenpayBranding) {}
}
