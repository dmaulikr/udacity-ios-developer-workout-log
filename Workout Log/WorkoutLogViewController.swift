//
//  WorkoutLogViewController.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/16/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import Foundation
import UIKit

class WorkoutLogViewController: UITableViewController {
    var logEntries: [LogEntry] = [LogEntry]()

    override func viewDidLoad() {
        logEntries.append(LogEntry(dictionary: ["name": "entry1", "date": NSDate()]))
        logEntries.append(LogEntry(dictionary: ["name": "entry2", "date": NSDate()]))
        logEntries.append(LogEntry(dictionary: ["name": "entry3", "date": NSDate()]))
        logEntries.append(LogEntry(dictionary: ["name": "entry4", "date": NSDate()]))
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logEntries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogEntryTableCell")!
        let entry = logEntries[indexPath.row]

        cell.textLabel?.text = entry.name as String
        let dateString = NSDateFormatter.localizedStringFromDate(entry.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        cell.detailTextLabel?.text = dateString

        return cell
    }
}
