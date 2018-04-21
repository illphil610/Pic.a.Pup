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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    let camera = CameraViewController()
    let firebaseManager = FirebaseManager()
    var searchFeedList: Array<DogSearchResult> = Array()
    
    override func viewWillAppear(_ animated: Bool) {
        //searchFeedList.removeAll()
        searchFeedList.removeAll()
        //recentSearchCollectionView.reloadData()
        let dbRef = Database.database().reference().child(Constants.Pups.feedResult)
        dbRef.observe(.value, with: { (snapshot) in
            //print(snapshot)
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if snap.value != nil {
                    let dict = snap.value as! [String: String]
                    //print(dict)
                    let breedName = dict["breed"]
                    let downloadUrl = dict["dogImageSent"]
                    let result = DogSearchResult(breed: breedName!, url: downloadUrl!)
                    print(result)
                    self.searchFeedList.append(result)
                    self.recentSearchCollectionView.reloadData()
                }
            }
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        
        picker.delegate = self
        recentSearchCollectionView.dataSource = self
        /*
        searchFeedList.removeAll()
        let dbRef = Database.database().reference().child(Constants.Pups.feedResult)
        dbRef.observe(.value, with: { (snapshot) in
            //print(snapshot)
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if snap.value != nil {
                    let dict = snap.value as! [String: String]
                    //print(dict)
                    let breedName = dict["breed"]
                    let downloadUrl = dict["dogImageSent"]
                    let result = DogSearchResult(breed: breedName!, url: downloadUrl!)
                    print(result)
                    self.searchFeedList.append(result)
                    self.recentSearchCollectionView.reloadData()
                }
            }
        })
 */
        
        
        
        
        
        
        let token = Messaging.messaging().fcmToken
        //print("TOKEN: \(token)")
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    /*
    @IBAction func handleLogOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        self.present(initialViewController, animated: false)
    }
    */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(searchFeedList.count)
        return searchFeedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentSearchCollectionView.dequeueReusableCell(withReuseIdentifier: "pupCollectionViewCell", for: indexPath) as! PupCollectionViewCell
        cell.layer.cornerRadius = 20
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        /*
        if (indexPath.row == 1) {
            cell.pupCardImageView.image = UIImage(named: "funny-dog-8-e1500643440478")
            //firebaseManager.getImageFromFirebase(downloadUrl, closure:{ (image) in
                //cell.pupCardImageView.image = image
            //})
        } else if (indexPath.row == 2) {
            cell.pupCardImageView.image = UIImage(named: "corgdashian-funny-picture-388x220")
        } else if (indexPath.row == 3) {
            cell.pupCardImageView.image = UIImage(named: "Funny-Dog-Face-During-Selfie")
        } else if (indexPath.row == 4) { 
            cell.pupCardImageView.image = UIImage(named: "maxresdefault")
        } else if (indexPath.row == 5) {
            cell.pupCardImageView.image = UIImage(named: "maxresdefault")
        }
         */
        
        firebaseManager.getImageFromFirebase(searchFeedList[indexPath.row].url, closure:{ (image) in
            print("poop" + self.searchFeedList[indexPath.row].url)
            cell.pupCardImageView.image = image
        })
        
        return cell
    }
    
    
    // UIImagePickerDelegatee
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("got the image")
            if let navController = navigationController {
                print("got to the nav controller at least")
                if let pupTabBarController = navController.tabBarController as? PupTabBarController {
                    pupTabBarController.selectedIndex = 1
                    
                    if let camera = pupTabBarController.viewControllers![1] as? CameraQRViewController {
                        print("i made it to the camera vc")
                        camera.view.backgroundColor = UIColor.black
                        camera.breedNameLabel.isHidden = true
                        if camera.card != nil {
                            camera.card.isHidden = true
                        }
                        camera.photoFromFileSystem = chosenImage
                        camera.pupPreviewImageView.contentMode = .scaleAspectFit
                        camera.pupPreviewImageView.image = chosenImage
                        camera.submitButton.isHidden = false
                    }
                }
                dismiss(animated:true, completion: nil)
            }
        }
    }
}

