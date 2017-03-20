//
//  SOCroppedVC.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 16/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit
import CoreImage

class SOCroppedVC: UIViewController {
  
  @IBOutlet weak var IBImageView: UIImageView!
  var croppedImage:UIImage!
  var thumbImage:UIImage!
  var CIFilterList: [String] = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    CIFilterList = SOItems.getFilternames()
    IBImageView.image = croppedImage
    thumbImage = SOHelper.resizeImage(image: croppedImage, targetSize: CGSize.init(width: 100, height: 100))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SOProfileImageVC" {
      let profileVC = segue.destination as? SOProfileVC
      profileVC?.profileImage = self.IBImageView.image
    }
  }
  
  //MARK:- IBAction methods
  @IBAction func IBActionSave(_ sender: Any) {
    performSegue(withIdentifier: "SOProfileImageVC", sender: nil)
  }


}

//MARK:- Collectionview datasource methods
extension SOCroppedVC:UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell:SOImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SOImageCell", for: indexPath) as! SOImageCell
    DispatchQueue.main.async { () -> Void in
      cell.IBImageView.image = SOHelper.getFilteredImage(filterName: self.CIFilterList[indexPath.row], thumbImage: self.thumbImage)
    }
    
    return cell
  }
}

//MARK:- Collectionview delegate methods
extension SOCroppedVC:UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return CIFilterList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell:SOImageCell = collectionView.cellForItem(at: indexPath) as! SOImageCell
    cell.isSelected = true
    self.IBImageView.image = SOHelper.getFinalImage(filterName: CIFilterList[indexPath.row], croppedImage: self.croppedImage)
  }
}
//MARK:- Collectionview flowlayout methods
extension SOCroppedVC:UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width:CGFloat = ((UIScreen.main.bounds.size.width-10)/3)-7
    return CGSize(width: width, height: width)
  }
}
