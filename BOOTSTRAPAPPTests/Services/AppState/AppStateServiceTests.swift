//
//  AppStateServiceTests.swift
//  BOOTSTRAPAPPTests
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import XCTest
@testable import BOOTSTRAPAPP

import ViperServices

class AppStateServiceTests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
        super.setUp()
    }
    
    func testBasicVersionsState() {
        
        let version = "1.5"
        let userDefaultsAllVersionsKey = "allVersions"
        let containter = DefaultViperServicesContainer()

        UserDefaults.standard.removeObject(forKey: userDefaultsAllVersionsKey)
        Bundle.infoDictionaryCustomShortVersionString = version
        
        try! containter.register(AppStateServiceImpl() as AppStateService)
        
        XCTAssert(UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey) == nil)
        
        let bootExpectation = XCTestExpectation(description: "boot")
        
        containter.boot(launchOptions: nil) { (result) in
            switch result {
            case .succeeded:
                bootExpectation.fulfill()
            default: break
            }
        }
        
        wait(for: [bootExpectation], timeout: 10)

        let service = containter.resolve() as AppStateService
        
        let saved = UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey)
        XCTAssert(saved != nil)
        
        let savedAllVersions = saved!.split(separator: ",").map({ String($0) }).reduce(into: Set<String>(), { _ = $0.insert($1) })
        XCTAssert(Set<String>(savedAllVersions) == Set<String>([version]))
        
        XCTAssert(service.currentVersion == version)
        XCTAssert(service.allVersions == Set<String>([version]))
        
        Bundle.infoDictionaryCustomShortVersionString = nil
        
        UserDefaults.standard.removeObject(forKey: userDefaultsAllVersionsKey)
    }
    
    func testVersionsUpgrade() {
        
        let userDefaultsAllVersionsKey = "allVersions"
        
        let firstVersion = "1.1"
        let secondVersion = "1.5"
        
        UserDefaults.standard.removeObject(forKey: userDefaultsAllVersionsKey)
        
        let boot: () -> (container: ViperServicesContainer, service: AppStateService) = {
            
            let containter = DefaultViperServicesContainer()
            
            let prevValue = UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey)
            
            try! containter.register(AppStateServiceImpl() as AppStateService)
            
            XCTAssert(UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey) == prevValue)
            
            let bootExpectation = XCTestExpectation(description: "boot")
            
            containter.boot(launchOptions: nil) { (result) in
                switch result {
                case .succeeded:
                    bootExpectation.fulfill()
                default: break
                }
            }
            
            self.wait(for: [bootExpectation], timeout: 10)
            
            return (containter, containter.resolve() as AppStateService)
        }
        
        // Intial version
        Bundle.infoDictionaryCustomShortVersionString = firstVersion
        let (_, firstServiceInstance) = boot()
        
        let firstSaved = UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey)
        XCTAssert(firstSaved != nil)
        
        let firstSavedAllVersions = firstSaved!.split(separator: ",").map({ String($0) }).reduce(into: Set<String>(), { _ = $0.insert($1) })
        XCTAssert(Set<String>(firstSavedAllVersions) == Set<String>([firstVersion]))
        
        XCTAssert(firstServiceInstance.upgraded == false)
        XCTAssert(firstServiceInstance.currentVersion == firstVersion)
        XCTAssert(firstServiceInstance.allVersions == Set<String>([firstVersion]))
        
        // Change version
        Bundle.infoDictionaryCustomShortVersionString = secondVersion
        let (_, secondServiceInstance) = boot()
        
        let secondSaved = UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey)
        XCTAssert(secondSaved != nil)
        
        let secondSavedAllVersions = secondSaved!.split(separator: ",").map({ String($0) }).reduce(into: Set<String>(), { _ = $0.insert($1) })
        XCTAssert(Set<String>(secondSavedAllVersions) == Set<String>([firstVersion, secondVersion]))
        
        XCTAssert(secondServiceInstance.upgraded == true)
        XCTAssert(secondServiceInstance.currentVersion == secondVersion)
        XCTAssert(secondServiceInstance.allVersions == Set<String>([firstVersion, secondVersion]))
        
        // No version change
        let (_, thirdServiceInstance) = boot()
        
        let thirdSaved = UserDefaults.standard.string(forKey: userDefaultsAllVersionsKey)
        XCTAssert(thirdSaved != nil)
        
        let thirdSavedAllVersions = thirdSaved!.split(separator: ",").map({ String($0) }).reduce(into: Set<String>(), { _ = $0.insert($1) })
        XCTAssert(Set<String>(thirdSavedAllVersions) == Set<String>([firstVersion, secondVersion]))
        
        XCTAssert(thirdServiceInstance.upgraded == false)
        XCTAssert(thirdServiceInstance.currentVersion == secondVersion)
        XCTAssert(thirdServiceInstance.allVersions == Set<String>([firstVersion, secondVersion]))
        
        Bundle.infoDictionaryCustomShortVersionString = nil
        
        UserDefaults.standard.removeObject(forKey: userDefaultsAllVersionsKey)
    }
    
}
