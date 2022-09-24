//
//  LogoAnimationViewController.swift
//  Citas
//
//  Created by 1058889 on 24/09/22.
//

import UIKit

class LogoAnimationViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    var viewController = PageErrorRouter.createModuls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = toUIColorFromRGB(red: 251, green: 195, blue: 208)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        self.animate()
        if let viewC = LoginRouter.createModuls() as? LoginViewController {
            viewController = viewC
        } else {
            if let viewC = LoginRouter.createModuls() as? MainView {
                viewController = viewC
            }
        }
    }
    
    func animate()  {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX)/2,
                y: diffY/2,
                width: size,
                height: size
            )
            
            self.imageView.alpha = 0
        }, completion: { done in
            self.viewController.modalTransitionStyle = .crossDissolve
            self.viewController.modalPresentationStyle = .fullScreen
            self.present(self.viewController, animated: true)
        })
    }
}
