//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Matthew Dean Furlo on 4/29/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import UIKit

class MemeViewController : UIViewController {
    
    //Main UIImage to display
    
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var hidden = false
    
    //create an instance of the meme struct that will be sent from the navigation controller.
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide the tab bar from the tab controller. It has no affect on this page.
        self.tabBarController?.tabBar.hidden = true
        
        //set the image to the memed image in the meme object.
        self.imagePickerView!.image = meme.memedImage
        
        //scale to the image to keep it's aspect ratio, looking nice.
        imagePickerView.contentMode = .ScaleAspectFill
        self.hideButton.setTitle("", forState: .Normal)
    }
    
    //The navigation bar can block some of the image, so if you tap anywhere on the picture the navbar is hidden and unhidden
    @IBAction func hideNavBar(sender: AnyObject) {
        if !hidden {
            self.navigationController?.navigationBar.hidden = true
            hidden = true
        } else {
            self.navigationController?.navigationBar.hidden = false
            hidden = false
        }
    }
    
    //this function will dismiss the view controller, sending us back to the
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //make the tab bar visible again.
        self.tabBarController?.tabBar.hidden = false
    }
}
