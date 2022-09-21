//
//  RegisterViewController.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit

class RegisterViewController: UIViewController {

    var presenter: RegisterPresenterProtocols?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius=12
        field.layer.borderWidth=1
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Primer nombre..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius=12
        field.layer.borderWidth=1
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Apellidos..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
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
    
    private let passwdField: UITextField = {
        let field = UITextField()
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
        
        registerButton.addTarget(self,
                              action: #selector(registerButtonTapped),
                              for: .touchUpInside)
        
        emailField.delegate = self
        passwdField.delegate = self
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwdField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didChangeImage))
        
        imageView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame=view.bounds
        let size = scrollView.width/3
        imageView.frame=CGRect(x:(scrollView.width-size)/2,
                               y: 30,
                               width: size,
                               height: size)
        firstNameField.frame = CGRect(x: 30,
                                   y: imageView.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        lastNameField.frame = CGRect(x: 30,
                                   y: firstNameField.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        emailField.frame = CGRect(x: 30,
                                   y: lastNameField.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        
        passwdField.frame = CGRect(x: 30,
                                   y: emailField.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
        registerButton.frame = CGRect(x: 30,
                                   y: passwdField.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
    }
    
    @objc private func didChangeImage() {
        print("Chaneg")
    }
    
    @objc private func registerButtonTapped() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwdField.resignFirstResponder()
        guard let firstName = firstNameField.text, let lastName = lastNameField.text, let email = emailField.text, let pwd = passwdField.text, !firstName.isEmpty, !lastName.isEmpty,
              !email.isEmpty, !pwd.isEmpty, pwd.count >= 6 else {
            alertUserLoginError()
            return
        }
        // Firebase Log In
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message:
                                        "Please enter all informat",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension RegisterViewController: RegisterViewProtocols { }

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwdField.becomeFirstResponder()
        }
        else if textField == passwdField {
            registerButtonTapped()
        }
        
        return true
    }
    
}
