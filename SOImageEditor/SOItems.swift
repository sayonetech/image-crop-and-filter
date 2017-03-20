//
//  SOItems.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 20/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit

class SOItems: NSObject {
  
  // List of CoreImage filters
  class func getFilternames()-> [String]{
    let CIFilterNames = ["CIPhotoEffectChrome","CIPhotoEffectFade","CIPhotoEffectInstant","CIPhotoEffectNoir","CIPhotoEffectProcess","CIPhotoEffectTonal","CIPhotoEffectTransfer","CISepiaTone"]
    return CIFilterNames
  }
}
