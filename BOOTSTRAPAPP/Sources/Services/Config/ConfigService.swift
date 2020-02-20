//
//  ConfigService.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import ViperServices

// MARK: - Service options

struct ConfigServiceOptions {
    
    enum SyncType {
        case offline    // config is not loaded
        case bootOnly   // config is loaded only when application boots
        case always     // config is loaded many times at the boot and while application life cycle
    }
    
    // Options
    let syncType: SyncType
    let url: URL?
    let fetchTimeout: TimeInterval
    let storageKey: String
    
    // Defaults
    static let defaultFetchTimeout: TimeInterval = 3.0
    static let defaultStorageKey = "APPCFG"
    
    init(syncType: SyncType = .bootOnly, url: URL? = nil, fetchTimeout: TimeInterval = ConfigServiceOptions.defaultFetchTimeout, storageKey: String = ConfigServiceOptions.defaultStorageKey) {
        self.syncType = syncType
        self.url = url
        self.fetchTimeout = fetchTimeout
        self.storageKey = storageKey
    }
}

// <EXAMPLE BEGIN>
enum IntEnumValue: Int, Codable {
    case zero = 0
    case one = 1
    case two = 2
}

enum StringEnumValue: String, Codable {
    case zero = "zero"
    case one = "one"
    case two = "two"
}
// <EXAMPLE END>

// MARK: - Enum values
// DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
// <Register new config enum here>


// MARK: - Notifications

extension Notification.Name {
    static let ConfigServiceDidChangeValue = Notification.Name("ConfigServiceDidChangeValueNotification")
}

// MARK: - Protocols

protocol ConfigValues {
    
    // <EXAMPLE BEGIN>
    var boolValue: Bool { get }
    var intValue: Int { get }
    var doubleValue: Double { get }
    var stringValue: String { get }
    var intEnumValue: IntEnumValue { get }
    var stringEnumValue: StringEnumValue { get }
    // <EXAMPLE END>
    
    // MARK: - Values
    // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
    // <Register new config property here>
    
}

protocol ConfigService: class {
    
    // Opions passed to initializer
    var options: ConfigServiceOptions { get }
    
    // Init
    init(options: ConfigServiceOptions)
    
    // Manual update
    func update()
    
    // Values snapshot
    func valuesSnapshot() -> ConfigValues
}
