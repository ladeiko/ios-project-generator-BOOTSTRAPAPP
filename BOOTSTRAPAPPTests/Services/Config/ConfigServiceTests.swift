//
//  ConfigServiceTests.swift
//  BOOTSTRAPAPPTests
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import XCTest
@testable import BOOTSTRAPAPP

import ViperServices
import OHHTTPStubs

fileprivate class ConfigEventListener: NSObject {
    
    private var called = false
    let expectation: XCTestExpectation
    
    init(_ target: Any, expectation: XCTestExpectation) {
        self.expectation = expectation
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.listen), name: .ConfigServiceDidChangeValue, object: target)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    @objc
    func listen() {
        guard called == false else {
            return
        }
        called = true
        expectation.fulfill()
    }
}

class ConfigServiceTests: XCTestCase {
    
    let fakeHost = "http://some-unknown-domain.com"
    
    override func setUp() {
        continueAfterFailure = false
        super.setUp()
    }
    
    // <EXAMPLE BEGIN>
    func testDefaults() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)

        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            return OHHTTPStubsResponse(data: Data(), statusCode: 502, headers: nil)
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        let configService = ConfigServiceImpl(options: options) as ConfigService
        try! containter.register(configService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testBool() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "boolValue": true
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == true)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
        
        let offlineContainter = DefaultViperServicesContainer()
        let offlineOptions = ConfigServiceOptions(syncType: .offline)
        try! offlineContainter.register(ConfigServiceImpl(options: offlineOptions) as ConfigService)
        let offlineService = offlineContainter.resolve() as ConfigService
        
        let offlineBootExpectation = XCTestExpectation(description: "offline boot")
        var offlineBootSucceeded = false
        
        offlineContainter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                offlineBootSucceeded = true
            default: break
            }
            offlineBootExpectation.fulfill()
        }
        
        wait(for: [offlineBootExpectation], timeout: 10)
        XCTAssert(offlineBootSucceeded)
        
        XCTAssert(offlineService.valuesSnapshot().boolValue == true)
    }
    
    func testLowecasedBool() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "boolvalue": true
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == true)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testDashedBool() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "bool-value": true
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == true)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testUnderscoredBool() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "bool_value": true
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == true)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testInt() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let testValue: Int = Int(truncatingIfNeeded: arc4random())
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "intValue": testValue
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == testValue)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testDouble() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let testValue: Double = Double(arc4random())
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "doubleValue": testValue
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == testValue)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testString() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let testValue: String = "HELLO"
        
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "stringValue": testValue
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == testValue)
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testIntEnum() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let testValue: IntEnumValue = .two
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "intEnumValue": testValue.rawValue
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == testValue)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .zero)
    }
    
    func testStringEnum() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let testValue: StringEnumValue = .two
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            let config: [String: Any] = [
                "stringEnumValue": testValue.rawValue
            ]
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        try! containter.register(ConfigServiceImpl(options: options) as ConfigService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == .two)
    }
    
    func testNotification() {
        
        let options = ConfigServiceOptions(syncType: .bootOnly, url: URL(string: fakeHost)!, fetchTimeout: 1.0)
        
        UserDefaults.standard.removeObject(forKey: options.storageKey)
        
        let initialTestValue: StringEnumValue = .two
        let urlComponents = URLComponents(url: URL(string: fakeHost)!, resolvingAgainstBaseURL: false)!

        var config: [String: Any] = [
            "stringEnumValue": initialTestValue.rawValue
        ]
        
        let stubDescriptor = stub(condition: isHost(urlComponents.host!) && isMethodGET()) { req in
            return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: config, options: .init(rawValue: 0)),
                                       statusCode: 200, headers: [ "Content-Type" : "application/json" ])
        }
        
        defer {
            UserDefaults.standard.removeObject(forKey: options.storageKey)
            OHHTTPStubs.removeStub(stubDescriptor)
        }
        
        let containter = DefaultViperServicesContainer()
        
        let configService = ConfigServiceImpl(options: options) as ConfigService
        try! containter.register(configService)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        var succeeded = false
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                succeeded = true
            default: break
            }
            bootExpectation.fulfill()
        }
        
        wait(for: [bootExpectation], timeout: 10)
        XCTAssert(succeeded)
        
        let service = containter.resolve() as ConfigService
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == initialTestValue)
        
        let secondTestValue: StringEnumValue = .one
        
        config = [
            "stringEnumValue": secondTestValue.rawValue
        ]
        
        configService.update()
        
        let notificationExpectation = XCTestExpectation(description: "notify")
        let listener = ConfigEventListener(configService, expectation: notificationExpectation)
        
        wait(for: [notificationExpectation], timeout: 10)
        
        XCTAssert(service.valuesSnapshot().boolValue == false)
        XCTAssert(service.valuesSnapshot().intValue == 0)
        XCTAssert(service.valuesSnapshot().doubleValue == 0)
        XCTAssert(service.valuesSnapshot().stringValue == "")
        XCTAssert(service.valuesSnapshot().intEnumValue == .zero)
        XCTAssert(service.valuesSnapshot().stringEnumValue == secondTestValue)
        
        DispatchQueue.main.async { _ = listener.description } // ensure life of object
    }
    // <EXAMPLE END>
    
}
