//
//  addTaskVC.swift
//  taskList
//
//  Created by Kevin Taing on 5/13/16.
//  Copyright © 2016 Kevin Taing. All rights reserved.
//

import UIKit

class addTaskVC: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    // MARK: - Actions and Funcitons
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func createButton(sender: AnyObject) {
        let newTask: taskItem = taskItem(userTitle: titleField.text!, userDescription: descriptionField.text)
        taskList.append(newTask)
        navigationController?.popViewControllerAnimated(true)
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
