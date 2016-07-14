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
    @IBOutlet weak var errorMsg: UILabel!
    let dateFormatter = NSDateFormatter()
    var userDate = NSDate?()
    var activeField: UITextField?
    var activeView: UITextView?
    
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
        if(titleField.text == ""){
            displayErrorMsg()
        }
        else{
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            
            if(dateField.text != ""){
                userDate = dateFormatter.dateFromString(dateField.text!)!
                saveTask(titleField.text!, desc: descriptionField.text, taskDate: userDate)
            }
            else{
                saveTask(titleField.text!, desc: descriptionField.text)
            }
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func dateBeganEditing(sender: AnyObject) {
        let datePicker = UIDatePicker()
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(addTaskVC.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func displayErrorMsg() {
        errorMsg.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
        print("Text field begain editing")
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        activeView = nil
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        activeView = textView
        print("Text view began editing")
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
    
    func datePickerChanged(sender: UIDatePicker) {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.contentSize.height = 600
        scroller.contentSize.width = 0
        errorMsg.hidden = true
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(addTaskVC.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(addTaskVC.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("I am in the will show func")
        
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            print("I am in the text field")
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scroller.contentInset = contentInsets
            self.scroller.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                self.scroller.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
        
        
        
        if let activeView = self.activeView, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            print("Should adjust keyboard")
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scroller.contentInset = contentInsets
            self.scroller.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!CGRectContainsPoint(aRect, activeView.frame.origin)) {
                self.scroller.scrollRectToVisible(activeView.frame, animated: true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.scroller.contentInset = contentInsets
        self.scroller.scrollIndicatorInsets = contentInsets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

}
