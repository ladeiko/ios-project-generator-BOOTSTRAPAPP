//
//  AnalyticsService.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation

protocol AnalyticsService: class {
    
    func logEvent(_ event: AnalyticsEvent)
    func logPurchase(transactionId: String, productId: String, isTrial: Bool, revenue: Double, currency: String)
    
}
