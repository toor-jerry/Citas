//
//  PerfilUserRouter.swift
//  Citas
//
//  Created by user216116 on 08/08/22.
//
import UIKit

class PerfilUserRouter: PerfilUserRouterProtocols {
    static func createModuls() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "PerfilUser") as? PerfilUserViewProtocols else {
            return UIViewController()
        }
        let presenter: PerfilUserPresenterProtocols & PerfilUserInteractorOutputProtocols = PerfilUserPresenter()
        let interactor: PerfilUserInteractorInputProtocols = PerfilUserInteractor()
        let router: PerfilUserRouterProtocols = PerfilUserRouter()
        
        // Conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        guard let viewUI = view as? PerfilUserViewController else {
            return UIViewController()
        }
        return viewUI
    }
}
