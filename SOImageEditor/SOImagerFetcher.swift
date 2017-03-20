//
//  SOImagerFetcher.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 16/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit
import Foundation
import Photos

typealias Success = (_ photos:[PHAsset])->Void

class SOImagerFetcher: NSObject {
  
  private var assets = [PHAsset]()
  private var success:Success? = nil
  
  func loadPhotos(success:Success!){
    self.success = success
    loadAllPhotos()
  }
  // Load image from assets
  private func loadAllPhotos() {
    
    let fetchOptions: PHFetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    fetchResult.enumerateObjects({ (object, index, stop) -> Void in
      self.assets.append(object)
      if self.assets.count == fetchResult.count{ self.success!(self.assets) }
    })
  }
  
  static func imageFrom(asset:PHAsset, success:@escaping (_ photo:UIImage)->Void){
    
    let options = PHImageRequestOptions()
    options.isSynchronous = false
    options.deliveryMode = .highQualityFormat
    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options, resultHandler: { (image, attributes) in
      success(image!)
    })
  }

}
