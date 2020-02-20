//
//  App.swift
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class App {

    // MARK: - Vars
    
    private final var window: UIWindow!
    private final var services: Services!
    private final var servicesReady = false
    private final var readyToShowUI = false
    
    // MARK: - Public
    
    // Called from willFinishLaunchingWithOptions
    func boot(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let _ = Bundle.main.infoDictionary!["Fabric"] as? [String: Any] {
            Fabric.with([Crashlytics.self()])
        }

        services = ServicesImpl()
        window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = splashViewController()
        window.makeKeyAndVisible()

        services.boot(launchOptions: launchOptions, completion: { result in

            switch result {
                case .succeeded: break
                case .failed(_): break
            }
            
            self.servicesReady = true
            self.showUI()
        })
        
        return true
    }
    
    // Called from didFinishLaunchingWithOptions
    func run(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        readyToShowUI = true
        showUI()
        return true
    }

    func willTerminate() {
        services.terminate()
    }
    
    func willResignActive(_ application: UIApplication) {
        // TODO: Place your code here
    }
    
    func didEnterBackground(_ application: UIApplication) {
        // TODO: Place your code here
    }
    
    func willEnterForeground(_ application: UIApplication) {
        // TODO: Place your code here
    }
    
    func didBecomeActive(_ application: UIApplication) {
        // TODO: Place your code here
    }
    
    // MARK: - Helpers
    
    private func showUI() {
        guard readyToShowUI == true && servicesReady == true else {
            return
        }
        self.showMainController()
    }

    private final func showMainController() {
        let show = {
            let oldState: Bool = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window.rootViewController = self.rootViewController()
            UIView.setAnimationsEnabled(oldState)
        }
        
        if let mainAnimation = SplashAnimationType {
            DispatchQueue.main.async {
                let options: UIView.AnimationOptions = mainAnimation
                let duration: TimeInterval = SplashAnimationDuration
                UIView.transition(with: self.window, duration: duration, options: options, animations: {
                    show()
                }, completion: { _ in
                    // TODO
                })
            }
        }
        else {
            show()
        }
    }
        
    private final func rootViewController() -> UIViewController {
        // <DEFAULT ROOT CONTROLLER>return RootModuleConfigurator().create(with: RootModuleInputConfig(services: services))
        // <DEFAULT CONTROLLER BEGIN>
        let vc = UIViewController(); vc.view.backgroundColor = .white;
        // <EXAMPLE BEGIN>
        #if DEBUG
        let testButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        testButton.setTitle(NSLocalizedString("Test", comment: "Title for test button"), for: .normal)
        testButton.setTitleColor(.black, for: .normal)
        testButton.addTarget(self, action: #selector(testButtonClicked), for: .touchUpInside)
        testButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        vc.view.addSubview(testButton)
        testButton.center = CGPoint(x: testButton.superview!.bounds.midX, y: testButton.superview!.bounds.midY)
        testButton.layer.cornerRadius = 3
        testButton.layer.borderWidth = 1 / UIScreen.main.scale
        testButton.accessibilityIdentifier = "Test Button"
        #endif
        // <EXAMPLE END>
        return vc;
        // <DEFAULT CONTROLLER END>
    }
    
    // <EXAMPLE BEGIN>
    #if DEBUG
    @IBAction func testButtonClicked() {
        let alert = UIAlertController(title: "Test Alert", message: "Hello World", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Alert Button", style: .default, handler: nil))
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    #endif
    // <EXAMPLE END>

    private final func splashViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        return viewController
    }
}

