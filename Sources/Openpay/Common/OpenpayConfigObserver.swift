//
//  OpenpayConfigObserver.swift
//  Openpay
//
//  Created by june chen on 7/4/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

public protocol OpenpayConfigObserver: AnyObject {
    func localeDidChange(_ previousLocale: OpenpayLocale)
}

public extension OpenpayConfigObserver {
    func localeDidChange(_ previousLocale: OpenpayLocale) {}
}
