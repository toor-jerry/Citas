//
//  Extentions.swift
//  Citas
//
//  Created by user216116 on 06/08/22.
//

import UIKit

extension MainView {

    // Tranparencia script
    func blurEffect(bcg: UIImageView) {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: bcg.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(20, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        bcg.image = processedImage
    }
    
}

extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}

extension Notification.Name {
    /// Notificaiton  when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
}

// Mark: String - Email Validation
extension String {
    
    func validarEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func cleanName() -> String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
            .lowercased()
            .trimmingCharacters(in: [" "])
    }
    

    func clean() -> String {
        let cleanedString = self.folding(options: [.diacriticInsensitive, .caseInsensitive, .widthInsensitive], locale: nil)
        return cleanedString.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: "_")
    }
    func removeUnusedData() -> String{
        let cleanPhone = self.replacingOccurrences(of: " ", with: "")
        
        return String(cleanPhone.suffix(10))
    }
}

extension UIViewController {
    
    func alertUserLoginError(message: String = "Un error a ocurrido!") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Cerrar",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func toUIColorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
