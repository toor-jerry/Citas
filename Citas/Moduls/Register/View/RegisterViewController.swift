//
//  RegisterViewController.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit
import PasswordTextField
import FirebaseAuth
import JGProgressHUD
import GTProgressBar

class RegisterViewController: UIViewController {

    var presenter: RegisterPresenterProtocols?
    
    public let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    public let firstNameField: UITextField = {
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
    
    public let lastNameField: UITextField = {
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
    
    public let emailField: UITextField = {
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
    
    public let passwdField: PasswordTextField = {
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
        passwdField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailField.delegate = self
        passwdField.delegate = self
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwdField)
        scrollView.addSubview(progressBar)
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
        
        imageView.layer.cornerRadius = imageView.width/2.0
        
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
        progressBar.frame = CGRect(x: 30,
                                   y: passwdField.bottom+10,
                                   width:scrollView.width-60,
                                   height: 25)
        registerButton.frame = CGRect(x: 30,
                                   y: progressBar.bottom+10,
                                   width:scrollView.width-60,
                                   height:52)
    }
    
    @objc private func didChangeImage() {
        presentPhotoActionSheet()
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
}
