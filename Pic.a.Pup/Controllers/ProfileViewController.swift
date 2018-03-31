//
//  ProfileViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/23/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    
}


