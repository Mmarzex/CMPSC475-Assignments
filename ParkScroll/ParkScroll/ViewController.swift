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

    var numberOfColumns = 0
    
    var parkModel = ParkModel()
    
    var currentPage = 0
    
    var currentRow = 0
    
    var currentXOffset : CGFloat = 0.0
    
    var lastOffset = CGPoint(x: 0, y: 0)
    
    @IBOutlet var imageScrollView: UIScrollView!
    
    struct ColumnData {
        var root : UIImageView
        var children :[UIImageView]
    }
    
    var columnViews = [ColumnData]()
    
    enum ScrollDirection {
        case None, Horizontal, Vertical, Diagonal
    }
    
    var rightArrow : UIButton? = nil
    var leftArrow : UIButton? = nil
    var upArrow : UIButton? = nil
    var downArrow : UIButton? = nil
    
    var parkNameLabel : UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfColumns = parkModel.photoEntries.count
        
        imageScrollView.delegate = self
        imageScrollView.frame = self.view.frame
        
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
//        parkNameLabel!.text = "ASDFADGHJK"
//        parkNameLabel!.sizeToFit()
        
        view.addSubview(rightArrow!)
        view.addSubview(leftArrow!)
        view.addSubview(upArrow!)
        view.addSubview(downArrow!)
        view.addSubview(parkNameLabel!)
        
        
//        view.addSubview(parkNameLabel!)
//        imageScrollView.delegate = self
//        imageScrollView.minimumZoomScale = 0.1
//        imageScrollView.maximumZoomScale = 4.0
//        imageScrollView.zoomScale = 1.0
        // Do any additional setup after loading the view, typically from a nib.
//        for x in parkModel.photoEntries {
//            for y in x.photoImages {
//                let imageView = UIImageView(image: y)
//                imageView.contentMode = UIViewContentMode.ScaleAspectFit
//                imageScrollView.addSubview(imageView)
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        configureScrollView()
        view.bringSubviewToFront(rightArrow!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                print("Down")
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
            parkNameLabel!.sizeToFit()
            parkNameLabel!.center = CGPoint(x: view.frame.width / 2.0, y: parkNameLabel!.frame.size.height * 2.0)
            
        } else {
            parkNameLabel!.hidden = true
        }
//        parkNameLabel!.center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 4.0)
        
        for (index, imageView) in columnViews[currentPage].children.enumerate() {
            imageView.frame.origin = CGPoint(x: newXPosition, y: imageScrollView.frame.height * CGFloat(index + 1))
            imageView.frame.size = imageScrollView.frame.size
            imageScrollView.addSubview(imageView)
        }
        imageScrollView.directionalLockEnabled = true
        currentXOffset = imageScrollView.contentOffset.x
        
        changePageButtonVisibilities()
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

        let direction = determineScrollDirection(scrollView.contentOffset)
        
        imageScrollView.directionalLockEnabled = true
        
        switch direction {
        case .Diagonal:
            print("Diagonal")
            scrollView.contentOffset.x = currentXOffset
        case .Horizontal:
            print("Horizontal")
        case .Vertical:
            print("Vertical")
        case .None:
            print("None")
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
    }
    
//    func loadPage(page: Int) {
//        if page < 0 || page >= numberOfColumns {
//            // If it's outside the range of what you have to display, then do nothing
//            return
//        }
//        
//        // 1
//        if let pageView = pageViews[page] {
//            // Do nothing. The view is already loaded.
//        } else {
//            // 2
//            var frame = scrollView.bounds
//            frame.origin.x = frame.size.width * CGFloat(page)
//            frame.origin.y = 0.0
//            
//            // 3
//            let newPageView = UIImageView(image: pageImages[page])
//            newPageView.contentMode = .ScaleAspectFit
//            newPageView.frame = frame
//            scrollView.addSubview(newPageView)
//            
//            // 4
//            pageViews[page] = newPageView
//        }
//    }
//
//    func purgePage(page: Int) {
//        if page < 0 || page >= pageImages.count {
//            // If it's outside the range of what you have to display, then do nothing
//            return
//        }
//        
//        // Remove a page from the scroll view and reset the container array
//        if let pageView = pageViews[page] {
//            pageView.removeFromSuperview()
//            pageViews[page] = nil
//        }
//    }
    
//    func loadVisiblePages() {
//        // First, determine which page is currently visible
//        let pageWidth = imageScrollView.frame.size.width
//        let page = Int(floor((imageScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
//        
//        // Update the page control
//        currentPage = page
//        
//        // Work out which pages you want to load
//        let firstPage = page - 1
//        let lastPage = page + 1
//        
//        // Purge anything before the first page
//        for var index = 0; index < firstPage; ++index {
//            purgePage(index)
//        }
//        
//        // Load pages in our range
//        for index in firstPage...lastPage {
//            loadPage(index)
//        }
//        
//        // Purge anything after the last page
//        for var index = lastPage+1; index < numberOfColumns; ++index {
//            purgePage(index)
//        }
//    }
    

    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let origin = imageScrollView.contentOffset
        let pageWidth = imageScrollView.bounds.size.width
        let pageNumber = Int(origin.x/pageWidth)
        currentPage = pageNumber
//        pageControl.currentPage = pageNumber
        
    }

}

