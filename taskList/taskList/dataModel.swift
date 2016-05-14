//
//  dataModel.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import Foundation


class taskItem {
    var title: String!
    var description: String!
    
    init() {
        title = ""
        description = ""
    }
    
    init(userTitle: String, userDescription: String) {
        title = userTitle
        description = userDescription
    }
    
}

var taskList = [taskItem]()