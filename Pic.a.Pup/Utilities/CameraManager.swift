//
//  CameraManager.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/21/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import UIKit
import Lumina

class CameraManager {
    
    func noCameraAvailable() -> UIAlertController {
        let alertVC = UIAlertController(title: "No Camera",
                                        message: "Sorry, this device has no camera",
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style:.default,
                                     handler: nil)
        alertVC.addAction(okAction)
        return alertVC
    }
    
    func launchPhotoLibrary(picker: UIImagePickerController) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        //present(picker, animated: true, completion: nil)
        //picker.popoverPresentationController?.barButtonItem = sender
    }
    
    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
        
    }
}
