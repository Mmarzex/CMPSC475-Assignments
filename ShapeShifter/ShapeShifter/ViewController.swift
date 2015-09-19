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
    
    let numberOfTileRowsPortrait = 3
    
    let numberOfTileRowsLandscape = 2
    
    let paddingWidthInPortrait = 180.0

    let paddingWidthInLandscape = 170.0
    
    let paddingHeightInPortrait = 30.0
    
    let paddingHeightInLandscape = 15.0
    
    let paddingToEdgeInPortrait = 50.0
    
    let paddingToEdgeInLandscape = 20.0
    
    var currentBoardNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tileImages = pentominoesModel.getTileImages()
        
        for (tileLetter, tileImage) in tileImages {
            let imageView = UIImageView(image: tileImage)
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            tileImageViews.updateValue(imageView, forKey: tileLetter)
            
            var pentominoe = Pentominoe(tileLetter: tileLetter)
            pentominoes.updateValue(pentominoe, forKey: tileLetter)
            tileHolderView.addSubview(imageView)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        layoutPentominoes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutPentominoes() {
        let deviceIsLandscape = UIDevice.currentDevice().orientation.isLandscape
        
        let numberInRow = deviceIsLandscape ? pentominoes.count / numberOfTileRowsLandscape : pentominoes.count / numberOfTileRowsPortrait
        let maxX = deviceIsLandscape ? paddingWidthInLandscape : paddingWidthInPortrait
        let maxY = deviceIsLandscape ? paddingHeightInLandscape : paddingHeightInPortrait
        
        var count = 0
        var rowOn = 0
        var maxHeightInRow : CGFloat = 0
        
        var tempX = 0.0
        var tempY = deviceIsLandscape ? paddingHeightInLandscape : paddingHeightInPortrait
        
        for(tileLetter, imageView) in tileImageViews {
            
            if imageView.isDescendantOfView(tileHolderView) {
                println(tileLetter)
                if count % numberInRow == 0 {
                    tempY += Double(maxY)
                    tempY += Double(maxHeightInRow)
                    tempX = deviceIsLandscape ? paddingToEdgeInLandscape : paddingHeightInPortrait
                    maxHeightInRow = 0.0
                }
                
                if imageView.image!.size.height > maxHeightInRow {
                    maxHeightInRow = tileImageViews[tileLetter]!.image!.size.height
                }
                
                var temp = 150 - Double(imageView.image!.size.height)
                var newY = tempY + temp
                
                let initialFrame = CGRect(x: CGFloat(tempX), y: CGFloat(tempY), width: imageView.image!.size.width, height: imageView.image!.size.height)
                
                imageView.frame = initialFrame
                
                tempX += maxX
                count++
            }
            
            
        }
    }
    
    func resetPentominoesOnBoard() {
        for (tileLetter, imageView) in tileImageViews {
            tileHolderView.addSubview(imageView)
            imageView.transform = CGAffineTransformIdentity
            imageView.frame = CGRectZero
        }
        
        layoutPentominoes()
    }

    @IBAction func changeBoardImageButton(sender: AnyObject) {
        currentBoardNumber = sender.tag!
        resetPentominoesOnBoard()
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
                                    //let width = rotations % 2 == 0 ? self.tileImageViews[tileLetter]!.frame.width : self.tileImageViews[tileLetter]!.frame.height
                                    //let height = rotations % 2 == 0 ? self.tileImageViews[tileLetter]!.frame.height : self.tileImageViews[tileLetter]!.frame.width
                                    
                                    self.tileImageViews[tileLetter]!.frame = CGRect(x: newX, y: newY, width: width, height: height)

                                }, completion: { (finished:Bool) -> Void in
                                    println("Finished moving")
                                    
                                })
                        })
                })
        }
    }
    
    @IBAction func resetBoardAction(sender: AnyObject) {
        resetPentominoesOnBoard()
    }
}

