//
//  PageErrorViewController.swift
//  Citas
//
//  Created by 1058889 on 20/09/22.
//

import UIKit

class PageErrorViewController: UIViewController {

    var presenter: PageErrorPresenterProtocols?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PageErrorViewController: PageErrorViewProtocols { }
