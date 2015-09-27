//
//  ViewController.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/13/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import UIKit

extension UIView {
    var letter : String {
        get {
            return String(UnicodeScalar(tag))
        }
        set(newLetter) {
            let s : NSString = newLetter
            tag = Int(s.characterAtIndex(0))
        }
    }
}

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
    
    let blockSizeCGFloat : CGFloat = 30.0
    
    var currentBoardNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tileImages = pentominoesModel.getTileImages()
        
        for (tileLetter, tileImage) in tileImages {
            let imageView = UIImageView(image: tileImage)
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.userInteractionEnabled = true
            
            // subclass UIGestureRecognizer
            var singleTapGesture = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap:"))
            var doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
            var panGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
            doubleTapGesture.numberOfTapsRequired = 2
            singleTapGesture.requireGestureRecognizerToFail(doubleTapGesture)
            
            tileImageViews.updateValue(imageView, forKey: tileLetter)
            
            tileHolderView.addSubview(imageView)
            imageView.addGestureRecognizer(singleTapGesture)
            imageView.addGestureRecognizer(doubleTapGesture)
            imageView.addGestureRecognizer(panGesture)
            imageView.letter = tileLetter
        }
        boardImageView.userInteractionEnabled = true
        
    }
    
    override func viewDidLayoutSubviews() {
        layoutPentominoes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "hintSegue" {
            var hintModalController = segue.destinationViewController as! HintModalViewController
            hintModalController.pentominoeModel = pentominoesModel
            hintModalController.currentBoard = currentBoardNumber
        }
    }
    
    func handleSingleTap(sender: AnyObject) {
        let tempView = sender.view as! UIImageView
        if tempView.isDescendantOfView(boardImageView) {
            
            pentominoesModel.pentominoes[tempView.letter]!.numberOfRotations++
            
            let rotationAnimationBlock = { () -> Void in
                let rotationAngleInRadians = CGFloat(M_PI_2)
                tempView.transform = CGAffineTransformRotate(tempView.transform, rotationAngleInRadians)
            }
            
            UIView.animateWithDuration(1.0,
                animations: rotationAnimationBlock, completion: nil)
        }
    }
    
    func handleDoubleTap(sender: AnyObject) {
        let tempView = sender.view as! UIImageView
        if tempView.isDescendantOfView(boardImageView) {
            
            pentominoesModel.pentominoes[tempView.letter]!.numberOfFlips++
            
            let flipAnimationBlock = { () -> Void in
                if self.pentominoesModel.pentominoes[tempView.letter]!.numberOfRotations % 2 == 0 {
                    tempView.transform = CGAffineTransformScale(tempView.transform, CGFloat(-1.0), CGFloat(1.0))
                } else {
                    tempView.transform = CGAffineTransformScale(tempView.transform, CGFloat(1.0), CGFloat(-1.0))
                }
            }
            
            UIView.animateWithDuration(1.0,
                animations: flipAnimationBlock, completion: nil)

        }
    }

    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        if let tileView = recognizer.view {
            
            let offsetFromView = recognizer.locationInView(self.view)
            
            if recognizer.state == .Began {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    tileView.frame.size = CGSize(width: tileView.frame.size.width * 1.1, height: tileView.frame.size.height * 1.1)
                })
            } else if recognizer.state == .Changed {
                if CGRectContainsPoint(boardImageView.frame, offsetFromView) {
                    boardImageView.addSubview(tileView)
                    
                    let snapX = CGFloat(Int(tileView.frame.origin.x))
                    let snapY = CGFloat(Int(tileView.frame.origin.y))
                    let newOrigin = CGPoint(x: snapX, y: snapY)
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        tileView.frame = CGRect(origin: newOrigin, size: tileView.frame.size)
                    })
                } else if CGRectContainsPoint(tileHolderView.frame, offsetFromView) {
                    tileHolderView.addSubview(tileView)
                }
                
                let newPoint = recognizer.locationInView(tileView.superview)
                tileView.center = newPoint
            } else if recognizer.state == .Ended {
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    tileView.frame.size = CGSize(width: tileView.frame.size.width / 1.1, height: tileView.frame.size.height / 1.1)
                })
                if CGRectContainsPoint(boardImageView.frame, offsetFromView) {
                    
                    let currentPosition = tileView.frame.origin
                    
                    let originXInBlockSize = CGFloat(Int(currentPosition.x / blockSizeCGFloat))
                    let originYInBlockSize = CGFloat(Int(currentPosition.y / blockSizeCGFloat))
                    
                    let snapX = currentPosition.x - (originXInBlockSize * blockSizeCGFloat) <= (blockSizeCGFloat / 2) ? originXInBlockSize * blockSizeCGFloat : (originXInBlockSize + 1) * blockSizeCGFloat
                    
                    let snapY = currentPosition.y - (originYInBlockSize * blockSizeCGFloat) <= (blockSizeCGFloat / 2) ? originYInBlockSize * blockSizeCGFloat : (originYInBlockSize + 1) * blockSizeCGFloat
                    
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        tileView.frame = CGRect(x: snapX, y: snapY, width: tileView.frame.size.width, height: tileView.frame.size.height)
                    })
                    
                    pentominoesModel.pentominoes[tileView.letter]!.isInTileHolder = false
                }
            }
        }
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
        pentominoesModel.resetHintFlags()
        
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
        pentominoesModel.resetHintFlags()
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
            let x = solutionList["x"]! * blockSize
            let y = solutionList["y"]! * blockSize
            let rotations = solutionList["rotations"]!
            let flips = solutionList["flips"]!
            
            let tileImageView = tileImageViews[tileLetter]!

            pentominoesModel.setRotationsForPentominoe(tileLetter: tileLetter, numberOfRotations: rotations)
            pentominoesModel.setFlipsForPentominoe(tileLetter: tileLetter, numberOfFlips: flips)
            
            let solutionOrigin = CGPoint(x: x, y: y)
            
            UIView.animateWithDuration(2.0, animations: {() -> Void in
                
                if rotations > 0 {
                    tileImageView.transform = CGAffineTransformRotate(tileImageView.transform, CGFloat(Double(rotations) * M_PI_2))
                }
                
                if flips > 0 {
                    tileImageView.transform = CGAffineTransformScale(tileImageView.transform, -1.0, 1.0)
                }
                
                let convertedTileOrigin = self.boardImageView.convertPoint(solutionOrigin, toView: self.tileHolderView)
                
                tileImageView.frame = CGRect(origin: convertedTileOrigin, size: tileImageView.frame.size)
                
                }, completion: {finished in
                    self.boardImageView.addSubview(tileImageView)
                    tileImageView.frame = CGRect(origin: solutionOrigin, size: tileImageView.frame.size)
            })
        }
    }
    
    @IBAction func displayHintModalButton(sender: AnyObject) {
        if currentBoardNumber > 0 {
            performSegueWithIdentifier("hintSegue", sender: self)
        }
    }
    
    @IBAction func resetBoardAction(sender: AnyObject) {
        resetPentominoesOnBoard()
    }
}

