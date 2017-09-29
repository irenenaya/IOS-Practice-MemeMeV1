//
//  ViewController.swift
//  MemeMeV1 - Udacity
//  Creates a meme from images in photo album or camera
//  Created by Irene Naya on 9/22/17.
//  Copyright © 2017 OnkySoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    // MARK : Meme text attributes
    let memeTextAttributes:[String:AnyObject] = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.0 // negative value -> filled with foreground color.
    ]
     // MARK : View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start Over", style: .Plain, target: self, action: "startOver")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topText.delegate = self
        bottomText.delegate = self
        self.subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK : hide / show keyboard
    // functions that make view shift up when keyboard appears
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    // shift view up or down as needed according to y position and keyboard presence / absence
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
        }

    // MARK : IBActions
    
    @IBAction func pickPicture(sender : AnyObject) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.sourceType = .PhotoLibrary
        presentViewController(nextController, animated : true, completion: nil)
    }
    
    @IBAction func pickPictureFromCam(sender : AnyObject) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.sourceType = .Camera
        presentViewController(nextController, animated : true, completion: nil)
    }
    
    @IBAction func sharePicture(sender: AnyObject) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {  (activityType, complete, returnedItems, activityError ) in
            if complete {
                self.save(image)
            }
        }
        self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func savePicture(sender: AnyObject) {
        let image = generateMemedImage()
        save(image)        
    }
    
    @IBAction func startOver(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK : Image Picker controllers
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePView.image = image
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        shareButton.enabled = true
      
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK : Text field delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        textField.sizeToFit()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK : generating and saving memes
    func generateMemedImage() -> UIImage {
        toolbar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolbar.hidden = false
        return memedImage
    }
    
    func save(img : UIImage) {
        let meme = Meme(toptext: topText.text!, bottomtext: bottomText.text!, originalImage: imagePView.image!, memedImage: img)
        Meme.allMemes.append(meme)

    }
}

