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

class CameraQRViewController: UIViewController {
    
    @IBOutlet weak var resultsCard: CardHighlight!
    
    @IBOutlet weak var breedNameLabel: UILabel!
    
    var card: CardHighlight!
    
    @IBOutlet weak var pupPreviewImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    let locationManager = CLLocationManager()
    //let camera = LuminaViewController()
    let firebaseManager = FirebaseManager()
    let networkManager = NetworkManager()
    let utility = Utility()
    let loadingView = RSLoadingView()
    
    // Location info to be updated by utility delegate **should maybe change utility to LocationUtility haha
    var currentUserCoordinateLocation: CLLocation?
    var currentUserPlacemark: CLPlacemark?
    var downloableUrlFromFirebase: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        pupPreviewImageView.image = nil
        submitButton.isHidden = true
        
        //card?.isHidden = true
        //breedNameLabel.text = ""
        //view.backgroundColor = UIColor.black
        //breedNameLabel.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add those colorz
        view.backgroundColor = UIColor.black
        breedNameLabel.isHidden = true
        
        card?.isHidden = true
        
        utility.delegate = self
        networkManager.delegate = self
        //camera.delegate = self
        //camera.trackMetadata = true
        //camera.resolution = .highest
        
        locationManager.delegate = utility
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = utility
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("viewDidAppear")
        submitButton.isHidden = true
        pupPreviewImageView.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func setupCamera() {
        
        // Hide views so you just see black when camera launches
        card?.isHidden = true
        pupPreviewImageView.isHidden = true
        submitButton.isHidden = true
        
        // Launch Lumina
        let camera = LuminaViewController()
        camera.delegate = self
        camera.trackMetadata = true
        camera.resolution = .highest
        
        tabBarController?.tabBar.isHidden = true
        present(camera, animated: true, completion: nil)
        //tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func submitPhotoForAnalysis(_ sender: Any) {
        loadingView.show(on: view)
        if let dogPictureTakenFromCamera = pupPreviewImageView.image {
            firebaseManager.uploadImageToFirebase(dogPictureTakenFromCamera, completionBlock: { (fileUrl, errorMessage) in
                if let url = fileUrl {
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
        let breed = responseJSON["breed"].string
        let breedInfo = responseJSON["breed_info"].string
        print(responseJSON)
        print(breed ?? "nah")
        breedNameLabel.isHidden = false
        
        
        if let breedNameAsString = breed {
            if let breedInfoAsString = breedInfo {
                
                // Hide existing views to make more for new analysis data
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
        }
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
        if  let metadataObj = metadata[0] as? AVMetadataMachineReadableCodeObject  {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                if let metadataString = metadataObj.stringValue {
                    print(metadataString)
                    dismiss(animated: false, completion: nil)
                    
                    // go to collar activity with QR data
                }
            }
        }
    }
    
    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
        view.backgroundColor = UIColor.black
        breedNameLabel.isHidden = true
        if self.card != nil {
            self.card.isHidden = true
        }
        controller.dismiss(animated: false) {
            self.pupPreviewImageView.image = stillImage
            self.submitButton.isHidden = false
        }
    }
}

extension CameraQRViewController {
    private func createCardForTheHoes(title: String, image: UIImage) -> CardHighlight {
        let card = CardHighlight(frame: CGRect(x: 10, y: 110, width: 350, height: 600))
        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
        card.shadowColor = UIColor.gray
        card.backgroundImage = image
        card.itemTitle = ""
        card.title = ""
        card.itemSubtitle = ""
        card.buttonText = "Details"
        card.textColor = UIColor.white
        card.hasParallax = true
        
        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
        card.shouldPresent(cardContentVC, from: self, fullscreen: true)
        return card
    }
}

