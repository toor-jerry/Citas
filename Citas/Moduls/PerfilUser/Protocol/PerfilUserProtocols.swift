//
//  PerfilUserProtocols.swift
//  Citas
//
//  Created by user216116 on 08/08/22.
//
import Foundation
import UIKit

protocol PerfilUserViewProtocols: AnyObject {
    var presenter: PerfilUserPresenterProtocols? {get set}
    
}

protocol PerfilUserPresenterProtocols: AnyObject {
    var router: PerfilUserRouterProtocols? {get set}
    var view: PerfilUserViewProtocols? {get set}
    var interactor: PerfilUserInteractorInputProtocols? {get set}
}

protocol PerfilUserRouterProtocols: AnyObject {
    static func createModuls() -> UIViewController
}

protocol PerfilUserInteractorOutputProtocols: AnyObject {
    
}

protocol PerfilUserInteractorInputProtocols: AnyObject {
    var presenter: PerfilUserInteractorOutputProtocols? {get set}
}
