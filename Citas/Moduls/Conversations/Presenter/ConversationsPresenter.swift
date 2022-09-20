//
//  ConversationsPresenter.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

class ConversationsPresenter: ConversationsPresenterProtocols, ConversationsInteractorOutputProtocols {
    var router: ConversationsRouterProtocols?
    var view: ConversationsViewProtocols?
    var interactor: ConversationsInteractorInputProtocols?
    
}
