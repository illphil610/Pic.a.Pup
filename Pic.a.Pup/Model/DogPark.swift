//
//  DogPark.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/13/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import MapKit

class DogPark: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    var isOpen: Bool?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, isOpen: Bool, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.isOpen = isOpen
        self.coordinate = coordinate
        
        super.init()
    }
    
}
