//
//  SavedMemeCell.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 3/5/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeCell : UITableViewCell {
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var memeImageView: UIImageView!
    
    var topText: String? {
        didSet {
            topLabel.text = topText
        }
    }
    
    var bottomText: String? {
        didSet {
            bottomLabel.text = bottomText
        }
    }
    
    var memeImage: UIImage? {
        didSet {
            memeImageView.image = memeImage
        }
    }
}
