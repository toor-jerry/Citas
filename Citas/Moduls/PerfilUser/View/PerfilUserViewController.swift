//
//  PerfilUserViewController.swift
//  Citas
//
//  Created by user216116 on 08/08/22.
//

import UIKit

class PerfilUserViewController: UIViewController {
    var presenter: PerfilUserPresenterProtocols?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PerfilUserViewController: PerfilUserViewProtocols { }
