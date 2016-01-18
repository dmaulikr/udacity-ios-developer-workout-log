//
//  WorkoutLogViewController.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/16/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class WorkoutLogViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = WorkoutItem(name: "item1", context: sharedContext)
        let entry1 = LogEntry(datetime: NSDate(), context: sharedContext)
        entry1.workoutItem = item1

        let item2 = WorkoutItem(name: "item2", context: sharedContext)
        let entry2 = LogEntry(datetime: NSDate(), context: sharedContext)
        entry2.workoutItem = item2
        CoreDataStackManager.sharedInstance().saveContext()

        do {
            try fetchedResultsController.performFetch()
        } catch {}
        fetchedResultsController.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogEntryTableCell")!
        let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! LogEntry

        cell.textLabel?.text = entry.workoutItem.name
        let dateString = NSDateFormatter.localizedStringFromDate(entry.datetime, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        cell.detailTextLabel?.text = dateString

        return cell
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "LogEntry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
}
