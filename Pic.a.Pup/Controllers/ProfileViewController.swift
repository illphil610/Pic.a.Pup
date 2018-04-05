//
//  ProfileViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/23/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import AVFoundation
import Lumina
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    
    
    @IBAction func handleSignOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        self.present(initialViewController, animated: false)
    }
}


