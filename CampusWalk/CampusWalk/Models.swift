//
//  Models.swift
//  CampusWalk
//
//  Created by Max Marze on 11/2/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation


class Models {
    
    static let sharedInstance = Models()
    
    let buildingModel : BuildingModel
    let settingsModel : SettingsModel
    
    private let buildingModelArchive = "buildingModelArchive"
    private let settingsModelArchive = "settingsModelArchive"
    
    private init() {
        if let unarchivedModel = NSUserDefaults.standardUserDefaults().objectForKey(buildingModelArchive) as? NSData {
            buildingModel = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedModel) as! BuildingModel
        } else {
            buildingModel = BuildingModel()
        }
        
        if let unarchivedModel = NSUserDefaults.standardUserDefaults().objectForKey(settingsModelArchive) as? NSData {
            settingsModel = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedModel) as! SettingsModel
        } else {
            settingsModel = SettingsModel()
        }
    }
    
    func saveModels() {
        let buildingModeldata = NSKeyedArchiver.archivedDataWithRootObject(buildingModel)
        NSUserDefaults.standardUserDefaults().setObject(buildingModeldata, forKey: buildingModelArchive)
        
        let settingsModelData = NSKeyedArchiver.archivedDataWithRootObject(settingsModel)
        NSUserDefaults.standardUserDefaults().setObject(settingsModelData, forKey: settingsModelArchive)
    }
}