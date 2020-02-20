//
//  AnalyticsServiceImpl.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import Foundation
import ViperServices
// import FBSDKCoreKit

class AnalyticsServiceImpl: ViperService, AnalyticsService {
    
    // MARK: - ViperService
    
    func setupDependencies(_ container: ViperServicesContainer) -> [AnyObject]? {
        // TODO: Place your code here
        return [
            container.resolve() as ConfigService,
            container.resolve() as AppStateService,
        ]
    }
    
    func boot(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, completion: @escaping ViperServiceBootCompletion) {
        // TODO: Place your code here
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        completion(.succeeded)
    }
    
    func shutdown(completion: @escaping ViperServiceShutdownCompletion) {
        NotificationCenter.default.removeObserver(self)
        completion()
    }
    
    // MARK: - AnalyticsService
 
    func logEvent(_ event: AnalyticsEvent) {
        
        guard !event.ignored() else {
            return;
        }
        
        // TODO: Place your code here
        
        // Log to any system you want, e.g:
        //
        // let value = event.value()
        // FBSDKAppEvents.logEvent(value.name, parameters: value.params)
    }
    
    func logPurchase(transactionId: String, productId: String, isTrial: Bool, revenue: Double, currency: String) {
        // TODO: Place your code here
        
        // Log to any system you want, e.g:
        // FBSDKAppEvents.logPurchase((isTrial ? 0.0 : revenue), currency: currency)
    }
    
    // MARK: - Observers
    
    @objc
    func didBecomeActive() {
        // FBSDKAppEvents.activateApp()
    }
}
