//
//  Project.swift
//  Henrique Valcanaia
//
//  Created by Henrique Valcanaia on 4/16/15.
//  Copyright (c) 2015 Henrique Valcanaia. All rights reserved.
//

// NOVOOOO PROJETOOOOO

import Parse
let kParseApplicationID: String = "GhuwLUxiyCKHGtVA4XwuXxXAryjAjGqlXzCdCNmo"
let kParseClientKey: String = "YmDUNnq9TM1piq9LwlO5Sapq7lTVfsCRLIIsi7bO"

class Project: PFObject, PFSubclassing {
    @NSManaged var name: String!
    @NSManaged var fullDescription: String!
    @NSManaged var url: String!
    @NSManaged var date: NSDate!
    @NSManaged var image: PFFile!
    
    static func parseClassName() -> String{
        return "Project"
    }
    
    override class func initialize() {
        Parse.enableLocalDatastore()
        self.registerSubclass()
        Parse.setApplicationId(kParseApplicationID, clientKey: kParseClientKey)
    }
}