//
//  ParkCollectionViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 10/10/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ParkCollectionCell"

class ParkCollectionViewController: UICollectionViewController {
    
    let parkModel = ParkModel.sharedInstance
    
    let maxScale : CGFloat = 10.0
    
    let minScale : CGFloat = 1.0
    
    var zoomScrollView : UIScrollView?
    
    var zoomImageView : UIImageView?
    
    var isZooming = false

    override func viewDidLoad() {
        super.viewDidLoad()

        zoomScrollView = UIScrollView()
        
        zoomScrollView!.delegate = self
        zoomScrollView!.frame = view.frame
        zoomScrollView!.minimumZoomScale = minScale
        zoomScrollView!.maximumZoomScale = maxScale
        
        let zoomScrollTapGesture = UITapGestureRecognizer(target: self, action: "zoomImageTapped:")
        zoomScrollView!.addGestureRecognizer(zoomScrollTapGesture)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.numberOfSections()
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return parkModel.numberOfPhotosInSection(section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ParkCollectionViewCell
    
        // Configure the cell
        cell.parkImage!.image = parkModel.imageAtIndexPath(indexPath)
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeader", forIndexPath: indexPath) as! ParkCollectionReusableView
            
            headerView.sectionLabel.text = parkModel.titleForSection(indexPath.section)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !isZooming {
            print("Selected Cell")
            
            let image = parkModel.imageAtIndexPath(indexPath)
            
            let imageToZoom = UIImageView(image: image)
            imageToZoom.contentMode = .ScaleAspectFit
            imageToZoom.frame = zoomScrollView!.frame
            
            zoomScrollView!.contentSize = imageToZoom.frame.size
            zoomScrollView!.addSubview(imageToZoom)
            
            let newImageFrame = CGRect(x: 0.0, y: 0.0, width: imageToZoom.frame.size.width, height: imageToZoom.frame.size.height)
            
            imageToZoom.frame = newImageFrame
            
            view.addSubview(zoomScrollView!)
            zoomScrollView!.frame.origin = CGPoint(x: 0.0, y: 0.0)
            
            view.bringSubviewToFront(zoomScrollView!)
            zoomImageView = imageToZoom
            
            isZooming = true
            
        }
        
        
    }
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
    
    func zoomImageTapped(recognizer: UITapGestureRecognizer) {
        
        let scrollView = recognizer.view as! UIScrollView
        if scrollView.zoomScale == 1.0 {
            print("TAAAAP")
            
            zoomImageView!.removeFromSuperview()
            zoomScrollView!.removeFromSuperview()
            
            zoomImageView = nil
            
            isZooming = false
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
