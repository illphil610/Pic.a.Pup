//
//  FirebaseManager.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/16/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
import Firebase

struct Constants {
    struct Pups {
        static let imagesFolder: String = "PupImages"
        static let feedResult: String = "FeedDogSearchResult"
    }
}

class FirebaseManager: NSObject {
    
    func uploadImageToFirebase(_ image: UIImage, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imagesReference = storageReference.child(Constants.Pups.imagesFolder).child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let _ = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
        } else {
            completionBlock(nil, "image could not be converted to Data.")
        }
    }
    
    func saveObjectToFirebase(_ breed: String, _ dogImageSent: String, _ probability: Double) {
        let databaseReference = Database.database().reference().child("FeedDogSearchResult")
        let key = databaseReference.childByAutoId().key
        
        let feedDogSearchResult = try? FeedDogSearchResult(breed: breed, dogImageSent: dogImageSent, probability: probability).asDictionary()
        databaseReference.child(key).setValue(feedDogSearchResult)
    }
    
    func getFeedSearchResultList() -> Array<DogSearchResult> {
        var searchFeedList: Array<DogSearchResult> = Array()
        let dbRef = Database.database().reference().child(Constants.Pups.feedResult)
        dbRef.observe(.value, with: { (snapshot) in
            //print(snapshot)
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if snap.value != nil {
                    let dict = snap.value as! [String: String]
                    //print(dict)
                    let breedName = dict["breed"]
                    let downloadUrl = dict["dogImageSent"]
                    let result = DogSearchResult(breed: breedName!, url: downloadUrl!)
                    print(result)
                    searchFeedList.append(result)
                }
            }
        })
        print(searchFeedList.count)
        return searchFeedList
        
    }
    
    func getImageFromFirebase(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }
}
