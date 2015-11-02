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
    
    private let archiveFile = "buildingModelArchive"
    
    private init() {
        if let unarchivedModel = NSUserDefaults.standardUserDefaults().objectForKey(archiveFile) as? NSData {
            print("Unarchive")
            buildingModel = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedModel) as! BuildingModel
        } else {
            buildingModel = BuildingModel()
        }
    }
    
    func saveModels() {
        print("archive")
        let data = NSKeyedArchiver.archivedDataWithRootObject(buildingModel)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: archiveFile)
    }
}