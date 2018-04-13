//
//  NetworkManager.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/18/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    
    weak var delegate: NetworkProtocolDelegate?
    
    // Temp API endpoints....i know they shouldnt be here
    let testUrl = "http://httpbin.org/post"
    let backendEndpoint = "18.219.234.144"
    
    func sendPostToServer(parameters: Dictionary<String, Any>) {
        Alamofire.request("http://18.188.145.20", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        //print("\(result)")
                        self.delegate?.sendResponseJSONData(result)
                    }
                    break
                case .failure(let error):
                    print("error from Alamofire \(error)")
                    
                    if let errorType = response.response?.statusCode  {
                        if errorType == 502 {
                            self.delegate?.sendResponseError(errorType)
                        }
                    }
                }
        }
    }
    
    func getDogParksFromLocation(parameters: Dictionary<String, Any>, completionBlock: @escaping(Any) -> Void) {
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?",
                          method: .get,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: nil)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let jsonDict = JSON as? NSDictionary ?? [:]
                    completionBlock(jsonDict)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }
}

protocol NetworkProtocolDelegate: class {
    func sendResponseJSONData(_ response: Any)
    func sendResponseError(_ response: Int)
}

