//
//  LoginRouter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

class LoginRouter: LoginRouterProtocols {
    static func createModuls() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "Login") as? LoginViewProtocols else {
            return UIViewController()
        }
        let presenter: LoginPresenterProtocols & LoginInteractorOutputProtocols = LoginPresenter()
        let interactor: LoginInteractorInputProtocols = LoginInteractor()
        let router: LoginRouterProtocols = LoginRouter()
        
        // Conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        guard let viewUI = view as? LoginViewController else {
            return UIViewController()
        }
        return viewUI
    }
}
