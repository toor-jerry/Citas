//
//  LoginPresenter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

class LoginPresenter: LoginPresenterProtocols, LoginInteractorOutputProtocols {
    var router: LoginRouterProtocols?
    var view: LoginViewProtocols?
    var interactor: LoginInteractorInputProtocols?
}
