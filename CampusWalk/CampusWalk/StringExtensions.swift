//
//  StringExtensions.swift
//  CampusWalk
//
//  Created by Max Marze on 10/22/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation

extension String {
    func firstLetter() -> String? {
        return (self.isEmpty ? nil : self.substringToIndex(self.startIndex.successor()))
    }
}
