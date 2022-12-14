//
//  AppDelegate.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FBSDKCoreKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public var signInConfig: GIDConfiguration?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        // Firebase
        FirebaseApp.configure()

        // Apenas arranque mandarĂ¡ a llamar la vista principal
        let logoVC: LogoAnimationViewController = LogoAnimationViewController()
        self.window = UIWindow()
        let screen: UIScreen = UIScreen.main
        self.window?.frame = screen.bounds

        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let user = user, error == nil {
                self?.handleSessionRestore(user: user)
            }
        }

        if let clientId = FirebaseApp.app()?.options.clientID {
            signInConfig = GIDConfiguration.init(clientID: clientId)
        }

        self.window?.rootViewController = logoVC
        self.window?.makeKeyAndVisible()
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
    }

    func handleSessionRestore(user: GIDGoogleUser) {
        guard let email = user.profile?.email,
            let firstName = user.profile?.givenName,
            let lastName = user.profile?.familyName else {
                return
        }

        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                // insert to database
                let chatUser = User(
                    firstName: firstName,
                    lastName: lastName,
                    emailAddress: email
                )
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // upload image

                        if user.profile?.hasImage != nil {
                            guard let url = user.profile?.imageURL(withDimension: 200) else {
                                return
                            }

                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                guard let data = data else {
                                    return
                                }

                                let filename = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage maanger error: \(error)")
                                    }
                                })
                            }).resume()
                        }
                    }
                })
            }
        })

        let authentication = user.authentication
        guard let idToken = authentication.idToken else {
            return
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: authentication.accessToken
        )

        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("failed to log in with google credential")
                return
            }

            print("Successfully signed in with Google cred.")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
}
