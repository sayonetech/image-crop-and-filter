//
//  SOProfileVC.swift
//  SOImageEditor
//
//  Created by SayOne Technologies on 17/03/17.
//  Copyright © 2017 SayOne Technologies. All rights reserved.
//

import UIKit

class SOProfileVC: UIViewController {

  @IBOutlet weak var IBProfileImage: UIImageView!
  var profileImage:UIImage!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      IBProfileImage.layer.cornerRadius = IBProfileImage.frame.width/2
      IBProfileImage.clipsToBounds = true
      IBProfileImage.image = profileImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
