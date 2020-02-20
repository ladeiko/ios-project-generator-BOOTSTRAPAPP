//
//  XCUIElement+Utils.swift
//  BOOTSTRAPAPPUITests
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import XCTest

extension XCUIElement {
    
    func waitForDisappearance(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        return result == .completed
    }
    
}
