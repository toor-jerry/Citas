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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        registerButton.addTarget(self,
                              action: #selector(showRegisterView),
                              for: .touchUpInside)
        passwdField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailField.delegate = self
        passwdField.delegate = self
        // emailField.text = "gerarchicharo37@gmail.com"
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwdField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
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
        loginButton.frame = CGRect(x: 30,
                                   y: passwdField.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        registerButton.frame = CGRect(x: 30,
                                   y: loginButton.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
    }

        @objc func textFieldDidChange(_ textField: UITextField) {
            var nivelSecurity = 0
            if let text = textField.text {
                if text.count >= 8 {
                    nivelSecurity += 1
                }
                
                if text.range(of: "[0-9]", options: .regularExpression) != nil{
                    nivelSecurity += 1
                }
                
                if text.range(of: "[A-Z]", options: .regularExpression) != nil {
                    nivelSecurity += 1
                }
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
