//
//  BOOTSTRAPAPPUITests.swift
//  BOOTSTRAPAPPUITests
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import XCTest

class BOOTSTRAPAPPUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // <EXAMPLE BEGIN>
    func testAlertShowing() {
        XCTAssertTrue(XCUIApplication().buttons["Test Button"].waitForExistence(timeout: 5))
        XCUIApplication().buttons["Test Button"].tap()
        XCTAssertTrue(XCUIApplication().alerts["Test Alert"].waitForExistence(timeout: 5))
        XCUIApplication().buttons["Alert Button"].tap()
        XCTAssertTrue(XCUIApplication().alerts["Test Alert"].waitForDisappearance(timeout: 5))
    }
    // <EXAMPLE END>
    
}
