//
//  Meme.swift
//  MemeMe
//
//  Created by Matthew Dean Furlo on 4/23/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    //this struct will have for variables: the Top Text, the Bottom text, the original Image and the memed image.
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    //initiallzing an instance fo the struct requires all four variables to be passed as parameters and set
    init(_ topText: String, _ bottomText: String, _ originalImage: UIImage, _ memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    //return both the top and bottom text as single string
    var text: String {
        get{
            return topText + " " + bottomText
        }
    }
    
    //return the memedImage if looking for the "meme" in the struct.
    var meme: UIImage {
        get{
            return memedImage
        }
    }
    
}