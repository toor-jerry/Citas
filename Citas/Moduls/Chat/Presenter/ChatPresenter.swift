//
//  ChatPresenter.swift
//  Citas
//
//  Created by 1058889 on 14/09/22.
//

class ChatPresenter: ChatPresenterProtocols, ChatInteractorOutputProtocols {
    var router: ChatRouterProtocols?
    var view: ChatViewProtocols?
    var interactor: ChatInteractorInputProtocols?
    
}
