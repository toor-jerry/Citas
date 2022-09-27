//
//  LoginViewController.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit
import PasswordTextField
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD
import GTProgressBar

class LoginViewController: UIViewController {

    var presenter: LoginPresenterProtocols?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius=12
        field.layer.borderWidth=1
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwdField: PasswordTextField = {
        let field = PasswordTextField()
        field.imageTintColor = .systemPink
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius=12
        field.layer.borderWidth=1
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let progressBar: GTProgressBar = {
        let progressBar = GTProgressBar(frame: CGRect(x: 0, y: 0, width: 300, height: 15))
        progressBar.progress = 0
        progressBar.barBorderColor = .lightGray
        progressBar.barFillColor = .lightGray
        progressBar.barBackgroundColor = .systemGray4
        progressBar.barBorderWidth = 1
        progressBar.barFillInset = 0
        progressBar.barMaxHeight = 22
        progressBar.displayLabel = false
        return progressBar
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    
    private let googleLogInButton = GIDSignInButton()

    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                              action: #selector(showRegisterView),
                              for: .touchUpInside)
        passwdField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailField.delegate = self
        passwdField.delegate = self
        facebookLoginButton.delegate = self
        // emailField.text = "gerarchicharo37@gmail.com"
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwdField)
        scrollView.addSubview(progressBar)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLogInButton)
        googleLogInButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)
        
    }
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame=view.bounds
        let size = scrollView.width/3
        imageView.frame=CGRect(x:(scrollView.width-size)/2,
                               y: 120,
                               width: size,
                               height: size)
        emailField.frame = CGRect(x: 30,
                                   y: imageView.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        
        passwdField.frame = CGRect(x: 30,
                                   y: emailField.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        progressBar.frame = CGRect(x: 30,
                                   y: passwdField.bottom+10,
                                   width:scrollView.width-60,
                                   height: 25)
        loginButton.frame = CGRect(x: 30,
                                   y: progressBar.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        registerButton.frame = CGRect(x: 30,
                                   y: loginButton.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        facebookLoginButton.frame = CGRect(x: 30,
                                   y: registerButton.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)

        googleLogInButton.frame = CGRect(x: 30,
                                   y: facebookLoginButton.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
    }
        
        @objc private func googleSignInButtonTapped() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let signInConfig = appDelegate.signInConfig else {
                return
            }
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard let user = user, error == nil else { return }
                appDelegate.handleSessionRestore(user: user)
            }
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            if let text = textField.text {
                let result = text.checkNivelSecurityPassword()
                progressBar.barBorderColor = result.barBorderColor
                progressBar.barFillColor = result.barFillColor
                progressBar.barBackgroundColor = result.barBackgroundColor
                self.progressBar.progress = result.nivelSecurity
            }
        }
    
    @objc private func loginButtonTapped() {
        emailField.resignFirstResponder()
        passwdField.resignFirstResponder()
        guard let email = emailField.text, let pwd = passwdField.text,
              !email.isEmpty, !pwd.isEmpty else {
            alertUserLoginError(message: "Complete por favor todos los campos requeridos.")
            return
        }
        
        if !email.validarEmail() {
            alertUserLoginError(message: "Complete por favor todos los campos requeridos.")
            return
        }
    
        if passwdField.isInvalid() {
            alertUserLoginError(message: "Por favor valide la seguridad de su contraseña.\n Su contraseña debe contener una longitud minima de 8 carácteres, una letra mayúscula y un número.")
            return
        }
        
        spinner.show(in: view)
        
        // Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pwd, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }

            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }

            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }

            let user = result.user

            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                        let firstName = userData["first_name"] as? String,
                        let lastName = userData["last_name"] as? String else {
                            return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })

            UserDefaults.standard.set(email, forKey: "email")

            print("Logged In User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc private func showRegisterView() {
        var viewController = PageErrorRouter.createModuls()
        if let viewC = RegisterRouter.createModuls() as? RegisterViewController {
            viewController = viewC
        }
        self.present(viewController, animated: true)
    }
    
}

extension LoginViewController: LoginViewProtocols { }

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwdField.becomeFirstResponder()
        }
        else if textField == passwdField {
            loginButtonTapped()
        }
        
        return true
    }
    
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }

        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields":
                                                            "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)

        facebookRequest.start {
            (connection, result, error) -> Void in
            guard let result = result as? [String: Any],
                error == nil else {
                    print("Failed to make facebook graph request")
                    return
            }

            print(result)

            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
                let pictureUrl = data["url"] as? String else {
                    print("Faield to get email and name from fb result")
                    return
            }

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {

                            guard let url = URL(string: pictureUrl) else {
                                return
                            }

                            print("Downloading data from facebook image")

                            URLSession.shared.dataTask(with: url, completionHandler: { data, _,_ in
                                guard let data = data else {
                                    print("Failed to get data from facebook")
                                    return
                                }

                                print("got data from FB, uploading...")

                                // upload iamge
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
                    })
                }
            })

            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }

                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed - \(error)")
                    }
                    return
                }

                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
    }

}
