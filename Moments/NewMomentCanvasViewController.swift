//
//  NewViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-19.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation
import CoreData

enum TouchMode : String {
    case Text = "Text",
         Image = "Image",
         Audio = "Audio",
         Video = "Video",
         Sticker = "Sticker",
         Default = "View"
}

class NewMomentCanvasViewController: UIViewController,UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EditTextItemViewControllerDelegate, MPMediaPickerControllerDelegate {
    
    let testMode : Bool = true
    var touchLocation : CGPoint?
    var touchMode : TouchMode = TouchMode.Default
    
    var savePageAccessed : Bool = false
    var savePage : NewMomentSavePageViewController?
    var manager : NewMomentManager = NewMomentManager()
    
    /*******************************************************************
     
        IBOUTLET AND IBACTION
     
     ******************************************************************/
    
    @IBOutlet weak var favouriteSetter: UIButton!
    @IBOutlet weak var addItemBar: UIToolbar!
    
    @IBAction func addItem(sender: AnyObject) {
        debug("[addItem] - +Item Button Pressed")
        if (addItemBar.hidden) {
            displayAddItemBar()
        } else {
            hideAddItemBar()
        }
    }
    
    @IBAction func selectTouchMode(sender: AnyObject) {
        debug("[selectTouchMode] - one of the add type selected")
        if let title = sender.currentTitle {
            self.touchMode = TouchMode(rawValue: title!)!
            debug("[selectTouchMode] - mode selected: " + String(self.touchMode))
            if (title == "View" && !(addItemBar.hidden)) {
                hideAddItemBar()
            }
        }
    }
    
    @IBAction func setFav(sender: AnyObject) {
        debug("[otherOptions] - favourite Button pressed")
        if self.manager.setFavourite() {
            favouriteSetter.backgroundColor = UIColor.redColor()
        } else {
            favouriteSetter.backgroundColor = UIColor.clearColor()
        }
    }
    
    @IBAction func goToSavePage(sender: AnyObject) {
        if (savePageAccessed) {
            print("presentView")
            presentViewController(self.savePage!, animated: true, completion: nil)
        } else {
            print("performSegue")
            performSegueWithIdentifier("newMomentToSavePageSegue", sender: self)
        }
    }
    
    func displayAddItemBar() {
        debug("[displayAddItemBar] - display bar")
        addItemBar.hidden = false
    }
    
    func hideAddItemBar() {
        debug("[hideAddItemBar] - hide bar")
        addItemBar.hidden = true
    }
    
    /*******************************************************************
     
        OVERRIDDEN UIVIEWCONTROLLER FUNCTIONS
     
     ******************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("New moment canvas page loaded")
        manager.setCanvas(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches.isEmpty) {
            debug("[touchesBegan] - no touch")
        } else {
            let touch = touches.first!
            self.touchLocation = touch.locationInView(touch.view)
            switch (self.touchMode) {
                case .Text:
                    addText()
                case .Image:
                    addImage()
                case .Audio:
                    addAudio()
                case .Video:
                    addVideo()
                case .Sticker:
                    addSticker()
                default:
                    break
            }
        }
        resetTouchMode()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNewTextModal" {
            let vc = segue.destinationViewController as! EditTextItemViewController
            vc.modalPresentationStyle = .OverCurrentContext
            vc.delegate = self
        } else if segue.identifier == "showOtherOptionPopover" {
            print("OtherOptionPopover segue begin")
            let vc = segue.destinationViewController as! OtherCanvasOptionViewController
            let popoverVC = vc.popoverPresentationController
            popoverVC?.delegate = self
        } else if segue.identifier == "newMomentToSavePageSegue" {
            savePageAccessed = true
            self.savePage = segue.destinationViewController as! NewMomentSavePageViewController
            self.savePage!.canvas = self
            self.savePage!.manager = self.manager
        }
    }
    
    /*******************************************************************
     
        HELPER FUNCTIONS
     
     ******************************************************************/
    
    func backFromSavePage() {
        self.savePage!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func debug(msg: String) {
        if (self.testMode) {
            print("[NewMomentCanvasViewController] - " + msg)
        }
    }
    
    func resetTouchMode(){
        self.touchMode = TouchMode.Default
    }
    
    
    /*******************************************************************
     
        ADD ITEM FUNCTIONS
     
     ******************************************************************/
    
    func addText(){
        self.performSegueWithIdentifier("showNewTextModal", sender: self)
    }
    
    func addImage(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func addAudio(){
        let audio = MPMediaPickerController(mediaTypes: .AnyAudio)
        audio.delegate = self
        audio.allowsPickingMultipleItems = false
        self.presentViewController(audio, animated: true, completion: nil)
    }
    
    func addVideo(){
        let video = MPMediaPickerController(mediaTypes: .AnyVideo)
        video.delegate = self
        video.allowsPickingMultipleItems = false
        self.presentViewController(video, animated: true, completion: nil)
    }
    
    func addSticker() {

    }
    
    /*******************************************************************
    
        DELEGATE FUNCTIONS
    
     ******************************************************************/
     
    // EditTextItemViewControllerDelegate functions
    func addText(controller: EditTextItemViewController, textView: UITextView) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.manager.addText(textView, location: self.touchLocation!)
        resetTouchMode()
    }
    
    func cancelAddTextItem(controller: EditTextItemViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        resetTouchMode()
    }
    
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.manager.addImage(image, location: self.touchLocation!, editingInfo: editingInfo)
    }
    
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("Video or audio selected")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        if let mediaItem: MPMediaItem = mediaItemCollection.representativeItem {
            debug("[mediaPicker] - " + String(mediaItem))
            self.manager.addMediaItem(mediaItem, location: self.touchLocation!)
        } else {
            debug("[mediaPicker] - mediaItem not found")
        }
    }
    
    // Functions for UIPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}