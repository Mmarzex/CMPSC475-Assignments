//
//  ParkModel.swift
//  ParkScroll
//
//  Created by Max Marze on 9/28/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func firstLetter() -> String? {
        return (self.isEmpty ? nil : self.substringToIndex(self.startIndex.successor()))
    }
}

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
    
    static let sharedInstance = ParkModel()
    
    public var photoEntries = [PhotoEntry]()
    
    let parkNames : [String:Int]
    
    let allKeys : [String]
    
    let indexLetters : [String]
    
    private init() {
        
        var _names = [String:Int]()
        var _indexLetters = [String]()
        
        let filePath = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist")
        if let rawData = NSArray(contentsOfFile: filePath!) as? Array<AnyObject> {
            for (index, x) in rawData.enumerate() {
                let name = x["name"]! as! String
                let photos = x["photos"]! as! [Dictionary<String, String>]
                photoEntries.append(PhotoEntry(name: name, photos: photos))
                _names[name] = index
                if !_indexLetters.contains(name.firstLetter()!) {
                    _indexLetters.append(name.firstLetter()!)
                }
                
            }
            
        }
        
        parkNames = _names
        allKeys = Array(parkNames.keys).sort()
        indexLetters = _indexLetters.sort()
    }
    
    func numberOfSections() -> Int {
        return photoEntries.count
    }
    
    func titleForSection(section:Int) -> String {
        return allKeys[section]
    }
    
    func indexTitles() -> [String] {
        return indexLetters
    }
    
    func numberOfPhotosInSection(section:Int) -> Int {
        let name = allKeys[section]
        let index = parkNames[name]!
        return photoEntries[index].photoImages.count
    }
    
    private func photoEntryAtIndexPath(indexPath:NSIndexPath) -> PhotoEntry {
        let name = allKeys[indexPath.section]
        let index = parkNames[name]!
        return photoEntries[index]
    }
    
    func captionAtIndexPath(indexPath:NSIndexPath) -> String {
        let photoEntry = photoEntryAtIndexPath(indexPath)
        let photo = photoEntry.photos[indexPath.row]
        return photo["caption"]!
    }
    
    func imageNameAtIndexPath(indexPath:NSIndexPath) -> String {
        let photoEntry = photoEntryAtIndexPath(indexPath)
        let photo = photoEntry.photos[indexPath.row]
        return photo["name"]! + ".jpg"
    }
    
    func imageAtIndexPath(indexPath:NSIndexPath) -> UIImage {
        let photoEntry = photoEntryAtIndexPath(indexPath)
        return photoEntry.photoImages[indexPath.row]
    }
    
    
    
}