//
//  ChatProtocols.swift
//  Citas
//
//  Created by 1058889 on 14/09/22.
//

import UIKit.UIViewController

protocol ChatViewProtocols: AnyObject {
    var presenter: ChatPresenterProtocols? {get set}
 
}

protocol ChatPresenterProtocols: AnyObject {
    var router: ChatRouterProtocols? {get set}
    var view: ChatViewProtocols? {get set}
    var interactor: ChatInteractorInputProtocols? {get set}
    
}

protocol ChatRouterProtocols: AnyObject {
    static func createModuls(titleNav: String) -> UIViewController
}

protocol ChatInteractorOutputProtocols: AnyObject {
    
}

protocol ChatInteractorInputProtocols: AnyObject {
    var presenter: ChatInteractorOutputProtocols? {get set}
    
}
