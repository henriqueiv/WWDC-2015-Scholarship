//
//  ViewController.swift
//  Henrique Valcanaia
//
//  Created by Henrique Valcanaia on 4/16/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

import MDCSwipeToChoose
import Parse
import SVProgressHUD
import UIKit

class SwipeProjectsViewController: UIViewController, MDCSwipeToChooseDelegate{
    
    var projects:NSMutableArray = NSMutableArray.new()
    var currentProject:Project!
    var frontCardView:ChooseProjectView!
    var backCardView:ChooseProjectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setProjects()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setProjects()
    }
    
    convenience init(){
        self.init()
        self.setProjects()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }
    
    func viewDidCancelSwipe(view: UIView) -> Void{
        // Handle cancel swipe. Not needed right now
    }
    
    func view(view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void{
        if(wasChosenWithDirection == MDCSwipeDirection.Right){
            self.performSegueWithIdentifier("showProjectDetail", sender: self.currentProject)
        }
        
        if(self.backCardView != nil){
            self.setFrontCardViewAndCurrentProject(self.backCardView)
        }
        
        backCardView = self.popProjectViewWithFrame(self.backCardViewFrame())
        
        // Fade the back card into view
        if(backCardView != nil){
            self.backCardView.alpha = 0.0
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.backCardView.alpha = 1.0
                },completion:nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ProjectViewController
        vc.project = sender as? Project
    }
    
    @IBAction func unwindSegue(sender: UIStoryboardSegue){
        
    }
    
    func setFrontCardViewAndCurrentProject(frontCardView:ChooseProjectView) -> Void{
        // Keep track of the project currently being chosen.
        // Quick and dirty
        self.frontCardView = frontCardView
        self.currentProject = frontCardView.project
    }
    
    func setProjects(){
        if let loader = self.activityIndicator{
            loader.hidden = false
            loader.startAnimating()
        }
        var query:PFQuery = Project.query()!
        query.whereKey("active", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.projects.setArray(objects!)
                    
                    self.setFrontCardViewAndCurrentProject(self.popProjectViewWithFrame(self.frontCardViewFrame())!)
                    self.view.addSubview(self.frontCardView)
                    
                    self.backCardView = self.popProjectViewWithFrame(self.backCardViewFrame())!
                    self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
                    
                    if let loader = self.activityIndicator{
                        loader.stopAnimating()
                        loader.hidden = true
                    }
                })
            }
        }
    }
    
    func popProjectViewWithFrame(frame:CGRect) -> ChooseProjectView?{
        if(self.projects.count == 0){
            return nil;
        }
        
        var options:MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                var frame:CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y-(state.thresholdRatio * 10.0), CGRectGetWidth(frame), CGRectGetHeight(frame))
            }
        }
        
        // Create a ChooseProjectView with the top Project in the projects array, then pop
        // that Project off the stack.
        var projectView:ChooseProjectView = ChooseProjectView(frame: frame, project: self.projects.objectAtIndex(0) as! Project, options: options)
        
        // Handle the stack
        for index in 0..<self.projects.count-1{
            self.projects.exchangeObjectAtIndex(index, withObjectAtIndex: index+1)
        }
        
        return projectView
    }
    func frontCardViewFrame() -> CGRect{
        var horizontalPadding:CGFloat = 20.0
        var topPadding:CGFloat = 60.0
        var bottomPadding:CGFloat = 200.0
        return CGRectMake(horizontalPadding,topPadding,CGRectGetWidth(self.view.frame) - (horizontalPadding * 2), CGRectGetHeight(self.view.frame) - bottomPadding)
    }
    
    func backCardViewFrame() ->CGRect{
        var frontFrame:CGRect = frontCardViewFrame()
        return CGRectMake(frontFrame.origin.x, frontFrame.origin.y + 10.0, CGRectGetWidth(frontFrame), CGRectGetHeight(frontFrame))
    }
    
    func nopeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.Left)
    }
    
    func likeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.Right)
    }
}

