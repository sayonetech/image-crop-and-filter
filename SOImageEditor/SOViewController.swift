//
//  SOViewController.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 16/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit
import Photos

class SOViewController: UIViewController,UINavigationControllerDelegate {
  
  @IBOutlet weak var IBScrollContainerView: UIView!
  @IBOutlet weak var IBCollectionView: UICollectionView!
  @IBOutlet weak var IBButtonSquareFit: UIButton!
  @IBOutlet weak var IBProfileView: UIView!
  @IBOutlet weak var IBScrollView: SOScrollView!
  
  private let imageFetcher = SOImagerFetcher()
  private var croppedImage: UIImage? = nil
  var photos:[PHAsset]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.delegate = self
    checkForPhotosPermission()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK:- Custom navigation transition methods
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch(operation)
    {
    case UINavigationControllerOperation.push:
      return SSPushAnimator()
    case UINavigationControllerOperation.pop:
      return SSPopAnimator()
    default:
      return nil;
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SOCroppedImageVC" {
      let croppedVC = segue.destination as? SOCroppedVC
      croppedVC?.croppedImage = croppedImage
    }
  }
  
  //MARK:- IBAction methods
  
  @IBAction func IBActionCrop(_ sender: Any) {
    croppedImage = captureVisibleRect()
    performSegue(withIdentifier: "SOCroppedImageVC", sender: nil)
  }
  @IBAction func IBActionSquarefit(_ sender: Any) {
    IBScrollView.zoom()
  }
  @IBAction func IBActionProfileMode(_ sender: Any) {
    IBProfileView.isHidden = !IBProfileView.isHidden
  }
  
  //MARK:- check for photo permission
  
  private func checkForPhotosPermission(){
    let status = PHPhotoLibrary.authorizationStatus()
    if (status == PHAuthorizationStatus.authorized) {
        loadPhotos()
    }
    else if (status == PHAuthorizationStatus.denied) {
    }
    else if (status == PHAuthorizationStatus.notDetermined) {
      PHPhotoLibrary.requestAuthorization({ (newStatus) in
        
        if (newStatus == PHAuthorizationStatus.authorized) {
          
          DispatchQueue.main.async {
                self.loadPhotos()
          }
        }
        else {
        }
      })
    }
    else if (status == PHAuthorizationStatus.restricted) {
    }
  }
  //Load photo from Assets
  private func loadPhotos(){
    imageFetcher.loadPhotos { (assets) in
      if assets.count != 0{
        self.photos = assets
        self.IBCollectionView.delegate = self
        self.IBCollectionView.dataSource = self
        self.IBCollectionView.reloadData()
        self.selectInitialImage()
      }

    }
  }
  private func selectInitialImage(){
    IBCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
    SOImagerFetcher.imageFrom(asset: photos[0]) { (image) in
      DispatchQueue.main.async {
        self.displayImageInScrollView(image: image)
      }
    }
  }
  
  //Capture the visible area from image
  
  private func captureVisibleRect() -> UIImage{
    
    let scrollContainerAsImage:UIImage = snapShotOfScrollContainer()
    let visibleFrame:CGRect = visibleRectOf(imageView: IBScrollView.imageView)
    
    let imageView:UIImageView = UIImageView(image: scrollContainerAsImage)
    imageView.frame.origin = visibleFrame.origin
    
    let containerView:UIView = UIView(frame: view.frame)
    containerView.addSubview(imageView)
    
    UIGraphicsBeginImageContextWithOptions(visibleFrame.size, false, 0.0)
    containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let visibleImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return visibleImage!
    
  }
  private func visibleRectOf(imageView:UIImageView) -> CGRect{
    
    var visibleImageFrame:CGRect = CGRect(origin: .zero, size: IBScrollContainerView.frame.size)
    
    let imageViewFrame:CGRect = imageView.frame
    
    if imageViewFrame.origin.x > 0 {
      visibleImageFrame.origin.x = -imageViewFrame.origin.x
    }
    
    if imageViewFrame.origin.y > 0 {
      visibleImageFrame.origin.y = -imageViewFrame.origin.y
    }
    
    if imageViewFrame.size.width < IBScrollContainerView.frame.size.width {
      visibleImageFrame.size.width = imageViewFrame.size.width
    }
    
    if imageViewFrame.size.height < IBScrollContainerView.frame.size.height {
      visibleImageFrame.size.height = imageViewFrame.size.height
    }
    
    return visibleImageFrame
  }
  private func snapShotOfScrollContainer() -> UIImage{
    
    UIGraphicsBeginImageContextWithOptions(IBScrollView.frame.size, false, 0.0)
    IBScrollContainerView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  private func isSquareImage() -> Bool{
    let image = IBScrollView.imageToDisplay
    if image?.size.width == image?.size.height { return true }
    else { return false }
  }
  func displayImageInScrollView(image:UIImage){
    self.IBScrollView.imageToDisplay = image
  }
}

//MARK:- Collectionview datasource methods
extension SOViewController:UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell:SOImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SOImageCell", for: indexPath) as! SOImageCell
    cell.populateDataWith(asset: photos[indexPath.item])
    return cell
  }
}

//MARK:- Collectionview delegate methods
extension SOViewController:UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell:SOImageCell = collectionView.cellForItem(at: indexPath) as! SOImageCell
    cell.isSelected = true
    displayImageInScrollView(image: cell.IBImageView.image!)
  }
}

//MARK:- Collectionview flowlayout methods
extension SOViewController:UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width:CGFloat = ((UIScreen.main.bounds.size.width-10)/3)-7
    return CGSize(width: width, height: width)
  }
}
