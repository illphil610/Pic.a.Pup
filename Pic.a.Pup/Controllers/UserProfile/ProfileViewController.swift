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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var dogNameLabel: UILabel!
    
    @IBOutlet weak var lostDogToggle: UISwitch!
    
    
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
        
        lostDogToggle.isOn = false
        
        if let data = UserDefaults.standard.value(forKey:"owner") as? Data {
            let owner2 = try? PropertyListDecoder().decode(DogLover.self, from: data)
            nameLabel.text = owner2?.name
            //emailLabel.text = owner2?.email
            phoneNumberLabel.text = owner2?.phoneNumber
        
        }
        
        if let dogData = UserDefaults.standard.value(forKey: "dog") as? Data {
            let dog = try? PropertyListDecoder().decode(Dog.self, from: dogData)
            dogNameLabel.text = dog?.name
        }
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
    
    @IBAction func lostDogTogglePressed(_ sender: UISwitch) {
        
        // create LostPup object and save to firebase
        
        var owner: DogLover
        var dog: Dog
        
        if let data = UserDefaults.standard.value(forKey:"owner") as? Data {
            let tempOwner = try! PropertyListDecoder().decode(DogLover.self, from: data)
            owner = tempOwner
            
            
            
            if let dogData = UserDefaults.standard.value(forKey: "dog") as? Data {
                let tempDog = try! PropertyListDecoder().decode(Dog.self, from: dogData)
                dog = tempDog
                
                let lostPup = try? LostPup(dogName: dog.name, owner: owner).asDictionary()
                
                //let databaseReference = Database.database().reference().child("LostPups")
                //let key = databaseReference.child("\(dog.pupcode)")
                //databaseReference.child(key).setValue(lostPup)
                let databaseReference = Database.database().reference().child("LostPups")
                databaseReference.child(dog.pupcode).setValue(lostPup)
            }
        }
    }
    
}


