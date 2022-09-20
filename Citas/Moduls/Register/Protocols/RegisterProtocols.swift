//
//  RegisterProtocols.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

protocol RegisterViewProtocols: AnyObject {
    var presenter: RegisterPresenterProtocols? {get set}
    
}

protocol RegisterPresenterProtocols: AnyObject {
    var router: RegisterRouterProtocols? {get set}
    var view: RegisterViewProtocols? {get set}
    var interactor: RegisterInteractorInputProtocols? {get set}
}

protocol RegisterRouterProtocols: AnyObject {
    static func createModuls() -> UIViewController
}

protocol RegisterInteractorOutputProtocols: AnyObject {
    
}

protocol RegisterInteractorInputProtocols: AnyObject {
    var presenter: RegisterInteractorOutputProtocols? {get set}
}
