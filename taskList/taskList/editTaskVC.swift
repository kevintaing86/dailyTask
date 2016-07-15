//
//  editTaskVC.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import UIKit

class editTaskVC: UIViewController {

    // MARK: - Outlets and variables
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var newTitleField: UITextField!
    @IBOutlet weak var newDescField: UITextView!
    @IBOutlet weak var errorMsg: UILabel!
    let dateFormatter = NSDateFormatter()
    var taskListIndex: Int!
    var activeField: UITextField?
    var activeView: UITextView?
    
    // MARK: - Actions and Functions
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        dateField.resignFirstResponder()
        newTitleField.resignFirstResponder()
        newDescField.resignFirstResponder()
    }
    
    @IBAction func updateButton(sender: AnyObject) {
        if(newTitleField.text == "" || newTitleField.text?.characters.count > 100){
            displayErrorMsg()
        }
        else{
            let task = taskList[taskListIndex]
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            
            task.setValue(newTitleField.text, forKey: "taskTitle")
            task.setValue(newDescField.text, forKey: "taskDescription")
            if(dateField.text != ""){
                task.setValue(dateFormatter.dateFromString(dateField.text!), forKey: "taskDate")
                setReminder(dateFormatter.dateFromString(dateField.text!)!)
            }
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error in updating/saving data \(error)")
            }
            
            navigationController?.popViewControllerAnimated(true)
        }

    }
    
    @IBAction func dateBeganEditing(sender: AnyObject) {
        let datePicker = UIDatePicker()
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(editTaskVC.datePickerChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func displayErrorMsg() {
        errorMsg.hidden = false
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func setReminder(reminder: NSDate) {
        let notification = UILocalNotification()
        notification.fireDate = reminder
        notification.alertBody = newTitleField.text
        notification.alertAction = "view task"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMsg.hidden = true
        scroller.contentSize.height = 500
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let task = taskList[taskListIndex]
        newTitleField.text = task.valueForKey("taskTitle") as? String
        newDescField.text = task.valueForKey("taskDescription") as? String
        dateField.text = dateFormatter.stringFromDate(task.valueForKey("taskDate") as! NSDate)
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(editTaskVC.keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(editTaskVC.keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func textViewShouldBeginEditing(textView: UITextView)-> Bool {
        activeView = textView
        return true
    }
    
    func textViewDidEndEditing(textVieww: UITextView) {
        activeView = nil
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
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
