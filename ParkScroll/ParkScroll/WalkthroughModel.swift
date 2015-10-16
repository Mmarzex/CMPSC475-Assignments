//
//  WalkthroughModel.swift
//  ParkScroll
//
//  Created by Max Marze on 10/15/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

public class WalkthroughModel {
    
    static let sharedInstance = WalkthroughModel()
    
    static let numberOfPages = 3

    struct PageContent {
        let name : String
        let description : String
        let image : UIImage?
    }
    let pages : [PageContent]
    
    enum DeviceType : String {
        case phone = "Phone"
        case pad = "Pad"
    }
    
    private var currentDeviceType : DeviceType
    
    private init() {
    
        var _pages = [PageContent]()
        
        let filePath = NSBundle.mainBundle().pathForResource("walkthroughInfo", ofType: "plist")
        if let rawData = NSArray(contentsOfFile: filePath!) as? Array<AnyObject> {
            for (index, x) in rawData.enumerate() {
                let name = x["imageName"]! as! String
                let description = x["text"]! as! String
                currentDeviceType = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? .pad : .phone
                let imageName = name + currentDeviceType.rawValue
                let image = UIImage(named: imageName)
                _pages.append(PageContent(name: name, description: description, image: image))
            }
            
        }
        
        pages = _pages
        currentDeviceType = .phone
    }

    public func nameAtIndex(index: Int) -> String {
        return pages[index].name
    }
    
    public func descriptionAtIndex(index: Int) -> String {
        return pages[index].description
    }
    
    public func imageAtIndex(index: Int) -> UIImage {
        return pages[index].image!
    }
    
    public func currentDevice() -> UIUserInterfaceIdiom {
        return UIDevice.currentDevice().userInterfaceIdiom
    }
}