//
//  ViewController.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/13/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var boardImageView: UIImageView!
    
    @IBOutlet var tileHolderView: UIView!
    
    var tileImageViews = [String : UIImageView]()
    
    var pentominoes = [String : Pentominoe]()
    
    let pentominoesModel = PentominoesModel()
    
    let numberOfTileRows = 3
    
    var currentBoardNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidLayoutSubviews() {
        var tempX = 15.0
        var tempY = 15.0
        let tileImages = pentominoesModel.getTileImages()
        let numberInRow = tileImages.count / numberOfTileRows
        
        var count = 0
        var maxHeightInRow : CGFloat = 0.0
        
        for (tileLetter, tileImage) in tileImages {
            let imageView = UIImageView(image: tileImage)
            
            if count % numberInRow == 0 && count != 0 {
                tempY += Double(15.0)
                tempY += Double(maxHeightInRow)
                tempX = 15.0
                maxHeightInRow = 0.0
            }
            
            let initialFrame = CGRect(x: CGFloat(tempX), y: CGFloat(tempY), width: tileImage.size.width, height: tileImage.size.height)
            
            imageView.frame = initialFrame
            tempX += 15.0
            tempX += Double(tileImage.size.width)
            
            
            tileImageViews.updateValue(imageView, forKey: tileLetter)
            if tileImage.size.height > maxHeightInRow {
                maxHeightInRow = tileImage.size.height
            }
            
            var pentominoe = Pentominoe(tileLetter: tileLetter, initialPosition: initialFrame)
            pentominoes.updateValue(pentominoe, forKey: tileLetter)
            tileHolderView.addSubview(imageView)
            count++
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        
//        var tempX = 15.0
//        var tempY = 15.0
//        let tileImages = pentominoesModel.getTileImages()
//        let numberInRow = tileImages.count / numberOfTileRows
//        
//        for (index, tileImage) in enumerate(tileImages) {
//            let imageView = UIImageView(image: tileImage)
//            
//            if index % numberInRow == 0 && index != 0 {
//                tempY += Double(15.0)
//                tempY += Double(tileImages[0].size.height)
//                tempX = 15.0
//            }
//            
//            imageView.frame = CGRect(x: CGFloat(tempX), y: CGFloat(tempY), width: tileImage.size.width, height: tileImage.size.height)
//            tempX += 15.0
//            tempX += Double(tileImage.size.width)
//            
//            tileImageViews.append(imageView)
//            tileHolderView.addSubview(imageView)
//        }
//        println()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeBoardImageButton(sender: AnyObject) {
        currentBoardNumber = sender.tag!
        boardImageView.image = pentominoesModel.getBoard(numbered: sender.tag!)
    }

    @IBAction func solvePentominoesAction(sender: AnyObject) {
        
        if currentBoardNumber == 0 {
            // implement alert later
            println("No solution for 0")
            return
        }
        
        let solutionForBoard = pentominoesModel.getSolutionForBoard(number: currentBoardNumber - 1)
        for(tileLetter, solutionList) in solutionForBoard {
            let temporaryPentominoe = self.pentominoes[tileLetter]
            let x = solutionList["x"]!
            let y = solutionList["y"]!
            let width = self.tileImageViews[tileLetter]!.frame.width
            let height = self.tileImageViews[tileLetter]!.frame.height
            var tempView = self.tileImageViews[tileLetter]!
            tempView.frame.origin = tempView.convertPoint(tempView.frame.origin, toView: tileHolderView)
            tempView.frame = CGRect(x: CGFloat(x * 30), y: CGFloat(y * 30), width: width, height: height)
            self.boardImageView.addSubview(self.tileImageViews[tileLetter]!)
        }
        for(tileLetter, solutionList) in solutionForBoard {
            let temporaryPentominoe = self.pentominoes[tileLetter]
            let rotations = solutionList["rotations"]!
            let rotationAngleInRadians = Double(-1) * Double(rotations) * (M_PI/2)
            println(rotationAngleInRadians)
            self.tileImageViews[tileLetter]!.transform = CGAffineTransformMakeRotation(CGFloat(rotationAngleInRadians))
        }
        for(tileLetter, solutionList) in solutionForBoard {
            let temporaryPentominoe = self.pentominoes[tileLetter]
            let flips = solutionList["flips"]!
            let rotations = solutionList["rotations"]!
            self.tileImageViews[tileLetter]!.transform = rotations % 2 == 0 ? CGAffineTransformMakeScale(1.0, -1.0) : CGAffineTransformMakeScale(-1.0, 1.0)
        }

//        UIView.animateWithDuration(1.0,
//            delay: 0.0,
//            options: UIViewAnimationOptions.CurveEaseInOut,
//            animations: { () -> Void in
//                for(tileLetter, solutionList) in solutionForBoard {
//                    let temporaryPentominoe = self.pentominoes[tileLetter]
//                    let rotations = solutionList["rotations"]!
//                    let rotationAngleInRadians = Double(-1) * Double(rotations) * (M_PI/2)
//                    println(rotationAngleInRadians)
//                    self.tileImageViews[tileLetter]!.transform = CGAffineTransformMakeRotation(CGFloat(rotationAngleInRadians))
//                }
//            },
//            completion: { (finished:Bool) -> Void in
//                println("FinishedRotations")
//                println(self.tileImageViews.count)
//                
//                UIView.animateWithDuration(1.0,
//                    delay: 0.0,
//                    options: UIViewAnimationOptions.CurveEaseInOut,
//                    animations: {
//                        for(tileLetter, solutionList) in solutionForBoard {
//                            let temporaryPentominoe = self.pentominoes[tileLetter]
//                            let flips = solutionList["flips"]!
//                            let rotations = solutionList["rotations"]!
//                            self.tileImageViews[tileLetter]!.transform = rotations % 2 == 0 ? CGAffineTransformMakeScale(-1.0, 1.0) : CGAffineTransformMakeScale(1.0, -1.0)
//                        }
//                    },
//                    completion: {(finished:Bool) -> Void in
//                        println("FinishedFlips")
//                        
//                        
//                    }
//                )
//                
//            }
//        )
        
//        for (tileLetter, solutionList) in solutionForBoard {
//            
//            let flips = solutionList["flips"]!
//            tileImageViews[tileLetter]!.transform = CGAffineTransformMakeRotation(CGFloat(Double(rotations) * M_PI))
//            
//            
////            let completionBlock = { (finished:Bool) -> Void in
////                UIView.animateWithDuration(1.0,
////                    delay: 1.0,
////                    options: UIViewAnimationOptions.CurveEaseInOut,
////                    animations: (self.viewAnimationWithScale(1.0)),
////                    completion: { (finished) -> Void in
////                        self.transformButton.enabled = true // re-enabled since animation is completed
////                })
////            }
//            
//            
//            
//            
//        }
        
    }
    
    @IBAction func resetBoardAction(sender: AnyObject) {
    }
}

