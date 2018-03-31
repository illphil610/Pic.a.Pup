//
//  Utility.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/15/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit

class Utility: NSObject, CLLocationManagerDelegate  {
    
    var placemark: CLPlacemark?
    var locationCoords: CLLocation?
    weak var delegate: UtilityDelegate?
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
        
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%]).{6,20})"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    // Location delegate stuff
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        locationCoords = locations[0]
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error)-> Void in
            if let places = placemarks {
                self.placemark = places[0]
                self.delegate?.sendPlacemarkData(self.placemark!)
                self.delegate?.sendLocationCoorData(self.locationCoords!)
            } else if let error = error {
                print("Reverse geocoder failed with error: \(String(describing: error.localizedDescription))")
                return
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func sendPlacemark() -> CLPlacemark {
        return placemark!
    }
}

protocol UtilityDelegate: class {
    func sendLocationCoorData(_ locationCoords: CLLocation)
    func sendPlacemarkData(_ placemark: CLPlacemark)
}
