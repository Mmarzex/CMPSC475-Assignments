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
    
    override func viewDidLayoutSubviews() {
        
    }

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
        let solutionProperties = ["x", "y", "rotations", "flips"]
        for(tileLetter, solutionList) in solutionForBoard {
            let temporaryPentominoe = self.pentominoes[tileLetter]
            let x = solutionList["x"]!
            let y = solutionList["y"]!
            let rotations = solutionList["rotations"]!
            let flips = solutionList["flips"]!
            println("Transforming, \(tileLetter) with \(rotations) rotations and \(flips) flips")
            
            
            UIView.animateWithDuration(1.0,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    if rotations > 0 {
                        let rotationAngleInRadians = CGFloat(Double(rotations) * (M_PI_2))
                        self.tileImageViews[tileLetter]!.transform = CGAffineTransformMakeRotation(rotationAngleInRadians)
                    }
                }, completion: {(finished:Bool) -> Void in
                    println("Finished Rotation")
                    UIView.animateWithDuration(1.0,
                        delay: 0.0,
                        options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: { () -> Void in
                            if flips > 0 {
                                self.tileImageViews[tileLetter]!.transform = CGAffineTransformScale(self.tileImageViews[tileLetter]!.transform, CGFloat(-1.0), CGFloat(1.0))
                            }
                        }, completion: { (finished:Bool) -> Void in
                            
                            println("Finished flip")
                            UIView.animateWithDuration(1.0,
                                delay: 0.0,
                                options: UIViewAnimationOptions.CurveEaseIn,
                                animations: { () -> Void in
                                    let newX = CGFloat(x * 30)
                                    let newY = CGFloat(y * 30)
                                    
                                    self.boardImageView.addSubview(self.tileImageViews[tileLetter]!)
                                    let width = self.tileImageViews[tileLetter]!.frame.width
                                    let height = self.tileImageViews[tileLetter]!.frame.height
                                    //            let width = rotations % 2 == 0 ? self.tileImageViews[tileLetter]!.frame.width : self.tileImageViews[tileLetter]!.frame.height
                                    //            let height = rotations % 2 == 0 ? self.tileImageViews[tileLetter]!.frame.height : self.tileImageViews[tileLetter]!.frame.width
                                    
                                    self.tileImageViews[tileLetter]!.frame = CGRect(x: newX, y: newY, width: width, height: height)

                                }, completion: { (finished:Bool) -> Void in
                                    println("Finished moving")
                                    
                                })
                        })
                })
            
            
            
            
            
        }
        
//        for(tileLetter, solutionList) in solutionForBoard {
//            let temporaryPentominoe = self.pentominoes[tileLetter]
//            let x = solutionList["x"]!
//            let y = solutionList["y"]!
//            let width = self.tileImageViews[tileLetter]!.frame.width
//            let height = self.tileImageViews[tileLetter]!.frame.height
//            var tempView = self.tileImageViews[tileLetter]!
//            
//            /*tempView.frame.origin = */
//            var point = CGPoint(x: x * 30, y: y * 30)
//            self.boardImageView.addSubview(self.tileImageViews[tileLetter]!)
//            tempView.frame = CGRect(x: point.x, y: point.y, width: width, height: height)
//        }
//        
//        for(tileLetter, solutionList) in solutionForBoard {
//            let temporaryPentominoe = self.pentominoes[tileLetter]
//            let rotations = solutionList["rotations"]!
//            if rotations > 0 {
//                let rotationAngleInRadians = Double(rotations) * (M_PI/2)
//                println(CGFloat(rotationAngleInRadians))
//                self.tileImageViews[tileLetter]!.transform = CGAffineTransformMakeRotation(CGFloat(rotationAngleInRadians))
////                if rotations % 2 != 0 {
////                    let newHeight = self.tileImageViews[tileLetter]!.frame.width
////                    let newWidth = self.tileImageViews[tileLetter]!.frame.height
////                    let x = self.tileImageViews[tileLetter]!.frame.origin.x
////                    let y = self.tileImageViews[tileLetter]!.frame.origin.y
////                    self.tileImageViews[tileLetter]!.frame = CGRect(x: x, y: y, width: newWidth, height: newHeight)
////                }
//            }
//            
//        }
//        
//        for(tileLetter, solutionList) in solutionForBoard {
//            let temporaryPentominoe = self.pentominoes[tileLetter]
//            let flips = solutionList["flips"]!
//            let rotations = solutionList["rotations"]!
//            if flips > 0 {
//                self.tileImageViews[tileLetter]!.transform = rotations % 2 == 0 ? CGAffineTransformMakeScale(-1.0, 1.0) : CGAffineTransformMakeScale(1.0, -1.0)
//            }
//            
//        }
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

