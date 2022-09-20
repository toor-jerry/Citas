//
//  RegisterPresenter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

class RegisterPresenter: RegisterPresenterProtocols, RegisterInteractorOutputProtocols {
    var router: RegisterRouterProtocols?
    var view: RegisterViewProtocols?
    var interactor: RegisterInteractorInputProtocols?
}
