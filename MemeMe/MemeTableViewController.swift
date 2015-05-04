
//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Matthew Dean Furlo on 4/28/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //create a variable of the UICollectionView and attach it to the UICollectionView in storybaord
    @IBOutlet var mainTableView : UITableView!
    var memes: [Meme]!
    
    // create a variable to keep track of the first time the app is open.
    var firstOpen = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //get the array of Memes from the AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        //if the memes array is empty and the app hasn't been opened, then navigate to the editor page and imdiately set the firstOpen variable to false. If the editor is dismissed it will stay dismissed.
        if memes.count == 0 && firstOpen {
            goToMemeEditor()
            firstOpen = false
        }
        
        //reload the UITableView everytime the page is loaded. New memes will appear in the table
        self.mainTableView.reloadData()
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //necessary for delegate protocol
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //deque a cell and prepare it for new cell information. Set it as an instance of UITableViewCell.
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        //Grab the correct Meme object form the array at indexPath.row. Set the top and bottom text labels to the top and bottom text of the meme. Add the memeImage as well and finally return the cell
        cell.textLabel?.text = meme.text
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //creat an instance of the MemeViewController pass it the meme object for the selected cell fo the collection
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        detailController.meme = self.memes[indexPath.row]
        
        //display the MemeViewController.
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}