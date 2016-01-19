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

class AddEntryViewController: UIViewController, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var entryNameTextField: UITextField!
    @IBOutlet weak var networkIndicatorTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var workoutItem: WorkoutItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        fetchedResultsController.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        networkIndicatorTextField.hidden = true
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
        self.view.endEditing(true)
        // Check if the workout item already exists.
        for existedWorkoutItemAnyObject in fetchedResultsController.sections![0].objects! {
            let existedWorkoutItem = existedWorkoutItemAnyObject as! WorkoutItem
            if (existedWorkoutItem.name == self.entryNameTextField.text!) {
                workoutItem = existedWorkoutItem
                collectionView.reloadData()
                self.addButton.enabled = true
                return
            }
        }
        // Create a new workout item, and download images from flickr.
        networkIndicatorTextField.hidden = false
        networkIndicatorTextField.text = "Finding images from Flickr..."
        flickrPhotoDownloadManager.getImageURLsFromFlickrBySearchPhrase(entryNameTextField.text!) {(imageURLs, success) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.workoutItem = WorkoutItem(name: self.entryNameTextField.text!, context: self.sharedContext)
                    for imageURL in imageURLs {
                        let photo = Photo(imageURL: "\(imageURL)", context: self.sharedContext)
                        photo.workoutItem = self.workoutItem!
                    }
                    CoreDataStackManager.sharedInstance().saveContext()
                    self.collectionView.reloadData()
                    self.addButton.enabled = true
                    self.networkIndicatorTextField.hidden = true
                } else {
                    let alert = UIAlertController(title: "Network Error", message: "Connect and Try Again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if workoutItem != nil {
            return workoutItem!.photos.count
        } else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddEntryPhotoCell", forIndexPath: indexPath) as! AddEntryPhotoCell

        let photo = workoutItem!.photos[indexPath.row]
        if photo.image == nil {
            cell.imageView.image = nil
            cell.textField.hidden = false
            cell.textField.text = "Loading..."
            photo.getImage({() -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if let c = self.collectionView.cellForItemAtIndexPath(indexPath) as? AddEntryPhotoCell {
                        c.textField.hidden = true
                        c.imageView.image = photo.image
                    }
                })
            })
        } else {
            cell.textField.hidden = true
            cell.imageView.image = photo.image
        }

        return cell
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    lazy var fetchedResultsController: NSFetchedResultsController = CoreDataStackManager.getFetchedResultsController("WorkoutItem", sortKey: "name", assending: true)

    var flickrPhotoDownloadManager = FlickrPhotoDownloadManager()
}