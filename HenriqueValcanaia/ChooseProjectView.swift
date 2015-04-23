//
//  ChoosePersonView.swift
//  SwiftLikedOrNope
//
// Copyright (c) 2014 to present, Richard Burdish @rjburdish
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit
import Parse
import MDCSwipeToChoose

class ChooseProjectView: MDCSwipeToChooseView {
    
    let ChooseProjectViewImageLabelWidth:CGFloat = 42.0;
    var project: Project!
    var informationView: UIView!
    var nameLabel: UILabel!
    var carmeraImageLabelView:ImagelabelView!
    var interestsImageLabelView: ImagelabelView!
    var friendsImageLabelView: ImagelabelView!
    
    init(frame: CGRect, project: Project, options: MDCSwipeToChooseViewOptions) {
        super.init(frame: frame, options: options)
        self.project = project
        
        let projectImageFile = self.project.image! as PFFile
        projectImageFile.getDataInBackgroundWithBlock({ (remoteData: NSData?, error: NSError?) -> Void in
            
            if let imageData = remoteData where error == nil {
                let image = UIImage(data:imageData)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = image
                })
            }
            
            }, progressBlock: { (progress: Int32) -> Void in
                
                println(progress)
                
        })
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        UIViewAutoresizing.FlexibleBottomMargin
        
        self.imageView.autoresizingMask = self.autoresizingMask
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.backgroundColor = UIColor.whiteColor()
        constructInformationView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func constructInformationView() -> Void{
        var bottomHeight:CGFloat = 60.0
        var bottomFrame:CGRect = CGRectMake(0,
            CGRectGetHeight(self.bounds) - bottomHeight,
            CGRectGetWidth(self.bounds),
            bottomHeight);
        self.informationView = UIView(frame:bottomFrame)
        self.informationView.backgroundColor = UIColor.whiteColor()
        self.informationView.clipsToBounds = true
        self.informationView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        
        self.addSubview(self.informationView)
        constructNameLabel()
        //        constructCameraImageLabelView()
        //        constructInterestsImageLabelView()
        //        constructFriendsImageLabelView()
    }
    
    func constructNameLabel() -> Void{
        var leftPadding:CGFloat = 12.0
        var topPadding:CGFloat = 17.0
        var frame:CGRect = CGRectMake(leftPadding,
            topPadding,
            floor(CGRectGetWidth(self.informationView.frame)/2),
            CGRectGetHeight(self.informationView.frame) - topPadding)
        self.nameLabel = UILabel(frame:frame)
        self.nameLabel.text = "\(project.name), \(project.date)"
        self.informationView .addSubview(self.nameLabel)
    }
    
    func constructCameraImageLabelView() -> Void{
        var rightPadding:CGFloat = 10.0
        var image:UIImage = UIImage(named:"camera")!
        //        self.carmeraImageLabelView = buildImageLabelViewLeftOf(CGRectGetWidth(self.informationView.bounds), image:image, text:person.NumberOfPhotos.stringValue)
        self.informationView.addSubview(self.carmeraImageLabelView)
    }
    
    func constructInterestsImageLabelView() -> Void{
        var image: UIImage = UIImage(named: "book")!
        //        self.interestsImageLabelView = self.buildImageLabelViewLeftOf(CGRectGetMinX(self.carmeraImageLabelView.frame), image: image, text:person.NumberOfPhotos.stringValue)
        self.informationView.addSubview(self.interestsImageLabelView)
    }
    
    func constructFriendsImageLabelView() -> Void{
        var image:UIImage = UIImage(named:"group")!
        //        self.friendsImageLabelView = buildImageLabelViewLeftOf(CGRectGetMinX(self.interestsImageLabelView.frame), image:image, text:"No Friends")
        self.informationView.addSubview(self.friendsImageLabelView)
    }
    
    func buildImageLabelViewLeftOf(x:CGFloat, image:UIImage, text:NSString) -> ImagelabelView{
        var frame:CGRect = CGRect(x:x-ChooseProjectViewImageLabelWidth, y: 0,
            width: ChooseProjectViewImageLabelWidth,
            height: CGRectGetHeight(self.informationView.bounds))
        var view:ImagelabelView = ImagelabelView(frame:frame, image:image, text:text)
        view.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        return view
    }
}
