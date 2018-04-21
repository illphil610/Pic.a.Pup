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
    
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parksTabBarItem: UITabBarItem!
    @IBOutlet weak var shopsTabBarItem: UITabBarItem!
    @IBOutlet weak var vetsTabBarItem: UITabBarItem!
    
    let googleAPIKEY = "AIzaSyBYCg8qITAAD2iPqPWfKM-Qi_UaM4urjWY"
    let googlePlacesEndpoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.mapView.frame = self.view.bounds
        
        removeAllAnnotations()
        Locator.currentPosition(accuracy: .neighborhood, onSuccess: { location in
            print(location)
            self.centerMapOnLocation(location: location)
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
        }, onFail: { error, location  in
            print(error)
        })
        
        if lat != nil {
            if lon != nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                mapView.addAnnotation(annotation)
                print("made it here")
            }
        }
    }
    
    @IBAction func goBackToProfile(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let regionRadius: CLLocationDistance = 16000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func shopsBarButtonPressed(_ sender: Any) {
        let parameters = ["key" : "AIzaSyBYCg8qITAAD2iPqPWfKM-Qi_UaM4urjWY",
                          "location" : "\(lat ?? 0.0),\(lon ?? 0.0)",
                          "radius" : "16000",
                          "keyword" : "dog",
                          "type" : "store"]
        removeAllAnnotations()
        makeGooglePlacesNetworkCall(parameter: parameters)
    }
    @IBAction func parksBarButtonPressed(_ sender: Any) {
        let parameters = ["key" : "AIzaSyBYCg8qITAAD2iPqPWfKM-Qi_UaM4urjWY",
                          "location" : "\(lat ?? 0.0),\(lon ?? 0.0)",
                          "radius" : "16000",
                          "keyword" : "dog",
                          "type" : "park"]
        removeAllAnnotations()
        makeGooglePlacesNetworkCall(parameter: parameters)
    }
    
    @IBAction func vetsBarButtonPressed(_ sender: Any) {
        let parameters = ["key" : "AIzaSyBYCg8qITAAD2iPqPWfKM-Qi_UaM4urjWY",
                          "location" : "\(lat ?? 0.0),\(lon ?? 0.0)",
                          "radius" : "16000",
                          "type" : "veterinary_care"]
        removeAllAnnotations()
        makeGooglePlacesNetworkCall(parameter: parameters)
    }
    
    func removeAllAnnotations() {
        for annotation in self.mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
    }
    
    func makeGooglePlacesNetworkCall(parameter: [String : String]) {
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?",
                          method: .get, parameters: parameter, headers: nil).responseJSON { response in
                            switch response.result {
                            case .success(let responseJSON):
                                print(responseJSON)
                                let jsonDict = JSON(responseJSON)
                                if let results = jsonDict["results"].array {
                                    print(results)
                                    for places in results {
                                        let name = places["name"].string
                                        let lat = places["geometry"]["location"]["lat"].double
                                        let lon = places["geometry"]["location"]["lng"].double
                                        let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                                        let dogPark = DogPark(title: name!, coordinate: coordinate)
                                        self.mapView.addAnnotation(dogPark)
                                    }
                                }
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                            }
        }
    }
}
