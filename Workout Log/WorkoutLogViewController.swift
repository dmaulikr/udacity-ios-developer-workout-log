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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        do {
            try fetchedResultsController.performFetch()
        } catch {}
        fetchedResultsController.delegate = self
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
        cell.detailTextLabel?.text = entry.datetimeString()
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workoutItemViewController = storyboard!.instantiateViewControllerWithIdentifier("WorkoutItemViewController") as! WorkoutItemViewController
        let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! LogEntry

        workoutItemViewController.workoutItem = entry.workoutItem
        navigationController!.pushViewController(workoutItemViewController, animated: true)
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    lazy var fetchedResultsController: NSFetchedResultsController = CoreDataStackManager.getFetchedResultsController("LogEntry", sortKey: "datetime", assending: false)
}
