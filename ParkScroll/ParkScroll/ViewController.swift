//
//  ViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 9/28/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

enum ButtonDirection : Int {
    case up  = 1
    case down = 2
    case right = 3
    case left = 4
}


extension UIButton {
    var direction : ButtonDirection {
        get {
            return ButtonDirection.init(rawValue: tag)!
        }
        set(newDirection) {
            tag = newDirection.rawValue
        }
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {

    enum ScrollDirection {
        case None, Horizontal, Vertical, Diagonal
    }
    
    struct ColumnData {
        var root : UIImageView
        var children :[UIImageView]
    }
    
    
    let parkModel = ParkModel()
    
    var columnViews = [ColumnData]()
    
    let maxScale : CGFloat = 10.0
    
    let minScale : CGFloat = 1.0
    
    var numberOfColumns = 0

    var currentPage = 0
    
    var currentRow = 0
    
    var currentXOffset : CGFloat = 0.0
    
    var lastOffset = CGPoint(x: 0, y: 0)
    
    @IBOutlet var imageScrollView: UIScrollView!
    
    var rightArrow : UIButton? = nil
    var leftArrow : UIButton? = nil
    var upArrow : UIButton? = nil
    var downArrow : UIButton? = nil
    
    var parkNameLabel : UILabel? = nil
    
    var zoomScrollView : UIScrollView? = nil
    var zoomImageView : UIImageView? = nil
    
    var isZooming = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfColumns = parkModel.photoEntries.count
        
        imageScrollView.delegate = self
        imageScrollView.frame = self.view.frame
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        view.addGestureRecognizer(pinchGesture)
        
        zoomScrollView = UIScrollView()
        
        zoomScrollView!.delegate = self
        zoomScrollView!.frame = view.frame
        zoomScrollView!.minimumZoomScale = minScale
        zoomScrollView!.maximumZoomScale = maxScale
        zoomScrollView!.pinchGestureRecognizer!.enabled = false
        
        for x in parkModel.photoEntries {
            var newColumnData = ColumnData(root: UIImageView(image: x.photoImages[0]), children: [UIImageView]())
            newColumnData.root.contentMode = .ScaleAspectFit
            
            for i in 1...x.photoImages.count - 1 {
                let newImageView = UIImageView(image: x.photoImages[i])
                newImageView.contentMode = .ScaleAspectFit
                newColumnData.children.append(newImageView)
            }
            columnViews.append(newColumnData)
        }

        rightArrow = UIButton()
        leftArrow = UIButton()
        upArrow = UIButton()
        downArrow = UIButton()
        
        parkNameLabel = UILabel()
        
        let rightImage = UIImage(named: "arrowRight.png")
        let leftImage = UIImage(named: "arrowLeft.png")
        let upImage = UIImage(named: "arrowUp.png")
        let downImage = UIImage(named: "arrowDown.png")
        
        rightArrow!.setImage(rightImage!, forState: UIControlState.Normal)
        rightArrow!.frame.size = rightImage!.size
        rightArrow!.transform = CGAffineTransformScale(rightArrow!.transform, 0.5, 0.5)
        rightArrow!.center = CGPoint(x: view.frame.width - (rightImage!.size.width / 2.0), y: view.frame.height / 2.0)
        rightArrow!.direction = .right
        rightArrow!.addTarget(self, action: "pressedPageArrow:", forControlEvents: .TouchUpInside)
        
        leftArrow!.setImage(leftImage!, forState: .Normal)
        leftArrow!.frame.size = leftImage!.size
        leftArrow!.transform = CGAffineTransformScale(leftArrow!.transform, 0.5, 0.5)
        leftArrow!.center = CGPoint(x: leftImage!.size.width / 2.0, y: view.frame.height / 2.0)
        leftArrow!.direction = .left
        leftArrow!.addTarget(self, action: "pressedPageArrow:", forControlEvents: .TouchUpInside)
        
        upArrow!.setImage(upImage!, forState: .Normal)
        upArrow!.frame.size = upImage!.size
        upArrow!.transform = CGAffineTransformScale(upArrow!.transform, 0.5, 0.5)
        upArrow!.center = CGPoint(x: view.frame.width / 2.0, y: upImage!.size.height)
        upArrow!.direction = .up
        upArrow!.addTarget(self, action: "pressedPageArrow:", forControlEvents: .TouchUpInside)
        
        downArrow!.setImage(downImage!, forState: .Normal)
        downArrow!.frame.size = downImage!.size
        downArrow!.transform = CGAffineTransformScale(downArrow!.transform, 0.5, 0.5)
        downArrow!.center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height - downImage!.size.height)
        downArrow!.direction = .down
        downArrow!.addTarget(self, action: "pressedPageArrow:", forControlEvents: .TouchUpInside)
        
        parkNameLabel!.center = CGPointZero
        
        view.addSubview(rightArrow!)
        view.addSubview(leftArrow!)
        view.addSubview(upArrow!)
        view.addSubview(downArrow!)
        view.addSubview(parkNameLabel!)
    }
    
