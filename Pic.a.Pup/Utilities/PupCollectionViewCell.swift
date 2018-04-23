//
//  PupCollectionViewCell.swift
//  Pic-a-Pup
//
//  Created by Philip on 3/24/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class PupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var probabilityLabel: UILabel!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var pupCardImageView: UIImageView!
    @IBOutlet weak var descriptionDetail: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionDetail.layer.cornerRadius = 20
        //descriptionDetail.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        descriptionDetail.isOpaque = false
        pupCardImageView.layer.cornerRadius = 20
        pupCardImageView.clipsToBounds = true
    }
}
