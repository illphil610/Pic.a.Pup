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
            .responseJSON{ response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        self.delegate?.sendResponseJSONData(result)
                    }
                    break
                case .failure(let error):
                    print(error)
            }
        }
    }
}

protocol NetworkProtocolDelegate: class {
    func sendResponseJSONData(_ response: Any)
}
