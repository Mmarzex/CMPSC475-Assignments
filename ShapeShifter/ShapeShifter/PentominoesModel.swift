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
    private var tileImages = [String : UIImage]()
    private var solutions : Array<Dictionary<String, Dictionary<String, Int>>>
    private var pentominoes = [String : Pentominoe]()
    
    public init() {
        
        let filePath = NSBundle.mainBundle().pathForResource("Solutions", ofType: "plist")
        if let rawData = NSArray(contentsOfFile: filePath!) as? Array<Dictionary<String, Dictionary<String, Int>>> {
            solutions = rawData
        } else {
            solutions = [Dictionary<String, Dictionary<String, Int>>]()
        }
        
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
                tileImages.updateValue(unwrappedImage, forKey: i)
                
                pentominoes.updateValue(Pentominoe(), forKey: i)
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
    
    public func setRotationsForPentominoe(tileLetter letter : String, numberOfRotations rotations : Int) {
        pentominoes[letter]!.numberOfRotations = rotations
    }
    
    public func incrementRotationsForPentominoeWith(tileLetter letter : String) {
        pentominoes[letter]!.numberOfRotations++
    }
    
    public func setFlipsForPentominoe(tileLetter letter : String, numberOfFlips flips : Int) {
        pentominoes[letter]!.numberOfFlips = flips
    }
    
    public func resetPentominoesData() {
        for letter in tileLetters {
            pentominoes[letter]!.numberOfFlips = 0
            pentominoes[letter]!.numberOfRotations = 0
        }
    }
}