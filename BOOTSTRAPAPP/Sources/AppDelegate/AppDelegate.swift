//
//  AppDelegate.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private final let app = App()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return app.boot(application, launchOptions: launchOptions)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return app.run(application, launchOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        app.willResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        app.didEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        app.willEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        app.didBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        app.willTerminate()
    }

}

