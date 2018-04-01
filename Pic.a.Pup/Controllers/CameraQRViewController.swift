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

class CameraQRViewController: UIViewController {
    
    @IBOutlet weak var pupPreviewImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    let camera = LuminaViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add those colorz
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        view.backgroundColor = UIColor.black
        
        camera.delegate = self
        camera.trackMetadata = true
        camera.resolution = .highest
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        submitButton.isHidden = true
        pupPreviewImageView.isHidden = false
        submitButton.isHidden = true
    }
    
    func setupCamera() {
        present(camera, animated: true, completion: nil)
    }
    
    @IBAction func submitPhotoForAnalysis(_ sender: Any) {
        let loadingView = RSLoadingView()
        loadingView.show(on: view)
        
        // make network call and wait for response to update UI
        
        // Hide existing views to make more for new analysis data
        pupPreviewImageView.isHidden = true
        submitButton.isHidden = true
        loadingView.hide()
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
        //print(metadata)
        
        if (metadata.count == 0 ) { return }
        
        if  let metadataObj = metadata[0] as? AVMetadataMachineReadableCodeObject  {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                if let metadataString = metadataObj.stringValue {
                    print(metadataString)
                    dismiss(animated: false, completion: nil)
                }
            }
        } else {
            //dismiss(animated: false, completion: nil)
            return
        }
    }
    
    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
        controller.dismiss(animated: false) {
            // still images always come back through this function, but live photos and depth data are returned here as well for a given still image
            // depth data must be manually cast to AVDepthData, as AVDepthData is only available in iOS 11.0 or higher.
            
            DispatchQueue.main.async(execute: {
                self.pupPreviewImageView.image = stillImage
                self.submitButton.isHidden = false
            })
        }
    }
}

