//
//  RegisterRouter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

class RegisterRouter: RegisterRouterProtocols {
    static func createModuls() -> UIViewController {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "Register") as? RegisterViewProtocols else {
            return UIViewController()
        }
        let presenter: RegisterPresenterProtocols & RegisterInteractorOutputProtocols = RegisterPresenter()
        let interactor: RegisterInteractorInputProtocols = RegisterInteractor()
        let router: RegisterRouterProtocols = RegisterRouter()
        
        // Conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        guard let viewUI = view as? RegisterViewController else {
            return UIViewController()
        }
        return viewUI
    }
}
