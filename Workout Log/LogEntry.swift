//
//  LogEntry.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/16/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import Foundation
import CoreData

class LogEntry: NSManagedObject {
    @NSManaged var datetime: NSDate
    @NSManaged var workoutItem: WorkoutItem

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(datetime: NSDate, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("LogEntry", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.datetime = datetime
    }

    func datetimeString() -> String {
        return NSDateFormatter.localizedStringFromDate(datetime, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    }
}