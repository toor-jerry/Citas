//
//  MainRouter.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit

class MainRouter: MainRouterProtocols {
    
    static func createModul() -> UIViewController {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(withIdentifier: "Main") as? MainViewProtocols else {
            return UIViewController()
        }
        
        let presenter: MainPresenterProcol & MainInteractorOutputProtocols = MainPresenter()
        var interactor: MainInteractorInputProtocols = MainInteractor()
        let router: MainRouterProtocols = MainRouter()
        
        // conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        guard let viewUI = view as? UIViewController else {
        return UIViewController()
        }
        return viewUI
    }

    func pushScreen() -> UIViewController {
        return PerfilUserRouter.createModuls()
    }

    func getStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func showProfile() -> UIViewController {
        return PerfilUserRouter.createModuls()
    }
    
    func showChat() -> UIViewController {
        return ChatRouter.createModuls(titleNav: "Name")
    }
}
