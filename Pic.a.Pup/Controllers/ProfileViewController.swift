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
import SideMenu

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        //view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.default.menuPresentMode = .menuDissolveIn
        //SideMenuManager.default.menuBlurEffectStyle = .light
        SideMenuManager.default.menuFadeStatusBar = false
        
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
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


