//
//  MainPresenter.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit

class MainPresenter: MainPresenterProcol, MainInteractorOutputProtocols {
    
    
    
    var router: MainRouterProtocols?
    var view: MainViewProtocols?
    var interactor: MainInteractorInputProtocols?
    
    func getUser() {
        interactor?.getUser()
    }
    
    func getGenderUser(genero: Int, usuarios: [UserEntity]) {
        interactor?.getGenderUser(genero: genero, usuarios: usuarios)
    }
    
    func pushScreen() -> UIViewController {
       let vc = UIViewController()
        return vc
    }
    
    func responseInteractor() {
        
    }
    
    func sendUser(user: [UserEntity]) {
        view?.createdTable(user: user)
    }
    
}
