//
//  ViewController.swift
//  MemeMe
//
//  Created by Matthew Dean Furlo on 4/19/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //create an empty array of meme instances
    var memes: [Meme]!
    
    //create outlets that will be used by the view controller. Anything that gets manipulated is created here
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var cameraButton: UIBarButtonItem!
    var cameraPresent: Bool!
    
    //create two instances of the MemeMeTextField delegate. One for each of the text fields.
    let topTextFieldDelegate = MemeMeTextField()
    let bottomTextFieldDelegate = MemeMeTextField()
    
    //create a dictionary that defines the text charachtersitics of the text fields. This is what gives them the "meme" look.
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.whiteColor(),
        NSStrokeWidthAttributeName : NSNumber(double: -4.0),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName : UIColor.blackColor()
        
    ]
    
    //hides the status bar on this controller. I prefer the look, but it could be hidden only when the meme is being created too.
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set all the charachteristics of the top text field. Attach it to a delegate, set the starting text, give it the "meme" attributes and center align the text.
        self.topTextField.delegate = self.topTextFieldDelegate
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        //set all the charachteristics of the bottom text field. Attach it to a delegate, set the starting text, give it the "meme" attributes and center align the text.
        self.bottomTextField.delegate = self.bottomTextFieldDelegate
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center

        //create the "share" button, add it to the navigation bar and disable it. It will be enabled only after a picture is added.
        self.navTitle.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "ShareAMeme")
        self.navTitle.leftBarButtonItem?.enabled = false
        
        //create a "cancle" button, and add it to the navigation bar. This should be enabled even if there are no memes in the table view. I like it disabled, I think it looks nicer, but whatever.
        self.navTitle.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismiss")

        //subscibe to the KeybaordNotificaions() from the Notification center. This will be used by the bottom text field
        self.subscribeToKeyboardNotifications()
        
        //grab the current meme array from the AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        if memes.count == 0 {
            //if you want to disable the "cancle" button so there has to be something in the table view to use it, then uncomment the next line.
            //self.navTitle.rightBarButtonItem?.enabled = false
        }
        
        //checks in a camera is present and disables the button if it's not. Should only affect the app in the simulator.
        cameraPresent = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //this is where all the tool bar items are created and added to the toolbar.
        createToolbarItems()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribe from the KeyboardNotifications. Doing this here will unsubscribe you when the view controller is dismissed. It will also do it when the imagePickerController is dismissed. To deal with that you have to enable again when after everytime the imagePicker is dismissed.
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func pickAnImage() {
        
        //create a and present an UIImagePickerController that will allow you to select photos from the PhotoLibrary. This is an Action attached to the storyboard button.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func pickAnImageFromCamera () {
        
        //create and present an UIImagePickerController that will allow you to select photos from the Camear. This is an Action attached to the storyboard button.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func createToolbarItems(){
        //this function creates and adds all the bar button items that are needed for the tool bar.
        self.toolBar.items?.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        self.cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "pickAnImageFromCamera")
        self.toolBar.items?.append(self.cameraButton)
        self.cameraButton.enabled = cameraPresent
        var fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: self, action: nil)
        fixedSpace.width = 80
        self.toolBar.items?.append(fixedSpace)
        self.toolBar.items?.append(UIBarButtonItem(title: "Pick", style: .Plain, target: self, action: "pickAnImage"))
        self.toolBar.items?.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
    }
    
    //This function is the exit function for the view cotnroller. It will share the meme, add it to the Meme array in the AppDelegate and finally dismiss the view controller. Should be fun!
    func ShareAMeme() {
        
        // call the genrateMemedImage function and set the return to the "meme" variable.
        let meme = generateMemedImage()
        
        //create an activityViewController. pass the "meme" image to the controller so you can share it.
        var activityViewController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        //tell the activityViewController what to do when it's actions are complete.
        activityViewController.completionWithItemsHandler = {(actvityType, completed, returnedItems, activityError) in
            
            //the meme variable only exists in the scope of this function, so we'll pass the meme that was shared to the save() function as a parameter
            self.save(meme)
            
            //dismiss the acitivityViewController, than dismiss the call the dismiss() function, the dismiss function handles everything necessary to dismiss the ViewController.
            activityViewController.dismissViewControllerAnimated(true, completion: nil)
            self.dismiss()
        }
        
        //now that the activityViewController is ready to rock and roll, present it to the users.
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func dismiss(){
        //I don't know why, but I orignally thought there would be more involved in dismissing the ViewController. If I think of something else to do, I can add it to this function.
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        //This function will be called by both the camera and the library, there are three posibilites when in the library, an edited image, the original image not picking an image. This tests for all three cases and handles them all. We set the image that is selected to the global image variable, then we enable the "share" button. Unless nothing was selected, then it's sent as a flag to the terminal.
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imagePickerView.image = image
            println("an edited image was picked")
            self.navTitle.leftBarButtonItem?.enabled = true
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            println("an original image was picked")
            self.navTitle.leftBarButtonItem?.enabled = true
        } else {
            println("no image was picked")
        }
        
        //this resizes and streches the image to the correct size.
        imagePickerView.contentMode = .ScaleAspectFill
        
        //once the image is picked, set and scaled, dismiss the viewController.
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //since the "dismissViewCOntroller" unsubscribes us from the keyboardNotifications, we just go ahead and resubscribe right here.
        self.subscribeToKeyboardNotifications()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //this function is great if you want to dismiss the imagePickerController AND something else.
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        //there are two observers in the default NotificationCenter we care about, the Keyboard appearing and disappearing. This is where we add both observers.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        //this is where the observers are removed when whenever the viewWillDisapear is called.
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(Notification: NSNotification) {
        
        //this function is called when the keyboard is called, but we only really care when the bottom text field calls for it. Check to make sure that it is the bottom text field, then set the height of frame to the height of the keybaord. This shifts the entire frame up so the bottom text field is visible when the keyboard is up. Digital high five!
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(Notification)
        }
    }
    
    func keyboardWillHide(Notification: NSNotification) {
        //As much fun as it was moving the whole frame out of the way for the keybaord, we should probably put it back now that the keyboard is disappearing. Here we'll again to check to make sure it's the bottom keyboard we're dealing with, than move the frame back in place as the keyboard leaves.
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(Notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //here we create a notification an object of the user info that is sent by the keyboard.
        let userInfo = notification.userInfo
        //the user info is a dictionary, one of the key values hapens to hold a CGRect of the keyboard. Well grab just the height parameter and retun that.
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func generateMemedImage() -> UIImage {
        
        //hide the toolbard and the navbar. This will leave only the picture and top/bottom text visible.
        self.toolBar.hidden = true
        self.navBar.hidden = true
        
        //this creates chunck of code will grab everything that's visible on the screen and turn it in to a UIImage.
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //make the toolbar and navbar visible again.
        self.toolBar.hidden = false
        self.navBar.hidden = false
        
        //return the UIImage generated.
        return memedImage
    }
    
    func save(memedImage: UIImage){
        
        //this function create a new instance of the meme struct and initialize it with all the information it needs.
        var meme = Meme( topTextField.text!, bottomTextField.text!, imagePickerView.image!, memedImage)
        
        //here we grab an instance of AppDelegate and amend the new meme to the end of the array. This is how we "save" it to the phone. 
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
}

