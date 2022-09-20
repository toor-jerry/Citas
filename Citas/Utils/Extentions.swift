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
