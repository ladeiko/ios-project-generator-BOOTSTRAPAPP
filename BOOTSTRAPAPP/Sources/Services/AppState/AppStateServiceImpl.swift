//
//  AppStateServiceImpl.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation
import ViperServices

class AppStateServiceImpl: ViperService, AppStateService {
    
    // MARK: - Vars
    
    private let userDefaultsKey = "allVersions"
    
    // MARK: - ViperService
    
    func setupDependencies(_ container: ViperServicesContainer) -> [AnyObject]? {
        // TODO: Place your code here
        return nil
    }
    
    func boot(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, completion: @escaping ViperServiceBootCompletion) {
        loadAppVersions()
        completion(.succeeded)
    }
    
    func shutdown(completion: @escaping ViperServiceShutdownCompletion) {
        completion()
    }
    
    // MARK: - AppStateService
    
    let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    var allVersions: Set<String> = Set<String>()
    var upgraded = false
    
    // TODO: Place your code here
    
    // MARK: - Helpers
    
    private func loadAppVersions() {
        allVersions = (UserDefaults.standard.string(forKey: userDefaultsKey) ?? "")
            .split(separator: ",")
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .filter({ $0.count != 0 })
            .reduce(into: Set<String>(), { $0.insert($1) })
        upgraded = !allVersions.isEmpty && !allVersions.contains(currentVersion)
        allVersions.insert(currentVersion)
        UserDefaults.standard.set(allVersions.joined(separator: ","), forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
}
