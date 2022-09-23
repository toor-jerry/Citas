//
//  ProfileModel.swift
//  Citas
//
//  Created by 1058889 on 22/09/22.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
