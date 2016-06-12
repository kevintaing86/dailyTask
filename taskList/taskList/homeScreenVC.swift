//
//  homeScreenVC.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import UIKit
import CoreData

class homeScreenVC: UITableViewController {

    // MARK: - Outlets
    let dateFormatter = NSDateFormatter()
    
    // MARK: - Actions
    @IBAction func addButton(sender: AnyObject) {
        let temp = storyboard?.instantiateViewControllerWithIdentifier("newTaskVC") as! addTaskVC
        navigationController?.pushViewController(temp, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "TaskItem")
        
        do {
            let results = try managedContext?.executeFetchRequest(fetchRequest)
            taskList = results as! [NSManagedObject]
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        dateFormatter.dateStyle = .MediumStyle
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customCell
        
        let task = taskList[indexPath.row]
        
        cell.taskTitle.text = task.valueForKey("taskTitle") as? String
        cell.taskDesc.text = task.valueForKey("taskDescription") as? String
        cell.taskedate.text = dateFormatter.stringFromDate(task.valueForKey("taskDate") as! NSDate)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let myView = storyboard?.instantiateViewControllerWithIdentifier("viewTask") as! viewTaskVC
        myView.taskListIndex = indexPath.row
        navigationController?.pushViewController(myView, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let task = taskList[indexPath.row]
            taskList.removeAtIndex(indexPath.row)
            managedContext.deleteObject(task)
            
            do{
             try managedContext.save()
            } catch let error as NSError {
                print("Error in saving after delete \(error)")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        
    }

}





