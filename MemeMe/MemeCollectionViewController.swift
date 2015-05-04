//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Matthew Dean Furlo on 5/2/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import Foundation

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    //create a variable of the UICollectionView and attach it to the UICollectionView in storybaord
    @IBOutlet var mainCollectionView: UICollectionView!
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //get the array of Memes from the AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        //reload the UICollectionView everytime the page is loaded. New memes will appear in the collection
        self.mainCollectionView.reloadData()
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Set the title and add the "add" button that will bring us to the meme editor.
        self.navigationItem.title = "Sent Memes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action:"goToMemeEditor" )
    }
    
    func goToMemeEditor(){
        
        //This function will create an instance of ViewController, which contains all the meme editing tools and present it.
        var controller:ViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //necessary for delegate protocol
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //necessary for delegate protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //deque a cell and prepare it for new cell information. Set it as an instance of MemeCollectionViewCell.
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        //Grab the correct Meme object form the array at indexPath.row. Set the top and bottom text labels to the top and bottom text of the meme. Add the memeImage as well and finally return the cell
        let currentMeme = self.memes[indexPath.row]
        cell.topText.text = currentMeme.topText
        cell.bottomText.text = currentMeme.bottomText
        cell.memeImageView?.image = currentMeme.memedImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //creat an instance of the MemeViewController pass it the meme object for the selected cell fo the collection
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        detailController.meme = self.memes[indexPath.row]
        
        //display the MemeViewController.
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}