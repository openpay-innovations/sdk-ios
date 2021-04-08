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
        var previousBranding: OpenpayBranding?

        init() {
            Openpay.addObserver(self)
        }

        func brandingDidChange(_ previousBranding: OpenpayBranding) {
            self.previousBranding = previousBranding
        }
    }

    private var observer: Observer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        observer = Observer()
    }

    func test_brandingDidChange() {
        XCTAssertNil(observer.previousBranding)
        Openpay.setBranding(.openpay)
        Openpay.setBranding(.opy)
        XCTAssertEqual(observer.previousBranding, .openpay)
        XCTAssertEqual(Openpay.branding, .opy)
    }
}