    override func viewDidLayoutSubviews() {
        configureScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePinch(recognizer : UIPinchGestureRecognizer) {

        if recognizer.state == UIGestureRecognizerState.Began {
            
            let imageToZoom = currentRow == 0 ? columnViews[currentPage].root : columnViews[currentPage].children[currentRow - 1]
            zoomScrollView!.contentSize = imageToZoom.frame.size
            zoomScrollView!.addSubview(imageToZoom)
            let newImageFrame = CGRect(x: 0.0, y: 0.0, width: imageToZoom.frame.size.width, height: imageToZoom.frame.size.height)
            imageToZoom.frame = newImageFrame
            view.addSubview(zoomScrollView!)
            zoomScrollView!.addSubview(imageToZoom)
            view.bringSubviewToFront(zoomScrollView!)
            zoomImageView = imageToZoom
            zoomScrollView!.frame.origin = CGPoint(x: 0, y: 0)
            isZooming = true
            zoomScrollView!.setZoomScale(recognizer.scale, animated: true)
            
        } else if recognizer.state == .Changed {
            if recognizer.scale <= maxScale && recognizer.scale >= minScale {
                zoomScrollView!.setZoomScale(recognizer.scale, animated: true)
                zoomScrollView!.contentSize = zoomImageView!.frame.size
            }
        } else if recognizer.state == .Ended && zoomScrollView!.zoomScale <= minScale {
            endScrolling()
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if scrollView.zoomScale <= minScale && scrollView.pinchGestureRecognizer!.state == .Ended {
            endScrolling()
        }
    }
    
    func endScrolling() {
        isZooming = false
        zoomScrollView!.removeFromSuperview()
        view.addSubview(imageScrollView)
        view.bringSubviewToFront(imageScrollView)
        zoomImageView = nil
        configureScrollView()
        view.bringSubviewToFront(upArrow!)
        view.bringSubviewToFront(downArrow!)
        view.bringSubviewToFront(leftArrow!)
        view.bringSubviewToFront(rightArrow!)
    }
    
    func pressedPageArrow(sender: UIButton!) {
        
        switch sender.direction {
        case .up:
            if currentRow > 0 {
                currentRow--
                let newOffset = CGPoint(x: currentXOffset, y: imageScrollView.frame.height * CGFloat(currentRow))
                imageScrollView.setContentOffset(newOffset, animated: false)
            }
        case .down:
            if currentRow < columnViews[currentPage].children.count {
                currentRow++
                let newOffset = CGPoint(x: currentXOffset, y: imageScrollView.frame.height * CGFloat(currentRow))
                imageScrollView.setContentOffset(newOffset, animated: false)
            }
        case .left:
            if currentPage > 0 {
                currentPage--
                let newOffset = CGPoint(x: imageScrollView.frame.width * CGFloat(currentPage), y: imageScrollView.contentOffset.y)
                imageScrollView.setContentOffset(newOffset, animated: false)
            }
        case .right:
            if currentPage < numberOfColumns - 1 {
                currentPage++
                let newOffset = CGPoint(x: imageScrollView.frame.width * CGFloat(currentPage), y: imageScrollView.contentOffset.y)
                imageScrollView.setContentOffset(newOffset, animated: false)
            }
        }
        
        configureScrollView()
    }
    
    func changePageButtonVisibilities() {
        
        if currentRow == 0 {
            leftArrow!.hidden = false
            rightArrow!.hidden = false
            upArrow!.hidden = true
            
        }
        
        if currentRow == columnViews[currentPage].children.count {
            downArrow!.hidden = true
        } else {
            downArrow!.hidden = false
        }
        
        if currentPage == 0 {
            leftArrow!.hidden = true
        } else {
            leftArrow!.hidden = false
        }
        
        if currentPage == numberOfColumns - 1 {
            rightArrow!.hidden = true
        } else {
            rightArrow!.hidden = false
        }
        
        if currentRow > 0 {
            leftArrow!.hidden = true
            rightArrow!.hidden = true
            upArrow!.hidden = false
        }
        
    }
    
    func configureScrollView() {
        if !isZooming {
            let tempImageView = columnViews[currentPage].root
            tempImageView.frame.size = imageScrollView.frame.size
            
            let newXPosition = imageScrollView.frame.size.width * CGFloat(currentPage)
            tempImageView.frame.origin = CGPoint(x: newXPosition, y: tempImageView.frame.origin.y)
            
            let newContentSize = CGSize(width: imageScrollView.frame.width * CGFloat(numberOfColumns), height: imageScrollView.frame.height * CGFloat(columnViews[currentPage].children.count + 1))
            imageScrollView.contentSize = newContentSize
            
            imageScrollView.addSubview(tempImageView)
            
            if currentRow == 0 {
                parkNameLabel!.hidden = false
                parkNameLabel!.text = parkModel.photoEntries[currentPage].name
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    parkNameLabel!.font = UIFont(name: parkNameLabel!.font.fontName, size: 36)
                }
                
                parkNameLabel!.sizeToFit()
                parkNameLabel!.center = CGPoint(x: view.frame.width / 2.0, y: parkNameLabel!.frame.size.height * 2.0)
                
            } else {
                parkNameLabel!.hidden = true
            }
            
            for (index, imageView) in columnViews[currentPage].children.enumerate() {
                imageView.frame.origin = CGPoint(x: newXPosition, y: imageScrollView.frame.height * CGFloat(index + 1))
                imageView.frame.size = imageScrollView.frame.size
                imageScrollView.addSubview(imageView)
            }
            imageScrollView.directionalLockEnabled = true
            currentXOffset = imageScrollView.contentOffset.x
            
            changePageButtonVisibilities()

        }
    }
    
    func determineScrollDirection(offset: CGPoint) -> ScrollDirection {
        if offset.x != lastOffset.x && offset.y != lastOffset.y {
            return .Diagonal
        } else if offset.x != lastOffset.x {
            return .Horizontal
        } else if offset.y != lastOffset.y {
            return .Vertical
        }
        
        return .None
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if scrollView == imageScrollView {
            let direction = determineScrollDirection(scrollView.contentOffset)
            
            imageScrollView.directionalLockEnabled = true
            
            if direction == .Diagonal {
                scrollView.contentOffset.x = currentXOffset
            }
            
            if currentRow > 0 {
                scrollView.contentOffset.x = currentXOffset
            }
            
            let pageWidth = scrollView.frame.size.width
            let pageHeight = scrollView.frame.size.height
            let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            
            let row = Int(floor((scrollView.contentOffset.y * 2.0 + pageHeight) / (pageHeight * 2.0)))
            currentPage = page
            currentRow = row
            
            lastOffset = scrollView.contentOffset
            
            configureScrollView()
        } else if scrollView == zoomScrollView! {
            
        }
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView == zoomScrollView! {
            if let image = zoomImageView {
                return image
            }
        }
        
        return nil
    }

}

