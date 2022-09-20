//
//  PageErrorProtocols.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit.UIViewController

protocol PageErrorViewProtocols: AnyObject {
    var presenter: PageErrorPresenterProtocols? {get set}
    
}

protocol PageErrorPresenterProtocols: AnyObject {
    var router: PageErrorRouterProtocols? {get set}
    var view: PageErrorViewProtocols? {get set}
    var interactor: PageErrorInteractorInputProtocols? {get set}
}

protocol PageErrorRouterProtocols: AnyObject {
    static func createModuls() -> UIViewController
}

protocol PageErrorInteractorOutputProtocols: AnyObject {
    
}

protocol PageErrorInteractorInputProtocols: AnyObject {
    var presenter: PageErrorInteractorOutputProtocols? {get set}
}
