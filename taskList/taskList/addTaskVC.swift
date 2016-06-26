//
//  addTaskVC.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import UIKit
import CoreData

class addTaskVC: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    let dateFormatter = NSDateFormatter()
    var userDate = NSDate?()
    
    // MARK: - Actions and Funcitons
    @IBAction func hideKeyboard(sender: AnyObject) {
        titleField.resignFirstResponder()
        dateField.resignFirstResponder()
        descriptionField.resignFirstResponder()
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createButton(sender: AnyObject) {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        if(dateField.text == "testettsfsdfsd"){
            userDate = dateFormatter.dateFromString(dateField.text!)!
        }
        saveTask(titleField.text!, desc: descriptionField.text)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func saveTask(name: String, desc: String, taskDate: NSDate?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let newEntity = NSEntityDescription.entityForName("TaskItem", inManagedObjectContext: managedContext)
        
        let task = NSManagedObject(entity: newEntity!, insertIntoManagedObjectContext: managedContext)
        
        task.setValue(name, forKey: "taskTitle")
        task.setValue(desc, forKey: "taskDescription")
        
        if(taskDate != nil) {
            task.setValue(taskDate, forKey: "taskDate")
            do{
                try managedContext.save()
                taskList.append(task)
                setReminder(taskDate!)
            } catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveTask(name: String, desc: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let newEntity = NSEntityDescription.entityForName("TaskItem", inManagedObjectContext: managedContext)
        
        let task = NSManagedObject(entity: newEntity!, insertIntoManagedObjectContext: managedContext)
        
        task.setValue(name, forKey: "taskTitle")
        task.setValue(desc, forKey: "taskDescription")
        
        do{
            try managedContext.save()
            taskList.append(task)
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func setReminder(reminder: NSDate) {
        let notification = UILocalNotification()
        notification.fireDate = reminder
        notification.alertBody = titleField.text
        notification.alertAction = "view task"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    @IBAction func dateBeganEditing(sender: AnyObject) {
        let datePicker = UIDatePicker()
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(addTaskVC.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.contentSize = CGSize(width: 0.0, height: 600.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
