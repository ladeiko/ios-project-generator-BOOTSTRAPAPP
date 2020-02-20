//
//  DatabaseService.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import CoreData

typealias DatabaseServiceVoidAction = (_ context: NSManagedObjectContext) -> Void
typealias DatabaseServiceVoidActionCompletion = (_ error: Error?) -> Void
typealias DatabaseServiceResultAction = (_ context: NSManagedObjectContext) -> Any?
typealias DatabaseServiceResultActionCompletion = (_ error: Error?, _ result: Any?) -> Void

enum DatabaseServiceError: Error {
    case shutdownInProgress
}

protocol DatabaseService: class {
    
    var uiContext: NSManagedObjectContext { get }
    
    func exec(action: @escaping DatabaseServiceVoidAction)
    func exec(action: @escaping DatabaseServiceVoidAction, _ completion: @escaping DatabaseServiceVoidActionCompletion)
    func exec(action: @escaping DatabaseServiceResultAction)
    func exec(action: @escaping DatabaseServiceResultAction, _ completion: @escaping DatabaseServiceResultActionCompletion)
    
    // TODO: Place your code here
    
}

extension DatabaseService {
    
    func exec(action: @escaping DatabaseServiceVoidAction) {
        exec(action: action) { _ in }
    }
    
    func exec(action: @escaping DatabaseServiceResultAction) {
        exec(action: action) { _, _ in }
    }
    
}
