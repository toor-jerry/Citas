//
//  ConversationsRouter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

class ConversationsRouter: ConversationsRouterProtocols {
    static func createModuls(titleNav: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Conversations", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "Conversations") as? ConversationsViewProtocols else {
            return UIViewController()
        }
        let presenter: ConversationsPresenterProtocols & ConversationsInteractorOutputProtocols = ConversationsPresenter()
        let interactor: ConversationsInteractorInputProtocols = ConversationsInteractor()
        let router: ConversationsRouterProtocols = ConversationsRouter()
        
        // Conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        guard let viewUI = view as? ConversationsViewController else {
            return UIViewController()
        }
        return viewUI
    }
}
