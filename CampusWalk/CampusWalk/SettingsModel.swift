//
//  SettingsModel.swift
//  CampusWalk
//
//  Created by Max Marze on 11/3/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation

class SettingsModel : NSObject, NSSecureCoding {
    
    private var defaultMapType : MapType = .Standard
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawValueForDefaultMapType = aDecoder.decodeObjectForKey("defaultMapType") as! Int
        defaultMapType = MapType(rawValue: rawValueForDefaultMapType)!
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(defaultMapType.rawValue, forKey: "defaultMapType")
    }
    
    func setDefaultMapType(type : MapType) {
        defaultMapType = type
    }
    
    func getDefaultMapType() -> MapType {
        return defaultMapType
    }
}