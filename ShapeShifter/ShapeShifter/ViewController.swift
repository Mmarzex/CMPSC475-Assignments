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
    
    let pentominoesModel = PentominoesModel()
    
    let numberOfTileRowsPortrait = 3
    
    let numberOfTileRowsLandscape = 2
    
    let paddingWidthInPortrait = 180.0

    let paddingWidthInLandscape = 170.0
    
    let paddingHeightInPortrait = 30.0
    
    let paddingHeightInLandscape = 15.0
    
    let paddingToEdgeInLandscape = 20.0
    
    let blockSize = 30
    
    var currentBoardNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tileImages = pentominoesModel.getTileImages()
        
        for (tileLetter, tileImage) in tileImages {
            let imageView = UIImageView(image: tileImage)
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            tileImageViews.updateValue(imageView, forKey: tileLetter)
            
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
        
        let numberInRow = deviceIsLandscape ? tileImageViews.count / numberOfTileRowsLandscape : tileImageViews.count / numberOfTileRowsPortrait
        let maxX = deviceIsLandscape ? paddingWidthInLandscape : paddingWidthInPortrait
        let maxY = deviceIsLandscape ? paddingHeightInLandscape : paddingHeightInPortrait
        
        var count = 0
        var rowOn = 0
        var maxHeightInRow : CGFloat = 0
        
        var tempX = 0.0
        var tempY = deviceIsLandscape ? paddingHeightInLandscape : paddingHeightInPortrait
        
        for(tileLetter, imageView) in tileImageViews {
            
            if imageView.isDescendantOfView(tileHolderView) {
                if count % numberInRow == 0 {
                    tempY += Double(maxY)
                    tempY += Double(maxHeightInRow)
                    tempX = deviceIsLandscape ? paddingToEdgeInLandscape : paddingHeightInPortrait
                    maxHeightInRow = 0.0
                }
                
                if imageView.image!.size.height > maxHeightInRow {
                    maxHeightInRow = imageView.image!.size.height
                }
                
                let initialFrame = CGRect(x: CGFloat(tempX), y: CGFloat(tempY), width: imageView.image!.size.width, height: imageView.image!.size.height)
                
                imageView.frame = initialFrame
                
                tempX += maxX
                count++
            }
            
            
        }
    }
    
    func resetPentominoesOnBoard() {
        
        pentominoesModel.resetPentominoesData()
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
            for (tileLetter, imageView) in self.tileImageViews {
                self.tileHolderView.addSubview(imageView)
                imageView.transform = CGAffineTransformIdentity
            }
            
            self.layoutPentominoes()
        }, completion: nil)
        
    }

    @IBAction func changeBoardImageButton(sender: AnyObject) {
        currentBoardNumber = sender.tag!
        resetPentominoesOnBoard()
        boardImageView.image = pentominoesModel.getBoard(numbered: sender.tag!)
    }

    @IBAction func solvePentominoesAction(sender: AnyObject) {
        
        if currentBoardNumber == 0 {
            var alert = UIAlertController(title: title, message: "Board One has no solution!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let solutionForBoard = pentominoesModel.getSolutionForBoard(number: currentBoardNumber - 1)
        resetPentominoesOnBoard()
        
        for(tileLetter, solutionList) in solutionForBoard {
            let x = solutionList["x"]!
            let y = solutionList["y"]!
            let rotations = solutionList["rotations"]!
            let flips = solutionList["flips"]!
            
            let tileImageView = tileImageViews[tileLetter]!
            
            pentominoesModel.setRotationsForPentominoe(tileLetter: tileLetter, numberOfRotations: rotations)
            pentominoesModel.setFlipsForPentominoe(tileLetter: tileLetter, numberOfFlips: flips)
            
            let rotationAnimationBlock = { () -> Void in
                if rotations > 0 {
                    let rotationAngleInRadians = CGFloat(Double(rotations) * (M_PI_2))
                    tileImageView.transform = CGAffineTransformMakeRotation(rotationAngleInRadians)
                }
            }
            
            let flipAnimationBlock = { () -> Void in
                if flips > 0 {
                    tileImageView.transform = CGAffineTransformScale(tileImageView.transform, CGFloat(-1.0), CGFloat(1.0))
                }
            }
            
            let movePieceAnimationBlock = { () -> Void in
                let newX = CGFloat(x * self.blockSize)
                let newY = CGFloat(y * self.blockSize)
                
                self.boardImageView.addSubview(self.tileImageViews[tileLetter]!)
                let width = tileImageView.frame.width
                let height = tileImageView.frame.height
                
                tileImageView.frame = CGRect(x: newX, y: newY, width: width, height: height)
                
            }
            
            let flipCompleteBlock =  { (finished:Bool) -> Void in
                
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: movePieceAnimationBlock, completion: nil)
            }
            
            let rotationCompleteBlock = {(finished:Bool) -> Void in
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: flipAnimationBlock, completion: flipCompleteBlock)
            }
            
            UIView.animateWithDuration(1.0,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: rotationAnimationBlock, completion: rotationCompleteBlock)
        }
    }
    
    @IBAction func resetBoardAction(sender: AnyObject) {
        resetPentominoesOnBoard()
    }
}

