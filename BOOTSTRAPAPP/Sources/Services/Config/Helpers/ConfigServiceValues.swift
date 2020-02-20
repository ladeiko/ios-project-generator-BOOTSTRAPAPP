//
//  ConfigServiceValues.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation

// MARK: - Keys

enum ConfigServiceValueKey: String, Codable {
    
    init?(rawValue: String) {
        let normalizedRawValue = ConfigServiceValueKey.normalizeKey(rawValue)
        guard let match = ConfigServiceValuesDescriptors.filter({ ConfigServiceValueKey.normalizeKey($0.name.rawValue) == normalizedRawValue }).first?.name else {
            return nil
        }
        self = match
    }
    
    static func normalizeKey(_ key: String) -> String {
        return key
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
    }
    
    // <EXAMPLE BEGIN>
    case boolValue = "boolValue"
    case intValue = "intValue"
    case doubleValue = "doubleValue"
    case stringValue = "stringValue"
    case intEnumValue = "intEnumValue"
    case stringEnumValue = "stringEnumValue"
    // <EXAMPLE END>
    
    // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
    // <Register new config cases here>
    
}

// MARK: - Descriptions

let ConfigServiceValuesDescriptors: [ConfigServiceValue] = [
    
    // <EXAMPLE BEGIN>
    ConfigServiceBoolValueDescriptor(name: .boolValue, defaultValue: false),
    ConfigServiceIntValueDescriptor(name: .intValue, defaultValue: 0),
    ConfigServiceDoubleValueDescriptor(name: .doubleValue, defaultValue: 0),
    ConfigServiceStringValueDescriptor(name: .stringValue, defaultValue: ""),
    ConfigServiceEnumValueDescriptor<IntEnumValue>(name: .intEnumValue, defaultValue: .zero),
    ConfigServiceEnumValueDescriptor<StringEnumValue>(name: .stringEnumValue, defaultValue: .zero),
    // <EXAMPLE END>
    
    // DO NOT REMOVE THIS COMMENTS!!! Generator will use it as insertion point.
    // <Register new config descriptors here>
    
]
