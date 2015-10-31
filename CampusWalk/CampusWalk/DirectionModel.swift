//
//  DirectionModel.swift
//  CampusWalk
//
//  Created by Max Marze on 10/31/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import MapKit

class DirectionModel {
    private var directions = [String]()
    
    init(stepByStepDirections : [MKRouteStep]) {
        var step = 1
        for x in stepByStepDirections {
            let newString = "\(step).) " + x.instructions
            directions.append(newString)
            step++
        }
    }
    
    func getDirectionAtIndex(indexPath : NSIndexPath) -> String {
        return directions[indexPath.row]
    }
    
    func getCountOfDirections() -> Int {
        return directions.count
    }
}