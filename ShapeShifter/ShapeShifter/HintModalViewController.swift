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
    var tileImageViews = [String : UIImageView]()
    let blockSize = 30

    @IBOutlet var boardImageView: UIImageView!
    
    override func viewDidLoad() {
        
        let tileLetters = pentominoeModel.tileLetters
        
        boardImageView.image = pentominoeModel.getBoard(numbered: currentBoard)
        
        let solution = pentominoeModel.getSolutionForBoard(number: currentBoard - 1)
        
        for(letter, solutionList) in solution {
            let x = solutionList["x"]! * blockSize
            let y = solutionList["y"]! * blockSize
            let rotations = solutionList["rotations"]!
            let flips = solutionList["flips"]!
            
            
            let solutionOrigin = CGPoint(x: x, y: y)
            
            let image = pentominoeModel.getTileImages()[letter]
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            boardImageView.addSubview(imageView)
            
            UIView.animateWithDuration(2.0, animations: {() -> Void in
                
                if rotations > 0 {
                    imageView.transform = CGAffineTransformRotate(imageView.transform, CGFloat(Double(rotations) * M_PI_2))
                }
                
                if flips > 0 {
                    imageView.transform = CGAffineTransformScale(imageView.transform, -1.0, 1.0)
                }
                
                }, completion: {finished in
                    self.boardImageView.addSubview(imageView)
                    imageView.frame = CGRect(origin: solutionOrigin, size: imageView.frame.size)
            })
            tileImageViews.updateValue(imageView, forKey: letter)
            imageView.hidden = true
        }
        for i in 0...pentominoeModel.currentHint {
            var hintPlaced = false
            for j in 0...tileLetters.count - 1 {
                let letter = tileLetters[j]
                if ((pentominoeModel.pentominoes[letter]!.isInTileHolder) || pentominoeModel.pentominoes[letter]!.isAHint) && !hintPlaced && !pentominoeModel.pentominoes[letter]!.hintPlaced {
                    pentominoeModel.pentominoes[letter]!.isAHint = true
                    hintPlaced = true
                    pentominoeModel.pentominoes[letter]!.hintPlaced = true
                    tileImageViews[letter]!.hidden = false
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
