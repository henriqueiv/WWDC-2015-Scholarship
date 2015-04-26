//
//  ProjectViewController.swift
//  HenriqueValcanaia
//
//  Created by Henrique Valcanaia on 4/26/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

import UIKit
import Parse

class ProjectViewController: UIViewController {
    @IBOutlet weak var lblProject: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tvDesc: UITextView!
    var project: Project?
    
    convenience init(project: Project){
        self.init()
        self.project = project
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setProjectInformation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAppearence()
    }
    
    func setAppearence(){
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    func setProjectInformation(){
        let projectImageFile = self.project!.image as PFFile
        projectImageFile.getDataInBackgroundWithBlock({ (retrievedData: NSData?, error: NSError?) -> Void in
            if let imageData = retrievedData where error == nil {
                let image = UIImage(data:imageData)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imgView.image = image
                })
            }
        })
        
        self.lblProject.text = self.project?.name
        self.tvDesc.text = self.project?.fullDescription
    }
}
