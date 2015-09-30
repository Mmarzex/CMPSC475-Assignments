//
//  ViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 9/28/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    var numberOfColumns = 0
    
    var parkModel = ParkModel()
    
    var currentPage = 0
    
    @IBOutlet var imageScrollView: UIScrollView!
    
    struct ColumnData {
        var root : UIImageView
        var children :[UIImageView]
        var currentRow : Int
    }
    
    var columnViews = [ColumnData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfColumns = parkModel.photoEntries.count
        
        imageScrollView.delegate = self
        imageScrollView.frame = self.view.frame
        
        for x in parkModel.photoEntries {
            var newColumnData = ColumnData(root: UIImageView(image: x.photoImages[0]), children: [UIImageView](), currentRow: 0)
            newColumnData.root.contentMode = .ScaleAspectFit
            
            for i in 1...x.photoImages.count - 1 {
                let newImageView = UIImageView(image: x.photoImages[i])
                newImageView.contentMode = .ScaleAspectFit
                newColumnData.children.append(newImageView)
            }
            columnViews.append(newColumnData)
        }

        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureScrollView() {
        let tempImageView = columnViews[currentPage].root
        tempImageView.frame.size = imageScrollView.frame.size
        
        let newXPosition = imageScrollView.frame.size.width * CGFloat(currentPage)
        
        tempImageView.frame.origin = CGPoint(x: newXPosition, y: tempImageView.frame.origin.y)
        
        let newContentSize = CGSize(width: imageScrollView.frame.width * CGFloat(numberOfColumns), height: imageScrollView.frame.height * CGFloat(columnViews[currentPage].children.count + 1))
        imageScrollView.contentSize = newContentSize
        
        imageScrollView.addSubview(tempImageView)
        
        for (index, imageView) in columnViews[currentPage].children.enumerate() {
            imageView.frame.origin = CGPoint(x: newXPosition, y: imageScrollView.frame.height * CGFloat(index + 1))
            imageView.frame.size = imageScrollView.frame.size
            imageScrollView.addSubview(imageView)
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
//        loadVisiblePages()
        let pageWidth = imageScrollView.frame.size.width
        let page = Int(floor((imageScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        currentPage = page
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

