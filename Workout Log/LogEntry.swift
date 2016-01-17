//
//  LogEntry.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/16/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import Foundation

class LogEntry {
    struct Keys {
        static let Name = "name"
        static let Date = "date"
    }

    var name: NSString;
    var date: NSDate;

    init (dictionary: [String : AnyObject]) {
        name = dictionary[Keys.Name] as! NSString
        date = dictionary[Keys.Date] as! NSDate
    }
}