//
//  viewTaskVC.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import UIKit

class viewTaskVC: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var naviItem: UINavigationItem!
    let dateFormatter = NSDateFormatter()
    var taskListIndex: Int!
    
    // MARK: - Actions and Functions
    @IBAction func editButton(sender: AnyObject) {
        let evc = storyboard?.instantiateViewControllerWithIdentifier("editTask") as! editTaskVC
        evc.taskListIndex = taskListIndex!
        navigationController?.pushViewController(evc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let task = taskList[taskListIndex]
        naviItem.title = task.valueForKey("taskTitle") as? String
        descField.text = task.valueForKey("taskDescription") as? String
        if(task.valueForKey("taskDate") != nil){
            dateLabel.text = dateFormatter.stringFromDate(task.valueForKey("taskDate") as! NSDate)
        }
        else{
            dateLabel.hidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let task = taskList[taskListIndex]
        naviItem.title = task.valueForKey("taskTitle") as? String
        descField.text = task.valueForKey("taskDescription") as? String
        if(task.valueForKey("taskDate") != nil){
            dateLabel.hidden = false
            dateLabel.text = dateFormatter.stringFromDate(task.valueForKey("taskDate") as! NSDate)
        }
        else{
            dateLabel.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
