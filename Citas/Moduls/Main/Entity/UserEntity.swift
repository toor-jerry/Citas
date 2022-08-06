//
//  UserEntity.swift
//  Citas
//
//  Created by user216116 on 05/08/22.
//

class UserEntity {
    
    var name: String
    var age: Int
    var enable: Bool
    var image: String
    var gender: String
    
    internal init (name: String, age: Int, enable: Bool, image: String, gender: String) {
        self.name = name
        self.age = age
        self.enable = enable
        self.image = image
        self.gender = gender
    }
    
}
