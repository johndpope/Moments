//
//  NewCategoryViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-06.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol NewCategoryViewControllerDelegate {
    func newCategory(controller: NewCategoryViewController, category: CategoryEntry)
}

class NewCategoryViewController: UIViewController,
    UIViewControllerTransitioningDelegate,
    ColourPickerViewControllerDelegate {
    
    var delegate: NewCategoryViewControllerDelegate?
    var categoryName: UITextField!
    var categoryColour: UIButton!

    convenience init() {
        self.init(delegate: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(delegate: NewCategoryViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
        
        initUI()
    }
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,20,windowWidth-40, 230))
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.cornerRadius = 20.0
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0, 0)
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.5
        
        let cancelButton = UIButton(frame: CGRectMake(15,28,60,30))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        cancelButton.addTarget(self, action: "cancelNewCategory", forControlEvents: .TouchUpInside)
        
        let saveButton = UIButton(frame: CGRectMake(self.view.frame.width - 85, 28, 60, 30))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        saveButton.addTarget(self, action: "saveNewCategory", forControlEvents: .TouchUpInside)
        
        let nameLabel = UILabel(frame: CGRectMake(20,85,60,30))
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor.customGreenColor()
        
        let colourLabel = UILabel(frame: CGRectMake(20,145,60,30))
        colourLabel.text = "Colour"
        colourLabel.textColor = UIColor.customGreenColor()
        
        self.categoryName = UITextField(frame: CGRectMake(90,85,210,30))
        self.categoryName.layer.cornerRadius = 8.0
        self.categoryName.layer.borderWidth = 1.0
        self.categoryName.layer.borderColor = UIColor.customGreenColor().CGColor
        
        self.categoryColour = UIButton(frame: CGRectMake(90,145,210,30))
        self.categoryColour.setTitle("Pick Colour", forState: .Normal)
        self.categoryColour.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        self.categoryColour.addTarget(self, action: "pickCategoryColour", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(cancelButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(nameLabel)
        self.view.addSubview(colourLabel)
        self.view.addSubview(categoryColour)
        self.view.addSubview(categoryName)
    }
    
    func saveNewCategory() {
        if let delegate = self.delegate {
            delegate.newCategory(self, category: getCategoryEntry())
        }
    }
    
    func cancelNewCategory() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickCategoryColour() {
        let colourPickerVC: ColourPickerViewController = ColourPickerViewController(initialColour: categoryColour.backgroundColor, delegate: self)
        self.presentViewController(colourPickerVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
            
            return CategoryPresentationController(presentedViewController: presented,
                presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
        return CategoryPresentationAnimationController()
    }
    
    
    func getCategoryEntry() -> CategoryEntry {
        let name = categoryName.text!
        if let colour = categoryColour.backgroundColor {
            return CategoryEntry(colour: colour, name: name)
        }
        
        return CategoryEntry(colour: UIColor.whiteColor(), name: name)
    }
    
    
    
    // ColourPickerViewController Delegate
    func selectColor(controller: ColourPickerViewController, colour: UIColor) {
        controller.dismissViewControllerAnimated(false, completion: nil)
        self.categoryColour.backgroundColor = colour
        self.categoryColour.setTitle("", forState: .Normal)
    }

}

