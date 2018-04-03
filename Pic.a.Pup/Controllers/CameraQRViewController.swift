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

class CameraQRViewController: UIViewController {
    
    fileprivate var card: PresenterCard!
    
    /// Conent area.
    fileprivate var presenterView: UIImageView!
    fileprivate var contentView: UILabel!
    
    /// Bottom Bar views.
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    fileprivate var favoriteButton: IconButton!
    fileprivate var shareButton: IconButton!
    
    /// Toolbar views.
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    
    @IBOutlet weak var pupPreviewImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    let locationManager = CLLocationManager()
    let camera = LuminaViewController()
    let firebaseManager = FirebaseManager()
    let networkManager = NetworkManager()
    let utility = Utility()
    let loadingView = RSLoadingView()
    
    // Location info to be updated by utility delegate **should maybe change utility to LocationUtility haha
    var currentUserCoordinateLocation: CLLocation?
    var currentUserPlacemark: CLPlacemark?
    var downloableUrlFromFirebase: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.delegate = self
        tabBarController?.tabBar.isHidden = false
        pupPreviewImageView.image = nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add those colorz
        //view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        view.backgroundColor = UIColor.black
        
        utility.delegate = self
        networkManager.delegate = self
        camera.delegate = self
        camera.trackMetadata = true
        camera.resolution = .highest
        
        locationManager.delegate = utility
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //locationManager.delegate = utility
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        
        submitButton.isHidden = true
        pupPreviewImageView.isHidden = false
        submitButton.isHidden = true
    }
    
    func setupCamera() {
        tabBarController?.tabBar.isHidden = true
        present(camera, animated: true, completion: nil)
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
        
        // Hide existing views to make more for new analysis data
        view.backgroundColor = UIColor.darkGray
        pupPreviewImageView.isHidden = true
        submitButton.isHidden = true
        
        if let breedNameAsString = breed {
            if let breedInfoAsString = breedInfo {
                preparePresenterView()
                prepareDateFormatter()
                prepareDateLabel()
                prepareMoreButton()
                prepareToolbar(breedName: breedNameAsString)
                prepareContentView(breedInfo: breedInfoAsString)
                preparePresenterCard()
                
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
        controller.dismiss(animated: false) {
            // still images always come back through this function, but live photos and depth data are returned here as well for a given still image
            // depth data must be manually cast to AVDepthData, as AVDepthData is only available in iOS 11.0 or higher.
            
            //if let window = UIApplication.shared.keyWindow {
              //  self.pupPreviewImageView.frame = window.frame
            //}
            self.pupPreviewImageView.image = stillImage
            self.submitButton.isHidden = false
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }
}

extension CameraQRViewController {
    fileprivate func preparePresenterView() {
        presenterView = UIImageView()
        presenterView.image = pupPreviewImageView.image?.resize(toWidth: view.frame.width)
        presenterView.image = presenterView.image?.resize(toHeight: 550)
        //presenterView.image = UIImage(named: "pattern")?.resize(toWidth: view.width)
        presenterView.contentMode = .scaleAspectFill
    }
    
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    fileprivate func prepareToolbar(breedName: String) {
        toolbar = Toolbar(rightViews: [moreButton])
        toolbar.title = breedName
        toolbar.titleLabel.textAlignment = .left
        toolbar.titleLabel.font = UIFont.init(name: "Pacifico-Regular", size: 20)
        //toolbar.detail = breedInfo
        //toolbar.detailLabel.textAlignment = .left
        //toolbar.detailLabel.textColor = Color.blueGrey.base
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareContentView(breedInfo: String) {
        contentView = UILabel()
        contentView.numberOfLines = 2
        contentView.text = breedInfo
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    fileprivate func preparePresenterCard() {
        card = PresenterCard()
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .wideRectangle2
        card.presenterView = presenterView
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .square3
        view.layout(card).horizontally(left: 10, right: 10)
        view.layout(card).vertically(top: 50, bottom: 100)
    }
}

