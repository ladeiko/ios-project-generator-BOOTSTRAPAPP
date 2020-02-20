//
//  AppStateService.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation

protocol AppStateService: class {

    // Currently running application version (CFBundleShortVersionString)
    var currentVersion: String { get }
    
    // Contains all applications versions (CFBundleShortVersionString)
    var allVersions: Set<String> { get }
    
    // It is true, when this application launch was first after new version was installed
    var upgraded: Bool { get }
    
    // TODO: Place your code here
}

