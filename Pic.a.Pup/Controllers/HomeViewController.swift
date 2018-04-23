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
    var searchFeedList: Array<FeedDogSearchResult> = Array()
    var photoImageArray: Array<UIImage> = Array()
    
    override func viewWillAppear(_ animated: Bool) {
        //searchFeedList.removeAll()
        searchFeedList.removeAll()
        recentSearchCollectionView.reloadData()
        let dbRef = Database.database().reference().child(Constants.Pups.feedResult)
        dbRef.observe(.value, with: { (snapshot) in
            self.searchFeedList.removeAll()
            //print(snapshot)
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if snap.value != nil {
                    let dict = snap.value as! [String: Any]
                    //print(dict)
                    let breedName = dict["breed"] as? String
                    let downloadUrl = dict["dogImageSent"] as? String
                    let probability = dict["probability"] as? Double
                    let result = FeedDogSearchResult(breed: breedName!, dogImageSent: downloadUrl!, probability: probability!)
                    print(result)
                    self.searchFeedList.append(result)
                    self.recentSearchCollectionView.reloadData()
                }
            }
            self.searchFeedList.reverse()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        picker.delegate = self
        recentSearchCollectionView.dataSource = self
        
        let token = Messaging.messaging().fcmToken
        print("TOKEN: \(token)")
        
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(searchFeedList.count)
        return searchFeedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentSearchCollectionView.dequeueReusableCell(withReuseIdentifier: "pupCollectionViewCell", for: indexPath) as! PupCollectionViewCell
        cell.pupCardImageView.image = nil
        cell.breedNameLabel.text = ""
        cell.probabilityLabel.text = ""
        
        cell.layer.cornerRadius = 20
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        firebaseManager.getImageFromFirebase(searchFeedList[indexPath.row].dogImageSent, closure:{ (image) in
            print("poop" + self.searchFeedList[indexPath.row].dogImageSent)
            cell.pupCardImageView.image = image
            cell.breedNameLabel.text = self.searchFeedList[indexPath.row].breed
            let prob = "\( Double((self.searchFeedList[indexPath.row].probability * 100)).rounded(toPlaces: 2))%"
            cell.probabilityLabel.text = prob
        })
 
        //cell.pupCardImageView.image = searchFeedList[indexPath.row].dogImageSent
        //cell.breedNameLabel.text = searchFeedList[indexPath.row].breed
        //let prob = "\( Double((searchFeedList[indexPath.row].probability * 100)).rounded(toPlaces: 2))%"
        //cell.probabilityLabel.text = prob
        
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

