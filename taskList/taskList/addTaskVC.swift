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
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    let dateFormatter = NSDateFormatter()
    var userDate = NSDate!()
    
    // MARK: - Actions and Funcitons
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createButton(sender: AnyObject) {
        dateFormatter.dateStyle = .MediumStyle
        userDate = dateFormatter.dateFromString(dateField.text!)!
        
        saveTask(titleField.text!, desc: descriptionField.text, taskDate: userDate!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func saveTask(name: String, desc: String, taskDate: NSDate) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let newEntity = NSEntityDescription.entityForName("TaskItem", inManagedObjectContext: managedContext)
        
        let task = NSManagedObject(entity: newEntity!, insertIntoManagedObjectContext: managedContext)
        
        task.setValue(name, forKey: "taskTitle")
        task.setValue(desc, forKey: "taskDescription")
        task.setValue(taskDate, forKey: "taskDate")
        
        do{
            try managedContext.save()
            taskList.append(task)
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func dateBeganEditing(sender: AnyObject) {
        let datePicker = UIDatePicker()
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(addTaskVC.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        dateFormatter.dateStyle = .MediumStyle
        
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
