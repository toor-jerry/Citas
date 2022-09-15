//
//  ChatRouter.swift
//  Citas
//
//  Created by 1058889 on 14/09/22.
//

import UIKit.UIViewController

class ChatRouter: ChatRouterProtocols {
    static func createModuls(titleNav: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
            withIdentifier: "Chat") as? ChatViewProtocols else {
            return UIViewController()
        }
        let presenter: ChatPresenterProtocols & ChatInteractorOutputProtocols = ChatPresenter()
        let interactor: ChatInteractorInputProtocols = ChatInteractor()
        let router: ChatRouterProtocols = ChatRouter()
        
        // Conexiones
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        guard let viewUI = view as? ChatViewController else {
            return UIViewController()
        }
        
        viewUI.setData(titleNav: titleNav)
        return viewUI
    }
}
