//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Matthew Dean Furlo on 5/2/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    //create two label variables and an UIImageView variable. Attach them to the storybaord. Theses cell classes will be used by the UICollectionView
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
}
