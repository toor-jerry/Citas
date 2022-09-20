//
//  LoginProtocols.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

protocol LoginViewProtocols: AnyObject {
    var presenter: LoginPresenterProtocols? {get set}
    
}

protocol LoginPresenterProtocols: AnyObject {
    var router: LoginRouterProtocols? {get set}
    var view: LoginViewProtocols? {get set}
    var interactor: LoginInteractorInputProtocols? {get set}
}

protocol LoginRouterProtocols: AnyObject {
    static func createModuls() -> UIViewController
}

protocol LoginInteractorOutputProtocols: AnyObject {
    
}

protocol LoginInteractorInputProtocols: AnyObject {
    var presenter: LoginInteractorOutputProtocols? {get set}
}
