//
//  TaskItem+CoreDataProperties.swift
//  taskList
//
//  Created by Kevin Taing on 6/11/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TaskItem {

    @NSManaged var taskDescription: String?
    @NSManaged var taskTitle: String?

}
