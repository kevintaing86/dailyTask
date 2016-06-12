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
    @IBOutlet weak var newTitleField: UITextField!
    @IBOutlet weak var newDescField: UITextView!
    var taskIndex: Int!
    
    // MARK: - Actions and Functions
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func updateButton(sender: AnyObject) {

        navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = taskList[taskIndex]
        newTitleField.text = task.valueForKey("taskTitle") as? String
        newDescField.text = task.valueForKey("taskDescription") as? String
//        newTitleField.text = taskList[taskIndex].title
//        newDescField.text = taskList[taskIndex].description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
