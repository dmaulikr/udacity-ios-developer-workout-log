//
//  AddEntryViewController.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/17/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class AddEntryViewController: UIViewController {
    @IBOutlet weak var entryNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func addButtonPressed(sender: AnyObject) {
        let workoutItem = WorkoutItem(name: entryNameTextField.text!, context: sharedContext)
        let logEntry = LogEntry(datetime: datePicker.date, context: sharedContext)
        logEntry.workoutItem = workoutItem
        CoreDataStackManager.sharedInstance().saveContext()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchButtonPressed(sender: AnyObject) {
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}