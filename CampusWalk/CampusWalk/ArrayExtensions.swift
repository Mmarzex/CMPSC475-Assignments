//
//  ArrayExtensions.swift
//  CampusWalk
//
//  Created by Max Marze on 10/22/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation

extension Array {
    mutating func remove<U: Equatable>(object: U) -> Bool {
        for(index, x) in self.enumerate() {
            if let y = x as? U {
                if object == y {
                    self.removeAtIndex(index)
                    return true
                }
            }
        }
        
        return false
    }
}