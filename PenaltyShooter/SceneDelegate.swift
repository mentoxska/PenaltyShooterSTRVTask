//
//  SceneDelegate.swift
//  PenaltyShooter
//
//  Created by Branislav on 17/02/2021.
//
import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            if let windowScene = scene as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
                let viewController = MainViewController()
                if let window = window {
                    window.rootViewController = viewController
                    window.makeKeyAndVisible()
                    window.backgroundColor = .red
                }
            }
    }
}
