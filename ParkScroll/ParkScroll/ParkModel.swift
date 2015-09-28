//
//  ParkModel.swift
//  ParkScroll
//
//  Created by Max Marze on 9/28/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

public struct PhotoEntry {
    let name : String
    let photos : [Dictionary<String, String>]
    var photoImages = [UIImage]()
    
    public init(name : String, photos: [Dictionary<String, String>]) {
        self.name = name
        self.photos = photos
        for x in self.photos {
            let fileName = x["imageName"]! + ".jpg"
            let image = UIImage(named: fileName)
            if let unwrappedImage = image {
                photoImages.append(unwrappedImage)
            }
        }
    }
    
}

public class ParkModel {
    
    public var photoEntries = [PhotoEntry]()
    public init() {
        let filePath = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist")
        if let rawData = NSArray(contentsOfFile: filePath!) as? Array<AnyObject> {
            for x in rawData {
                let name = x["name"]! as! String
                let photos = x["photos"]! as! [Dictionary<String, String>]
                photoEntries.append(PhotoEntry(name: name, photos: photos))
            }
        }
    }
}