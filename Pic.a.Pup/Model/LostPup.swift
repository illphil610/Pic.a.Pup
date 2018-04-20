//
//  LostPup.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/5/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation

struct LostPup: Codable {
    var dogName: String
    var dogLover: DogLover
    var found: Bool
    var fcm_id: String
    var latitude: Double
    var longtitude: Double
}
