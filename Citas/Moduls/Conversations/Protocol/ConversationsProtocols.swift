//
//  ConversationsProtocols.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

protocol ConversationsViewProtocols: AnyObject {
    var presenter: ConversationsPresenterProtocols? {get set}
 
}

protocol ConversationsPresenterProtocols: AnyObject {
    var router: ConversationsRouterProtocols? {get set}
    var view: ConversationsViewProtocols? {get set}
    var interactor: ConversationsInteractorInputProtocols? {get set}
    
}

protocol ConversationsRouterProtocols: AnyObject {
    static func createModuls(titleNav: String) -> UIViewController
}

protocol ConversationsInteractorOutputProtocols: AnyObject {
    
}

protocol ConversationsInteractorInputProtocols: AnyObject {
    var presenter: ConversationsInteractorOutputProtocols? {get set}
    
}
