//
//  SOImageCell.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 16/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit
import Photos

class SOImageCell: UICollectionViewCell {
  @IBOutlet weak var IBSelectionView: UIView!
  @IBOutlet weak var IBImageView: UIImageView!
  override var isSelected:Bool{
    didSet{
      if isSelected {
        IBSelectionView.backgroundColor = .black
      }
      else{
        IBSelectionView.backgroundColor = .clear
      }
    }
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    if self.IBImageView != nil{
      IBImageView.image = nil
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    viewConfigurations()
  }
  
  private func viewConfigurations(){
    IBSelectionView.layer.borderWidth = 2
    IBSelectionView.layer.borderColor = UIColor.clear.cgColor
  }
  
  func populateDataWith(asset:PHAsset) {
    SOImagerFetcher.imageFrom(asset: asset) { (image) in
      DispatchQueue.main.async {
        if self.IBImageView != nil{
          self.IBImageView.image = image
        }
      }
    }
  }

}
