//
//  AppDelegate.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        // Firebase
        FirebaseApp.configure()

        // Apenas arranque mandara a llamar la vista principal
        if let viewController = MainRouter.createModul() as? MainView {
            self.window = UIWindow()
            let screen: UIScreen = UIScreen.main
            self.window?.frame = screen.bounds
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        return true
    }
}
