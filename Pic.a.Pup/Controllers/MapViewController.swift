//
//  MapViewController.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/6/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import SwiftLocation
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let googleAPIKEY = "AIzaSyBYCg8qITAAD2iPqPWfKM-Qi_UaM4urjWY"
    let googlePlacesEndpoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Locator.currentPosition(accuracy: .neighborhood, onSuccess: { location in
            print(location)
            self.centerMapOnLocation(location: location)
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            let parameters = ["key" : "AIzaSyBYCg8qITAAD2iPqPWfKM-Qi_UaM4urjWY",
                              "location" : "\(lat),\(lon)",
                              "radius" : "16000",
                              "keyword" : "dog",
                              "type" : "park"]
            
            Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?",
                              method: .get, parameters: parameters, headers: nil).responseJSON { response in
                                switch response.result {
                                case .success(let responseJSON):
                                    print(responseJSON)
                                    //let jsonDict = JSON as? NSDictionary ?? [:]
                                    let jsonDict = JSON(responseJSON)
                                    if let results = jsonDict["results"].array {
                                        print(results)
                                        for places in results {
                                            let name = places["name"].string
                                            let lat = places["geometry"]["location"]["lat"].double
                                            let lon = places["geometry"]["location"]["lng"].double
                                            //print(lat, lon)
                                            let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                                            let dogPark = DogPark(title: name!, coordinate: coordinate)
                                            self.mapView.addAnnotation(dogPark)
                                            }
                                        }
                                case .failure(let error):
                                    print("Request failed with error: \(error)")
                                }
            }
        }, onFail: { error, location  in
            print(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToProfile(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let regionRadius: CLLocationDistance = 16000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        //let dogPark = DogPark(title: "Poop", locationName: "really hairy", isOpen: true, coordinate: location.coordinate)
        mapView.setRegion(coordinateRegion, animated: true)
        //mapView.addAnnotation(dogPark)
    }
}
