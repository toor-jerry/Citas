//
//  MainProtocols.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

import UIKit

protocol MainViewProtocols: AnyObject {
    var presenter: MainPresenterProcol? {get set}
    
    // custom
    func showError()
    func showSuccess()
    func createdTable(user: [UserEntity])
}

protocol MainPresenterProcol: AnyObject {
    var router: MainRouterProtocols? {get set}
    var view: MainViewProtocols? {get set}
    var interactor: MainInteractorInputProtocols? {get set}
    
    // custom
    func getUser()
    func getGenderUser(genero: Int, usuarios: [UserEntity])
    func pushScreen() -> UIViewController
}

// Protocolo del segmento router del modulo Main
protocol MainRouterProtocols: AnyObject {
    
    static func createModul() -> UIViewController
    func pushScreen() -> UIViewController
    
}

protocol MainIntercatorProtocols {
    
}

protocol MainInteractorOutputProtocols {
    
    func responseInteractor()
    func sendUser(user: [UserEntity])
        
}

protocol MainInteractorInputProtocols {
    
    var presenter: MainInteractorOutputProtocols? {get set}
    
    // Custom
    func getUser()
    func getGenderUser(genero: Int, usuarios: [UserEntity])
    
}
