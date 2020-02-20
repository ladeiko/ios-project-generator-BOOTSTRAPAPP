//
//  DatabaseServiceImpl.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import ViperServices
import MagicalRecord

class DatabaseServiceImpl: ViperService, DatabaseService {
    
    private var isShuttingDown = false
    private var queue: OperationQueue!
    private var mainContext: NSManagedObjectContext!
    private var workContext: NSManagedObjectContext!
    
    // MARK: - ViperService

    func setupDependencies(_ container: ViperServicesContainer) -> [AnyObject]? {
        // TODO: Place your code here
        
        var deps = [AnyObject]()

        if let service = container.tryResolve() as ConfigService? {
            deps.append(service)
        }
        
        if let service = container.tryResolve() as AppStateService? {
            deps.append(service)
        }
        
        return deps
    }

    func boot(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, completion: @escaping ViperServiceBootCompletion) {
        
        do {
            try ObjC.catchException {

                let model = "Model"
                
                MagicalRecord.setLoggingLevel(.off)
                MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: model)
                
                #if DEBUG
                if ProcessInfo.processInfo.arguments.contains("--coredata-in-memory") {
                    MagicalRecord.setupCoreDataStackWithInMemoryStore()
                }
                else {
                    MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: model)
                }
                #else
                MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: model)
                #endif
            }
        }
        catch {
            completion(.failed(error: error))
            return
        }
        
        mainContext = NSManagedObjectContext.mr_default()
        workContext = NSManagedObjectContext.mr_context(withParent: mainContext)
        
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        completion(.succeeded)
    }

    func shutdown(completion: @escaping ViperServiceShutdownCompletion) {
        
        objc_sync_enter(self); defer { objc_sync_exit(self)}
        
        isShuttingDown = true
        
        DispatchQueue.global().async {
            self.queue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                MagicalRecord.cleanUp()
                completion()
            }
        }
    }

    // MARK: - DatabaseService
    
    var uiContext: NSManagedObjectContext {
        assert(Thread.isMainThread)
        return mainContext
    }
    
    func exec(action: @escaping DatabaseServiceResultAction, _ completion: @escaping DatabaseServiceResultActionCompletion) {
        
        objc_sync_enter(self); defer { objc_sync_exit(self)}
        
        guard isShuttingDown == false else {
            DispatchQueue.global().async {
                completion(DatabaseServiceError.shutdownInProgress, nil)
            }
            return
        }
        
        queue.addOperation {
            do {
                let result = action(self.workContext)
                if self.workContext.hasChanges {
                    try self.workContext.save()
                }
                completion(nil, result)
            }
            catch {
                completion(error, nil)
            }
        }
        
    }
    
    func exec(action: @escaping DatabaseServiceVoidAction, _ completion: @escaping DatabaseServiceVoidActionCompletion) {
        
        objc_sync_enter(self); defer { objc_sync_exit(self)}
        
        guard isShuttingDown == false else {
            DispatchQueue.global().async {
                completion(DatabaseServiceError.shutdownInProgress)
            }
            return
        }
        
        queue.addOperation {
            do {
                action(self.workContext)
                if self.workContext.hasChanges {
                    try self.workContext.save()
                }
                completion(nil)
            }
            catch {
                completion(error)
            }
        }
        
    }
    
    // TODO: Place your code here

}
