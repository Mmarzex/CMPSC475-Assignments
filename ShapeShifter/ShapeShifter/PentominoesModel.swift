//
//  PentominoesModel.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/14/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

public class PentominoesModel {
    
    private let tileLetters = ["F", "I", "L", "N", "P", "T", "U", "V", "W", "X", "Y", "Z"]
    private let numberOfButtons = 5
    private var boardImages = [UIImage]()
//    private var tileImages = [UIImage]()
    private var tileImages = [String : UIImage]()
    private var solutions : Array<Dictionary<String, Dictionary<String, Int>>>
    
    public init() {
        
        let filePath = NSBundle.mainBundle().pathForResource("Solutions", ofType: "plist")
        if let rawData = NSArray(contentsOfFile: filePath!) as? Array<Dictionary<String, Dictionary<String, Int>>> {
            solutions = rawData
        } else {
            solutions = [Dictionary<String, Dictionary<String, Int>>]()
        }
        
        var test = solutions[0]["F"]!["x"]
        
        for i in 0...numberOfButtons {
            
            let fileName = "Board\(i).png"
            let image = UIImage(named: fileName)
            if let unwrappedImage = image {
                boardImages.append(unwrappedImage)
            }
        }
        
        for i in tileLetters {
            
            let fileName = "tile\(i).png"
            let image = UIImage(named: fileName)
            if let unwrappedImage = image {
//                tileImages.append(unwrappedImage)
                tileImages.updateValue(unwrappedImage, forKey: i)
            }
        }
    }
    
    public func getBoard(numbered index: Int) -> UIImage {
        return boardImages[index]
    }
    
    public func getTileImages() -> [String : UIImage] {
        return tileImages
    }
    
    public func getSolutionForBoard(#number : Int) -> [String : Dictionary<String, Int>] {
        return solutions[number]
    }
}