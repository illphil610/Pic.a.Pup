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
import SwiftLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var lostDogToggle: UISwitch!
    
    
    override func viewDidLoad() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // determine log dog toggle state
        lostDogToggle.isOn = UserDefaults.standard.bool(forKey: "toggleState")
            
    
        if let data = UserDefaults.standard.value(forKey:"owner") as? Data {
            let owner2 = try? PropertyListDecoder().decode(DogLover.self, from: data)
            nameLabel.text = owner2?.name
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
        
        if (lostDogToggle.isOn) {
            UserDefaults.standard.set(true, forKey: "toggleState")
            print("its on bitch")
            var dogLover: DogLover
            if let data = UserDefaults.standard.value(forKey:"owner") as? Data {
                let tempOwner = try! PropertyListDecoder().decode(DogLover.self, from: data)
                dogLover = tempOwner
                if let dogData = UserDefaults.standard.value(forKey: "dog") as? Data {
                    let dog = try! PropertyListDecoder().decode(Dog.self, from: dogData)
                    
                    Locator.currentPosition(accuracy: .neighborhood, onSuccess: { location in
                        print(location)
                        let lostPup = try? LostPup(dogName: dog.name, dogLover: dogLover, found: false,
                                                   fcm_id: InstanceID.instanceID().token()!,
                                                   latitude: location.coordinate.latitude,
                                                   longitude: location.coordinate.longitude).asDictionary()
                        let databaseReference = Database.database().reference().child("LostPups")
                        databaseReference.child("insert_pupcode_here").setValue(lostPup)
                        
                        let alert = UIAlertController(title: "Lost Dog", message: "You just reported your dog is lost", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }, onFail: { error, location  in
                        print(error)
                        print("We cant find your location")
                    })
                }
            }
        } else {
            UserDefaults.standard.set(false, forKey: "toggleState")
            let databaseReference = Database.database().reference().child("LostPups")
            databaseReference.child("insert_pupcode_here").removeValue()
        }
    }
    
}


