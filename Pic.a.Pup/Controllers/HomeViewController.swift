//
//  HomeViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/16/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit
import SideMenu

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var recentSearchCollectionView: UICollectionView!
    
    @IBAction func launchGalleryForPhotos(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    let picker = UIImagePickerController()
    let camera = CameraQRViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        //picker.delegate = camera
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        //SideMenuManager.default.menuBlurEffectStyle = .light
        //SideMenuManager.default.menuFadeStatusBar = false
        
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        
    }
        
    

/*
    func gradientWithFrametoImage(frame: CGRect, colors: [CGColor]) -> UIImage? {
        let gradient: CAGradientLayer  = CAGradientLayer(layer: self.view.layer)
        gradient.frame = frame
        gradient.colors = colors
        UIGraphicsBeginImageContext(frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
 */
    
    @IBAction func handleLogOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        self.present(initialViewController, animated: false)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentSearchCollectionView.dequeueReusableCell(withReuseIdentifier: "pupCollectionViewCell", for: indexPath) as! PupCollectionViewCell
        //cell.layer.backgroundColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 20
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        if (indexPath.row == 1) {
            cell.pupCardImageView.image = UIImage(named: "funny-dog-8-e1500643440478")
        } else if (indexPath.row == 2) {
            cell.pupCardImageView.image = UIImage(named: "corgdashian-funny-picture-388x220")
        } else if (indexPath.row == 3) {
            cell.pupCardImageView.image = UIImage(named: "Funny-Dog-Face-During-Selfie")
        } else if (indexPath.row == 4) { 
            cell.pupCardImageView.image = UIImage(named: "maxresdefault")
        } else if (indexPath.row == 5) {
            cell.pupCardImageView.image = UIImage(named: "maxresdefault")
        }
        return cell
    }
}
