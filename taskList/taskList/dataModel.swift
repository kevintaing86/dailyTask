//
//  dataModel.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import Foundation
import CoreData

class taskItem {
    var title: String!
    var description: String!
    var date: NSDate?
    
    init() {
        title = ""
        description = ""
        date = NSDate()
    }
    
    init(userTitle: String, userDescription: String) {
        title = userTitle
        description = userDescription
        date = NSDate()
    }
    
}

//var taskList = [taskItem]()
var taskList = [NSManagedObject]()
//var taskMangeContext = NSManagedObjectContext()