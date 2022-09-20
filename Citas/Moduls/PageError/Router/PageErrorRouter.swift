//
//  PageErrorRouter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

class PageErrorRouter: PageErrorRouterProtocols {
    static func createModuls() -> UIViewController {
        let storyboard = UIStoryboard(name: "PageError", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "PageError") as? PageErrorViewProtocols else {
            return UIViewController()
        }
        let presenter: PageErrorPresenterProtocols & PageErrorInteractorOutputProtocols = PageErrorPresenter()
        let interactor: PageErrorInteractorInputProtocols = PageErrorInteractor()
        let router: PageErrorRouterProtocols = PageErrorRouter()
        
        // Conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        guard let viewUI = view as? PageErrorViewController else {
            NSLog("Error: No se pudo obtener el Storyboard 'PageError'")
            return UIViewController()
        }
        return viewUI
    }
}
