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

        // Apenas arranque mandará a llamar la vista principal
        var viewController = PageErrorRouter.createModuls()
        if let viewC = LoginRouter.createModuls() as? LoginViewController {
            viewController = viewC
        } else {
            if let viewC = LoginRouter.createModuls() as? MainView {
                viewController = viewC
            }
        }
            self.window = UIWindow()
            let screen: UIScreen = UIScreen.main
            self.window?.frame = screen.bounds
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()

        return true
    }
}
