//
//  AnalyticsEventsImpl.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation

class AnalyticsEventDescription {
    let name: String
    let params: Dictionary<String, String>?
    
    init(name: String, params: Dictionary<String, String>? = nil) {
        self.name = name
        self.params = params
    }
}

protocol AnalyticsEventDescriptionConvertible {
    func value() -> AnalyticsEventDescription
}


extension AnalyticsEvent: AnalyticsEventDescriptionConvertible {
    
    typealias RawValue = String
    
    func value() -> AnalyticsEventDescription {
        switch self {
            
        case let .exampleEvent(exampleParam):
            return AnalyticsEventDescription(name: "example", params: ["exampleParam": String(exampleParam)])
        }
    }
}

extension AnalyticsEvent {
    
    func ignored() -> Bool {
        switch self {
        default: return false
            // TODO: Place your code here
            // Add ignored events here, e.g: case myEvent: return true
        }
    }
    
}
