//
//  HintModalViewController.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/25/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

class HintModalViewController : UIViewController {
    
    var pentominoeModel : PentominoesModel!
    var currentBoard : Int!
    
    let blockSize = 30
    
    @IBOutlet var boardImageView: UIImageView!
    
    override func viewDidLoad() {
        
        println(pentominoeModel.currentHint)
        let tileLetters = pentominoeModel.tileLetters
        
        boardImageView.image = pentominoeModel.getBoard(numbered: currentBoard)
        
        let solution = pentominoeModel.getSolutionForBoard(number: currentBoard - 1)
        
        
        
        for i in 0...pentominoeModel.currentHint {
            var hintPlaced = false
            for j in 0...tileLetters.count - 1 {
                println(j)
                let letter = tileLetters[j]
                if ((pentominoeModel.pentominoes[letter]!.isInTileHolder) || pentominoeModel.pentominoes[letter]!.isAHint) && !hintPlaced && !pentominoeModel.pentominoes[letter]!.hintPlaced {
                    pentominoeModel.pentominoes[letter]!.isAHint = true
                    
                    let x = solution[letter]!["x"]! * blockSize
                    let y = solution[letter]!["y"]! * blockSize
                    let rotations = solution[letter]!["rotations"]!
                    let flips = solution[letter]!["flips"]!
                    
                    let image = pentominoeModel.getTileImages()[letter]
                    
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                    imageView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: image!.size.width, height: image!.size.height)
                    imageView.transform = CGAffineTransformIdentity
                    if rotations > 0 {
                        imageView.transform = CGAffineTransformRotate(imageView.transform, CGFloat(Double(rotations) * M_PI_2))
                    }
                    
                    if flips > 0 {
                        imageView.transform = CGAffineTransformScale(imageView.transform, -1.0, 1.0)
                    }
                    
                    boardImageView.addSubview(imageView)
                    hintPlaced = true
                    pentominoeModel.pentominoes[letter]!.hintPlaced = true
                }
            }
        }
        pentominoeModel.currentHint++
    }
    
    @IBAction func dismissHintModalAction(sender: AnyObject) {
        for letter in pentominoeModel.tileLetters {
            pentominoeModel.pentominoes[letter]!.hintPlaced = false
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
