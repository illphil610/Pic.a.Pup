//
//  CardContentViewController.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/8/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import GaugeKit
import MapKit

class CardContentViewController: UIViewController {
    
    @IBOutlet weak var breedInfoLabel: UILabel!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var gaugeView: Gauge!
    @IBOutlet weak var probLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var breedNameSent = ""
    var breedInfoDetails = ""
    var gaugeProbRating: CGFloat = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        breedInfoLabel.text = breedInfoDetails
        breedNameLabel.text = breedNameSent
        gaugeView.rate = gaugeProbRating * 10
        probLabel.text = "\( Double((gaugeProbRating * 100)).rounded(toPlaces: 2))%"
    }
}
