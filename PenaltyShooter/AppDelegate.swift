//
//  AppDelegate.swift
//  PenaltyShooter
//
//  Created by Branislav on 17/02/2021.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
            if #available(iOS 13, *) {
                // do only pure app launch stuff, not interface stuff
            } else {
                window = UIWindow()
                let viewController = MainViewController()
                if let window = window {
                    window.rootViewController = viewController
                    window.makeKeyAndVisible()
                    window.backgroundColor = .red
                }
            }
            return true
    }
}
