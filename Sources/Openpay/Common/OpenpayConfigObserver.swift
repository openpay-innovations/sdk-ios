//
//  OpenpayConfigObserver.swift
//  Openpay
//
//  Created by june chen on 7/4/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

/// A type that can observe changes to the Openpay configurations such as branding.
public protocol OpenpayConfigObserver: AnyObject {
    func brandingDidChange(_ previousBranding: OpenpayBranding)
}

public extension OpenpayConfigObserver {
    func brandingDidChange(_ previousBranding: OpenpayBranding) {}
}
