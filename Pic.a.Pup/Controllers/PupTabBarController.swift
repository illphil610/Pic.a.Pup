//
//  PupTabBarController.swift
//  Pic.a.Pup
//
//  Created by Philip on 3/31/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import UIKit

class PupTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    weak var pupDelegate: PupTabControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let cameraVC = viewController as? CameraQRViewController {
            cameraVC.setupCamera()
        }
    }
}

protocol PupTabControllerDelegate: class {
    func setupCamera()
}
