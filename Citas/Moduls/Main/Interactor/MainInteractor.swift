//
//  MainInteractor.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

class MainInteractor: MainInteractorInputProtocols {
    
    
    var presenter: MainInteractorOutputProtocols?
    
    func getUser() {
        var listUser: [UserEntity] = []
        let user1 = UserEntity(name: "Gerardo", age: 23, enable: true, image: "man", gender: "H")
        let user2 = UserEntity(name: "María", age: 24, enable: false, image: "girl", gender: "M")
        let user3 = UserEntity(name: "Pedro", age: 23, enable: false, image: "man", gender: "H")
        let user4 = UserEntity(name: "Ana", age: 23, enable: false, image: "man", gender: "H")
        let user5 = UserEntity(name: "Laura", age: 23, enable: false, image: "girl", gender: "M")
        
        listUser.append(user1)
        listUser.append(user2)
        listUser.append(user3)
        listUser.append(user4)
        listUser.append(user5)
        presenter?.sendUser(user: listUser)
    }
    
    func getGenderUser(genero: Int) {
        
    }
    
}
