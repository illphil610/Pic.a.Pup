//
//  CameraQRViewController.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/30/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import AVFoundation
import Lumina
import RSLoadingView
import CoreLocation
import SwiftyJSON
import Material
import Cards
import Firebase
import MessageUI

class CameraQRViewController: UIViewController, MFMessageComposeViewControllerDelegate,                        UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var resultsCard: CardHighlight!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var pupPreviewImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var defaultMessageForUser: UILabel!
    
    var card: CardHighlight!
    let locationManager = CLLocationManager()
    let firebaseManager = FirebaseManager()
    let networkManager = NetworkManager()
    let utility = Utility()
    let loadingView = RSLoadingView()
    
    var photoFromFileSystem: UIImage?
    
    var breedInfoGlobal: String = "test"
    var breedNameGlobal: String = "test"
    var probabilityRatingGlobal: Double = 0.0
    var currentUserCoordinateLocation: CLLocation?
    var currentUserPlacemark: CLPlacemark?
    var downloableUrlFromFirebase: String?
    var hasQRMetadataBeenScanned: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        if (photoFromFileSystem == nil) {
            pupPreviewImageView.image = nil
            submitButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        breedNameLabel.isHidden = true
        card?.isHidden = true
        
        utility.delegate = self
        networkManager.delegate = self
        locationManager.delegate = utility
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasQRMetadataBeenScanned = false
        
        locationManager.delegate = utility
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if (photoFromFileSystem == nil) {
            submitButton.isHidden = true
        }
        pupPreviewImageView.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func setupCamera() {
        
        // Hide views so you just see black when camera launches
        card?.isHidden = true
        pupPreviewImageView.isHidden = true
        submitButton.isHidden = true
        defaultMessageForUser.isHidden = true
        
        let camera = LuminaViewController()
        camera.delegate = self
        camera.trackMetadata = true
        camera.resolution = .highest
        
        tabBarController?.tabBar.isHidden = true
        present(camera, animated: true, completion: nil)
    }
    
    @IBAction func submitPhotoForAnalysis(_ sender: Any) {
        loadingView.show(on: view)
        if let dogPictureTakenFromCamera = pupPreviewImageView.image {
            firebaseManager.uploadImageToFirebase(dogPictureTakenFromCamera, completionBlock: { (fileUrl, errorMessage) in
                if let url = fileUrl {
                    self.downloableUrlFromFirebase = url.absoluteString
                    if let zipcode = self.currentUserPlacemark?.postalCode {
                        let modelSearchRequest = ModelSearchRequest(location: zipcode, url: "\(url)")
                        let dick = try? modelSearchRequest.asDictionary()
                        if let dicktionary = dick {
                            self.networkManager.sendPostToServer(parameters: dicktionary)
                        }
                    }
                } else if let error = errorMessage {
                    print("\(error)")
                }
            })
        }
    }
}

extension CameraQRViewController: UtilityDelegate {
    func sendLocationCoorData(_ locationCoords: CLLocation) {
        currentUserCoordinateLocation = locationCoords
        print(locationCoords.coordinate)
    }
    
    func sendPlacemarkData(_ placemark: CLPlacemark) {
        currentUserPlacemark = placemark
        print(placemark.postalCode ?? "default jawn")
    }
}

extension CameraQRViewController: NetworkProtocolDelegate {
    func sendResponseJSONData(_ response: Any) {
        
        let responseJSON = JSON(response)
        
        // parse the json for what i need, ya feel me fam?
        let breed = responseJSON["breed"].string
        let breedInfo = responseJSON["breed_info"].string
        let probabilityRating = responseJSON["prob"].double
        let shelterContact = responseJSON["shelter_contact"].array
        
        if let url = downloableUrlFromFirebase {
            if let breedName = breed {
                if let prob = probabilityRating {
                    firebaseManager.saveObjectToFirebase(breedName, url, prob)
                }
            }
        }
       
        if let probability = probabilityRating {
            probabilityRatingGlobal = probability
        }
    
        print(responseJSON)
        print(breed ?? "nah")
        breedNameLabel.isHidden = true
        
        if let breedNameAsString = breed {
            breedNameGlobal = breedNameAsString
            
            if (breedInfo != nil) {
                breedInfoGlobal = breedInfo!
            }
            
            view.backgroundColor = UIColor.white
            pupPreviewImageView.isHidden = true
            submitButton.isHidden = true
            breedNameLabel.isHidden = false
            breedNameLabel.text = breedNameAsString
            
            // create card to display results
            card = createCardForTheHoes(title: breedNameAsString, image: (pupPreviewImageView?.image)!)
            view.addSubview(card)
            
            // hide the animation
            loadingView.hide()
        }
        
        if (breed == nil) {
            let alert = UIAlertController(title: "Not able to identify breed", message: "Press OK below to retake the picture", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.loadingView.hide()
                self.setupCamera()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func sendResponseError(_ response: Int) {
        if response == 500 {
            let alert = UIAlertController(title: "Server is down", message: "Press OK below to retake the picture", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.loadingView.hide()
                self.setupCamera()
            }))
            self.present(alert, animated: true)
        }
        
        let alert = UIAlertController(title: "Bad Gateway", message: "Press OK below to retake the picture", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.loadingView.hide()
            self.setupCamera()
        }))
        self.present(alert, animated: true)
    }
}

