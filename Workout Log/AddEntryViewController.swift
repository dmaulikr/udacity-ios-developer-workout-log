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
    @IBOutlet weak var addButton: UIBarButtonItem!
    var workoutItem: WorkoutItem?

    override func viewWillAppear(animated: Bool) {
        addButton.enabled = false
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        let logEntry = LogEntry(datetime: datePicker.date, context: sharedContext)
        logEntry.workoutItem = workoutItem!
        CoreDataStackManager.sharedInstance().saveContext()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchButtonPressed(sender: AnyObject) {
        flickrPhotoDownloadManager.getImageURLsFromFlickrBySearchPhrase(entryNameTextField.text!) {(imageURLs) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.workoutItem = WorkoutItem(name: self.entryNameTextField.text!, context: self.sharedContext)
                for imageURL in imageURLs {
                    let photo = Photo(imageURL: "\(imageURL)", context: self.sharedContext)
                    photo.workoutItem = self.workoutItem!
                }
                CoreDataStackManager.sharedInstance().saveContext()
                self.addButton.enabled = true
            })
        }
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    var flickrPhotoDownloadManager = FlickrPhotoDownloadManager()
}