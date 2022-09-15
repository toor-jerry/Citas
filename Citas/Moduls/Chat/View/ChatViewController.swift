//
//  ChatViewController.swift
//  Citas
//
//  Created by 1058889 on 14/09/22.
//

import UIKit

class ChatViewController: UIViewController {
    var presenter: ChatPresenterProtocols?
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    var titleNav: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarTitle.title = titleNav ?? "Chat"
    }
    
    func setData(titleNav: String) {
        self.titleNav = titleNav
    }
}

extension ChatViewController: ChatViewProtocols { }
