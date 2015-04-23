//
//  AppDelegate.swift
//  Henrique Valcanaia
//
//  Created by Henrique Valcanaia on 4/16/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let kParseApplicationID: String = "GhuwLUxiyCKHGtVA4XwuXxXAryjAjGqlXzCdCNmo"
    let kParseClientKey: String = "YmDUNnq9TM1piq9LwlO5Sapq7lTVfsCRLIIsi7bO"
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //        self.configureParse(launchOptions)
        return true
    }
    
    func configureParse(launchOptions: [NSObject: AnyObject]?){
        Parse.enableLocalDatastore()
        //        HenriqueValcanaia.Project.registerSubclass()
        Parse.setApplicationId(kParseApplicationID, clientKey: kParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }
    
}

