//
//  ConfigServiceValueDescriptors.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation

class ConfigServiceValue {
    
    enum Behavior {
        case regular
        case once // value will not be overriden with new one, set only once
    }
    
    let name: ConfigServiceValueKey
    let behavior: Behavior
    
    init(name: ConfigServiceValueKey, behavior: Behavior = .regular) {
        self.name = name
        self.behavior = behavior
    }
    
    func get(_ rawValue: Any?) -> Any {
        fatalError()
    }
}

class ConfigServiceValueDescriptor<T>: ConfigServiceValue {
    
    typealias ValueType = T
    
    let defaultValue: ValueType
    
    init(name: ConfigServiceValueKey, behavior: Behavior = .regular, defaultValue: ValueType) {
        self.defaultValue = defaultValue
        super.init(name: name, behavior: behavior)
    }
    
    func normalize(_ rawValue: Any?) -> ValueType {
        return (rawValue as? ValueType) ?? defaultValue
    }
    
    override func get(_ rawValue: Any?) -> Any {
        return normalize(rawValue)
    }
}

class ConfigServiceBoolValueDescriptor: ConfigServiceValueDescriptor<Bool> {
    
    override func get(_ rawValue: Any?) -> Any {
        return normalize(rawValue)
    }
}

class ConfigServiceIntValueDescriptor: ConfigServiceValueDescriptor<Int> {
    
    let minimum: ValueType
    let maximum: ValueType
    
    init(name: ConfigServiceValueKey, behavior: Behavior = .regular, defaultValue: ValueType = 0, minimum: ValueType = ValueType.min, maximum: ValueType = ValueType.max) {
        self.minimum = minimum
        self.maximum = maximum
        super.init(name: name, behavior: behavior, defaultValue: defaultValue)
    }
    
    override func normalize(_ rawValue: Any?) -> ValueType {
        let value = super.normalize(rawValue)
        return max(self.minimum, min(self.maximum, value))
    }
    
    override func get(_ rawValue: Any?) -> Any {
        return normalize(rawValue)
    }
}

class ConfigServiceDoubleValueDescriptor: ConfigServiceValueDescriptor<Double> {
    
    let minimum: ValueType
    let maximum: ValueType
    
    init(name: ConfigServiceValueKey, behavior: Behavior = .regular, defaultValue: ValueType = 0, minimum: ValueType = -ValueType.greatestFiniteMagnitude, maximum: ValueType = ValueType.greatestFiniteMagnitude) {
        self.minimum = minimum
        self.maximum = maximum
        super.init(name: name, behavior: behavior, defaultValue: defaultValue)
    }
    
    override func normalize(_ rawValue: Any?) -> ValueType {
        let value = super.normalize(rawValue)
        return max(self.minimum, min(self.maximum, value))
    }
    
    override func get(_ rawValue: Any?) -> Any {
        return normalize(rawValue)
    }
}

class ConfigServiceStringValueDescriptor: ConfigServiceValueDescriptor<String> {
    
    let allowed: Set<ValueType>?
    
    init(name: ConfigServiceValueKey, behavior: Behavior = .regular, defaultValue: ValueType, allowed: Set<ValueType>? = nil) {
        self.allowed = allowed
        super.init(name: name, behavior: behavior, defaultValue: defaultValue)
    }
    
    override func normalize(_ rawValue: Any?) -> ValueType {
        let value = super.normalize(rawValue)
        if let allowed = allowed, !allowed.contains(value) {
            return defaultValue
        }
        return value
    }
    
    override func get(_ rawValue: Any?) -> Any {
        return normalize(rawValue)
    }
}

class ConfigServiceEnumValueDescriptor<T: RawRepresentable>: ConfigServiceValueDescriptor<T> {
    
    override func get(_ rawValue: Any?) -> Any {
        if let value = rawValue as? T {
            return normalize(value)
        }
        let raw = rawValue as? T.RawValue
        return normalize(raw != nil ? T.init(rawValue: raw!) : nil)
    }
}
