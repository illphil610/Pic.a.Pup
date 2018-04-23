//
//  FeedDogSearchResult.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/23/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation

struct FeedDogSearchResult : Codable {
    var breed: String
    var dogImageSent : String
    var probability: Double
}
