//
//  LoginViewController.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit

class LoginViewController: UIViewController {

    var presenter: LoginPresenterProtocols?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension LoginViewController: LoginViewProtocols { }
