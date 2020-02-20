//
//  DatabaseServiceTests.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import XCTest
import ViperServices

class DatabaseServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBoot() {

        //given
        let launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        let container = DefaultViperServicesContainer()
        var failed: [ViperServiceBootFailureResult]?
        let bootExpect = expectation(description: "Boot expectation")

        //when
        XCTAssertNoThrow(try container.register(DatabaseServiceImpl() as DatabaseService))
        XCTAssertThrowsError(try container.register(DatabaseServiceImpl() as DatabaseService))

        //then
        XCTAssertNotNil(container.resolve() as DatabaseService)

        container.boot(launchOptions: launchOptions) { (result) in

            switch result {
            case .succeeded: break
            case .failed(let failedServices):
                failed = failedServices
            }

            bootExpect.fulfill()
        }

        wait(for: [bootExpect], timeout: 1.0)

        XCTAssertNil(failed)
        XCTAssertNotNil(container.resolve() as DatabaseService)
    }

}
