//
//  MainRouter.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit

class MainRouter: MainRouterProtocols {
    static func createModul() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewProtocols
        let presenter: MainPresenterProcol & MainInteractorOutputProtocols = MainPresenter()
        var interactor: MainInteractorInputProtocols = MainInteractor()
        let router: MainRouterProtocols = MainRouter()
        
        // conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view as! UIViewController
        
    }
    
    func pushScreen() -> UIViewController {
        return PerfilUserRouter.createModuls()
    }
    
    func getStoryBoard() -> UIStoryboard {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }
}
