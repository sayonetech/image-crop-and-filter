//
//  SOHelper.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 20/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit

class SOHelper: NSObject {

  // Create thumbnail image for filter listing
  class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
  // List of CoreImage filtered images
  class func getFilteredImage(filterName : String,thumbImage: UIImage) -> UIImage{
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: thumbImage)
    let filter = CIFilter(name: "\(filterName)" )
    filter!.setDefaults()
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    return UIImage(cgImage: filteredImageRef!)
  }
  // Final filtered image
  class func getFinalImage(filterName : String,croppedImage: UIImage) -> UIImage{
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: croppedImage)
    let filter = CIFilter(name: "\(filterName)" )
    filter!.setDefaults()
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    return UIImage(cgImage: filteredImageRef!)
  }
}
