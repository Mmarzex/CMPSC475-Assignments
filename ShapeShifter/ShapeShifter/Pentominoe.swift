//
//  Pentominoe.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/15/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

public class Pentominoe {
    
    private let tileLetter : String
    private var numberOfFlips = 0
    private var numberofRotations = 0

    public init(tileLetter letter: String) {
        tileLetter = letter
    }
    
    public func getTileLetter() -> String {
        return tileLetter
    }
    
    public func getNumberOfFlips() -> Int {
        return numberOfFlips
    }
    
    public func getNumberOfRotations() -> Int {
        return numberofRotations
    }
    
    public func incrementNumberOfRotations() {
        numberofRotations++
    }
    
    public func incrementNumberOfFlips() {
        numberOfFlips++
    }
    
}