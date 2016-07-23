//
//  ImageAnnotationViewController.swift
//  Prototype
//
//  Created by Stefan Kofler on 13.04.16.
//  Copyright © 2016 Stephan Rabanser. All rights reserved.
//

import UIKit
import jot

protocol ImageAnnotationViewControllerDelegate {
    func imageAnnotated(image: UIImage)
}

class ImageAnnotationViewController: UIViewController {
    
    var image: UIImage!
    var delegate: ImageAnnotationViewControllerDelegate?
    
    private var jotViewController: JotViewController!
    
    private var imageView: UIImageView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = UIColor.whiteColor()
        title = "Annotate image"
        
        addImageView()
        addJotViewController()
        addBarButtonItems()
    }
    
    private func addImageView() {
        guard imageView == nil else { return }
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blackColor()
        imageView.image = image
        view.addSubview(imageView)
        
        let views: [String: AnyObject] = ["topGuide": topLayoutGuide, "bottomGuide": bottomLayoutGuide, "imageView": imageView]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[imageView]-|", options: [], metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[topGuide]-[imageView]-[bottomGuide]", options: [], metrics: nil, views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }
    
    private func addJotViewController() {
        guard jotViewController == nil else { return }
        
        jotViewController = JotViewController()
        jotViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChildViewController(jotViewController)
        view.addSubview(jotViewController.view)
        jotViewController.didMoveToParentViewController(self)
        
        jotViewController.state = JotViewState.Drawing
        jotViewController.drawingColor = UIColor.cyanColor()
        
        let leftConstraint = NSLayoutConstraint(item: jotViewController.view, attribute: .Left, relatedBy: .Equal, toItem: imageView, attribute: .Left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: jotViewController.view, attribute: .Right, relatedBy: .Equal, toItem: imageView, attribute: .Right, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: jotViewController.view, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: jotViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    private func addBarButtonItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonPressed(_:)))
    }
    
    // MARK: Actions
    
    func cancelButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.imageAnnotated(jotViewController.drawOnImage(image))
    }    
}