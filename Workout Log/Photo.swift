//
//  Photo.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/17/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class Photo: NSManagedObject {
    @NSManaged var imageURL: String
    @NSManaged var workoutItem: WorkoutItem

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(imageURL: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.imageURL = imageURL
    }

    var image: UIImage? {
        get {
            if let imageData = NSData(contentsOfFile: imageFilename) {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
    }

    var imageFilename: String {
        get {
            let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            return documentPath + "/" + (imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()))!
        }
    }

    func getImage(completionHandler: () -> Void) {
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: NSURL(string: imageURL)!)
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            data?.writeToFile(self.imageFilename, atomically: true)
            completionHandler()
        }
        task.resume()
    }

    override func prepareForDeletion() {
        let fileManager = NSFileManager()
        do {
            try fileManager.removeItemAtPath(imageFilename)
        } catch {}
    }
}