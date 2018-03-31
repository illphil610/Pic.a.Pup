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
    
    @IBOutlet weak var pupCardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pupCardImageView.layer.cornerRadius = 20
        pupCardImageView.clipsToBounds = true
    }
}
