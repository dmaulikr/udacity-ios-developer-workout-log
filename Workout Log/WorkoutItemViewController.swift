//
//  WorkoutItemViewController.swift
//  Workout Log
//
//  Created by Ying Xiong on 1/17/16.
//  Copyright © 2016 Ying Xiong. All rights reserved.
//

import Foundation
import UIKit

class WorkoutItemViewController: UICollectionViewController {
    var workoutItem: WorkoutItem?

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workoutItem!.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WorkoutItemPhotoCell", forIndexPath: indexPath) as! WorkoutItemPhotoCell

        let photo = workoutItem!.photos[indexPath.row]
        if photo.image == nil {
            cell.imageView.image = nil
            cell.textField.hidden = false
            cell.textField.text = "Loading..."
            photo.getImage({() -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if let c = self.collectionView!.cellForItemAtIndexPath(indexPath) as? AddEntryPhotoCell {
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
}
