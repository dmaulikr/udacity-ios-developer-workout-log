//
//  WorkoutItem.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/17/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import Foundation
import CoreData

class WorkoutItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var logEntries: [LogEntry]

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(name: String, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("WorkoutItem", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)

        self.name = name
    }
}