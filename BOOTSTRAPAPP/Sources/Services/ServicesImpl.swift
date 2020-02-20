//
//  ServicesImpl.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import ViperServices

class ServicesImpl: DefaultViperServicesContainer, Services {

    func registerAllServices() {
        
        // Builtin services
        try! register(ConfigServiceImpl(options: ConfigServiceOptions(url: RemoteConfigPath != nil ? URL(string: RemoteConfigPath!)! : nil)) as ConfigService)
        try! register(AppStateServiceImpl() as AppStateService)
        try! register(AnalyticsServiceImpl() as AnalyticsService)
        
        // <DATABASE_SERVICE_CODE BEGIN>
        try! register(DatabaseServiceImpl() as DatabaseService)
        // <DATABASE_SERVICE_CODE END>
        
        // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
        // <Register services here>

    }
        
    override func boot(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, completion: @escaping ViperServicesContainerBootCompletion) {
        registerAllServices()
        super.boot(launchOptions: launchOptions, completion: completion)
    }
    
    // MARK: - Services
    
    func terminate() {
        var complete = false
        shutdown { complete = true }
        while (!complete) { RunLoop.current.run(mode: RunLoop.Mode.default, before: Date.distantFuture) }
    }

}

