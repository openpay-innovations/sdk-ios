//
//  ObservationTests.swift
//  OpenpayTests
//
//  Created by june chen on 7/4/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

@testable import Openpay
import XCTest

class ObservationTests: XCTestCase {

    class Observer: OpenpayConfigObserver {
        var previousLocale: OpenpayLocale?

        init() {
            Openpay.addObserver(self)
        }

        func localeDidChange(_ previousLocale: OpenpayLocale) {
            self.previousLocale = previousLocale
        }
    }

    private var observer: Observer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        observer = Observer()
    }

    func test_localeDidChange() throws {
        XCTAssertNil(observer.previousLocale)

        Openpay.setLocale(.australia)
        XCTAssertEqual(observer.previousLocale, .australia)

        Openpay.setLocale(.unitedStates)
        XCTAssertEqual(observer.previousLocale, .australia)
    }
}
