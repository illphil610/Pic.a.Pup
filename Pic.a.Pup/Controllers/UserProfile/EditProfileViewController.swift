//
//  EditProfileViewController.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/6/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import Eureka

class EditProfileViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        form +++ Section("Basic Info")
            <<< TextRow("Name") { row in
                row.title = "Name"
                row.placeholder = "Enter your name here"
            }
            <<< TextRow("Username") { row in
                row.title = "Username"
                row.placeholder = "Enter your username here"
            }
            <<< PhoneRow("PhoneNumber") {
                $0.title = "Phone Number"
                $0.placeholder = "Enter your phone # here"
        }
        
        form +++ Section("Dog Info")
            <<< TextRow("DogName") { row in
                row.title = "Dog Name"
                row.placeholder = "Enter your dogs name here"

        }
    }
    
    @IBAction func saveNewUserInfo(_ sender: UIBarButtonItem) {
        
        // pull items and make updated object and save to NSUserDefaults
        let nameTextRow: TextRow? = form.rowBy(tag: "Name")
        let nameTextString = nameTextRow?.value
        
        let userNameRow: TextRow? = form.rowBy(tag: "Username")
        let userNameString = userNameRow?.value
        
        let phoneNumberRow: PhoneRow? = form.rowBy(tag: "PhoneNumber")
        let phoneNumberString = phoneNumberRow?.value
        
        let dogNameRow: TextRow? = form.rowBy(tag: "DogName")
        let dogNameString = dogNameRow?.value
        
        let dogLover = DogLover(name: nameTextString!,
                                phoneNumber: phoneNumberString!,
                                fcm_id: "FCM")
        
        if let dogName = dogNameString {
            let dog = Dog(name: dogName, pupcode: "fuckPupCodes")
            UserDefaults.standard.set(try? PropertyListEncoder().encode(dog), forKey: "dog")
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(dogLover), forKey:"owner")
        navigationController?.popViewController(animated: true)
    }
}
