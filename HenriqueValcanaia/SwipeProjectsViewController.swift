//
//  ViewController.swift
//  Henrique Valcanaia
//
//  Created by Henrique Valcanaia on 4/16/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

// Teste commit

import UIKit
import Parse
import MDCSwipeToChoose

class SwipeProjectsViewController: UIViewController, MDCSwipeToChooseDelegate{
    
    var projects:NSMutableArray = NSMutableArray.new()
    let ChoosePersonButtonHorizontalPadding:CGFloat = 80.0
    let ChoosePersonButtonVerticalPadding:CGFloat = 20.0
    var currentProject:Project!
    var frontCardView:ChooseProjectView!
    var backCardView:ChooseProjectView!
    
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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //        // Display the first ChooseProjectView in front. Users can swipe to indicate
        //        // whether they like or dislike the person displayed.
        //        self.setFrontCardViewAndCurrentProject(self.popProjectViewWithFrame(frontCardViewFrame())!)
        //        self.view.addSubview(self.frontCardView)
        //
        //        // Display the second ChoosePersonView in back. This view controller uses
        //        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        //        // back views after each user swipe.
        //        self.backCardView = self.popProjectViewWithFrame(backCardViewFrame())!
        //        self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
        
        //        // Add buttons to programmatically swipe the view left or right.
        //        // See the 'nopeFrontCardView' and 'likeFrontCardView' methods.
        //        constructNopeButton()
        //        constructLikedButton()
    }
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(view: UIView) -> Void{
        println("You couldn't decide on \(self.currentProject.name)");
    }
    
    // This is called then a user swipes the view fully left or right.
    func view(view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void{
        
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        if(wasChosenWithDirection == MDCSwipeDirection.Left){
            println("You noped: \(self.currentProject.name)")
        }
        else{
            println("You liked: \(self.currentProject.name)")
            self.performSegueWithIdentifier("showProjectDetail", sender: self.currentProject)
        }
        
        // MDCSwipeToChooseView removes the view from the view hierarchy
        // after it is swiped (this behavior can be customized via the
        // MDCSwipeOptions class). Since the front card view is gone, we
        // move the back card to the front, and create a new back card.
        if(self.backCardView != nil){
            self.setFrontCardViewAndCurrentProject(self.backCardView)
        }
        
        backCardView = self.popProjectViewWithFrame(self.backCardViewFrame())
        //if(true){
        // Fade the back card into view.
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
        //        SVProgressHUD
        var query:PFQuery = Project.query()!
        query.whereKey("active", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                    NSLog("Objects: %@", objects!)
                    self.projects.setArray(objects!)
                    // Display the first ChooseProjectView in front. Users can swipe to indicate
                    // whether they like or dislike the person displayed.
                    self.setFrontCardViewAndCurrentProject(self.popProjectViewWithFrame(self.frontCardViewFrame())!)
                    self.view.addSubview(self.frontCardView)
                    
                    // Display the second ChoosePersonView in back. This view controller uses
                    // the MDCSwipeToChooseDelegate protocol methods to update the front and
                    // back views after each user swipe.
                    self.backCardView = self.popProjectViewWithFrame(self.backCardViewFrame())!
                    self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
                    
                    // Add buttons to programmatically swipe the view left or right.
                    // See the 'nopeFrontCardView' and 'likeFrontCardView' methods.
                    self.constructNopeButton()
                    self.constructLikedButton()
                    
//                    self.showModalTutorialView()
                })
            }
        }
    }
    
    func showModalTutorialView(){
        var nibView = NSBundle.mainBundle().loadNibNamed("Tutorial", owner: self, options: nil)[0] as! UIView
    
        for view in nibView.subviews{
            println(view)
        }

        var imageView1 = nibView.viewWithTag(42) as? UIImageView
        
        
        
        imageView1!.layer.cornerRadius = imageView1!.frame.size.width / 2
        imageView1!.clipsToBounds = true
        
        
        nibView.frame = self.view.bounds;
        nibView.backgroundColor = UIColor.clearColor()
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blur)
        blurView.frame = nibView.bounds
        blurView.addSubview(nibView)
        
        self.view.addSubview(blurView);
        self.view.bringSubviewToFront(blurView)
    }
    
    func defaultProjects() -> NSMutableArray{
        let project1: Project = Project.new()
        project1.name = "Cydria #1"
        project1.fullDescription = "Full description of Cydria #1"
        project1.url = "URL Cydria"
        let image: UIImage = UIImage(named: "cydria")!
        let imageData: NSData = UIImageJPEGRepresentation(image, 1.0);
        let imageFile: PFFile = PFFile(data: imageData)
        project1.image = imageFile
        project1.date = NSDate.new()
        
        
        let project2: Project = Project.new()
        project2.name = "Turn Off #2"
        project2.fullDescription = "Full description of Turn Off #2"
        project2.url = "URL Turn Off"
        let image2: UIImage = UIImage(named: "turnoff")!
        let imageData2: NSData = UIImageJPEGRepresentation(image2, 1.0);
        let imageFile2: PFFile = PFFile(data: imageData2)
        project2.image = imageFile2
        project2.date = NSDate.new()
        
        
        let project3: Project = Project.new()
        project3.name = "RU #3"
        project3.fullDescription = "Full description of RU #3"
        project3.url = "URL RU"
        let image3: UIImage = UIImage(named: "ru")!
        let imageData3: NSData = UIImageJPEGRepresentation(image3, 1.0);
        let imageFile3: PFFile = PFFile(data: imageData3)
        project3.image = imageFile3
        project3.date = NSDate.new()
        
        
        let project4: Project = Project.new()
        project4.name = "Mconf #4"
        project4.fullDescription = "Full description of Mconf #4"
        project4.url = "URL Mconf"
        let image4: UIImage = UIImage(named: "mconf")!
        let imageData4: NSData = UIImageJPEGRepresentation(image4, 1.0);
        let imageFile4: PFFile = PFFile(data: imageData4)
        project4.image = imageFile
        project4.date = NSDate.new()
        
        return [project1, project2, project3, project4]
    }
    
    func popProjectViewWithFrame(frame:CGRect) -> ChooseProjectView?{
        if(self.projects.count == 0){
            return nil;
        }
        
        // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
        // Each take an "options" argument. Here, we specify the view controller as
        // a delegate, and provide a custom callback that moves the back card view
        // based on how far the user has panned the front card view.
        var options:MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                var frame:CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y-(state.thresholdRatio * 10.0), CGRectGetWidth(frame), CGRectGetHeight(frame))
            }
        }
        
        // Create a ProjectView with the top Project in the people array, then pop
        // that Project off the stack.
        
        var projectView:ChooseProjectView = ChooseProjectView(frame: frame, project: self.projects.objectAtIndex(0) as! Project, options: options)
        
        for index in 0..<self.projects.count-1{
            //            NSLog("Swapping")
            self.projects.exchangeObjectAtIndex(index, withObjectAtIndex: index+1)
        }
        
        //        self.projects.removeAtIndex(0)
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
    func constructNopeButton() -> Void{
        let button:UIButton =  UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image:UIImage = UIImage(named:"nope")!
        button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding, CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState: UIControlState.Normal)
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "nopeFrontCardView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func constructLikedButton() -> Void{
        let button:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        let image:UIImage = UIImage(named:"liked")!
        button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding, CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding, image.size.width, image.size.height)
        button.setImage(image, forState:UIControlState.Normal)
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        button.addTarget(self, action: "likeFrontCardView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }
    func nopeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.Left)
    }
    func likeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.Right)
    }
}