extension CameraQRViewController: LuminaDelegate {
    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
    }
    
    func dismissed(controller: LuminaViewController) {
        controller.dismiss(animated: false, completion: nil)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    func detected(metadata: [Any], from controller: LuminaViewController) {
        if (metadata.count == 0 ) { return }
        
        if (hasQRMetadataBeenScanned != true) {
            print("Trump: Youre fired")
            hasQRMetadataBeenScanned = true
            
            if  let metadataObj = metadata[0] as? AVMetadataMachineReadableCodeObject  {
                if metadataObj.type == AVMetadataObject.ObjectType.qr {
                    if let metadataString = metadataObj.stringValue {
                        print(metadataString)
                        dismiss(animated: false, completion: nil)
                        
                        let formattedMetadata = String(metadataString.filter { !" \n\t\r".contains($0) })
                        let ref = Database.database().reference(withPath: "LostPups").child(formattedMetadata)
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            print("\(snapshot)")
                            
                            if (!snapshot.exists()) {
                                print("This dog either doesn't exist or has not been reported lost.")
                                let alert = UIAlertController(title: "Dog is not lost", message: "This dog either does not exist in our system or has not been reported lost by its owner", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            } else {
                                let dick = snapshot.value as! [String : Any]
                                let dogName = dick["dogName"] as! String
                                let dogLover = dick["dogLover"] as! [String:Any]
                                print(dogName)
                                
                                // Change the found boolean in the LostDog object to be true to send notifications
                                let ref = Database.database().reference().root.child("LostPups").child(formattedMetadata)
                                ref.updateChildValues(["found" : true])
                                ref.updateChildValues(["latitude" : self.currentUserCoordinateLocation?.coordinate.latitude])
                                ref.updateChildValues(["longitude" : self.currentUserCoordinateLocation?.coordinate.longitude])
                                
                                let alert = UIAlertController(title: "You've found, \(dogName)!", message: "Your location has been sent to the owner. Would you like to send a message?", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                                    if !MFMessageComposeViewController.canSendText() {
                                        print("SMS services are not available")
                                    }
                                    
                                    let composeVC = MFMessageComposeViewController()
                                    composeVC.messageComposeDelegate = self as MFMessageComposeViewControllerDelegate
                                    
                                    // Configure the fields of the interface.
                                    composeVC.recipients = [dogLover["phoneNumber"] as! String]
                                    composeVC.body = "Hello, \(dogLover["name"] ?? "")! Good news, your dog, \(dogName) has been found!"
                                    
                                    // Present the view controller modally.
                                    self.present(composeVC, animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        
        // Dismiss the message compose view controller.
        self.defaultMessageForUser.isHidden = false
        controller.dismiss(animated: true, completion: nil)
    }
    
    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
        view.backgroundColor = UIColor.black
        breedNameLabel.isHidden = true
        if self.card != nil {
            self.card.isHidden = true
        }
        controller.dismiss(animated: false) {
            self.pupPreviewImageView.contentMode = .scaleToFill
            self.pupPreviewImageView.image = stillImage
            self.submitButton.isHidden = false
        }
    }
}

extension CameraQRViewController {
    private func createCardForTheHoes(title: String, image: UIImage) -> CardHighlight {
        let card = CardHighlight(frame: CGRect(x: 10, y: 112, width: 355, height: 595))
        card.shadowColor = UIColor.gray
        card.backgroundImage = image
        card.itemTitle = ""
        card.title = ""
        card.itemSubtitle = ""
        card.buttonText = "Details"
        card.textColor = UIColor.white
        card.hasParallax = false
        
        // set the photo sent from the UIImagePicker to be nil so it doesnt make the UI awful
        photoFromFileSystem = nil
        
        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent") as! CardContentViewController
        cardContentVC.breedInfoDetails = breedInfoGlobal
        cardContentVC.breedNameSent = breedNameGlobal
        cardContentVC.gaugeProbRating = CGFloat(probabilityRatingGlobal)
        print(breedInfoGlobal)
        card.shouldPresent(cardContentVC, from: self, fullscreen: true)
        return card
    }
}

