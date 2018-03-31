//
//  DogSearchResult.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/15/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation

struct DogSearchResult : Codable {
    var breed: String
    var wikiBreedInfo : String
    var location: String
    var url : URL
}
