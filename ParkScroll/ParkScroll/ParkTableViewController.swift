//
//  ParkTableControllerTableViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 10/5/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController {

    let parkModel = ParkModel.sharedInstance
    
    let maxScale : CGFloat = 10.0
    
    let minScale : CGFloat = 1.0
    
    var sectionIsCollapsed = [Bool]()
    
    var zoomScrollView : UIScrollView?
    
    var zoomImageView : UIImageView?
    
    var isZooming = false
    
    var isAnimating = false
    
    var zoomedCellPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        for _ in 0...parkModel.numberOfSections() - 1 {
            sectionIsCollapsed.append(false)
        }
        
        zoomScrollView = UIScrollView()
        
        zoomScrollView!.delegate = self
        zoomScrollView!.frame = view.frame
        zoomScrollView!.minimumZoomScale = minScale
        zoomScrollView!.maximumZoomScale = maxScale
        
        let zoomScrollTapGesture = UITapGestureRecognizer (target: self, action:"zoomImageTapped:")
        zoomScrollView!.addGestureRecognizer(zoomScrollTapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !sectionIsCollapsed[section] {
            return parkModel.numberOfPhotosInSection(section)
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParkCell", forIndexPath: indexPath) as! ParkTableViewCell

        if !sectionIsCollapsed[indexPath.section] {
            cell.parkCellCaption.text = parkModel.captionAtIndexPath(indexPath)
            cell.parkCellCaption.sizeToFit()
            
            cell.parkCellImage!.image = parkModel.imageAtIndexPath(indexPath)
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return parkModel.titleForSection(section)
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return parkModel.indexTitles()
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 60))
        headerView.backgroundColor = UIColor.grayColor()
        headerView.tag = section
        
        let headerString = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width-10, height: 30)) as UILabel
        headerString.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.addSubview(headerString)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            sectionIsCollapsed[recognizer.view!.tag] = !sectionIsCollapsed[recognizer.view!.tag]
            
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            
            self.tableView.reloadSections(sectionToReload, withRowAnimation: .Fade)
        }
        
    }
    
    func zoomImageTapped(recognizer: UITapGestureRecognizer) {
        
        let scrollView = recognizer.view as! UIScrollView
        if scrollView.zoomScale <= 1.0 && !isAnimating {
            
            UIView.animateWithDuration(1.1, animations: {() -> Void in
                self.isAnimating = true
                let cell = self.tableView.cellForRowAtIndexPath(self.zoomedCellPath!) as! ParkTableViewCell
                self.zoomImageView!.frame = self.startingFrameForZoomAnimation(cell.parkCellImage, cellOrigin: cell.frame.origin)
                }, completion: { finished in
                    self.zoomImageView!.removeFromSuperview()
                    self.zoomScrollView!.removeFromSuperview()
                    
                    self.zoomImageView = nil
                    
                    self.isZooming = false
                    
                    self.tableView.scrollEnabled = true
                    self.isAnimating = false
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !isZooming {
            tableView.scrollEnabled = false
            
            zoomScrollView!.frame = view.bounds
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ParkTableViewCell
            zoomedCellPath = indexPath
            
            let image = parkModel.imageAtIndexPath(indexPath)
            let imageToZoom = UIImageView(image: image)
            imageToZoom.contentMode = .ScaleAspectFit
            
            imageToZoom.frame = startingFrameForZoomAnimation(cell.parkCellImage, cellOrigin: cell.frame.origin)
            
            UIView.animateWithDuration(1.1, animations: {() -> Void in
                
                imageToZoom.frame = self.zoomScrollView!.frame
                self.zoomScrollView!.contentSize = imageToZoom.frame.size
                self.zoomScrollView!.addSubview(imageToZoom)
                
                let newImageFrame = CGRect(x: 0.0, y: 0.0, width: imageToZoom.frame.size.width, height: imageToZoom.frame.size.height)
                imageToZoom.frame = newImageFrame
                
                self.view.addSubview(self.zoomScrollView!)
                
                self.zoomScrollView!.frame.origin = CGPoint(x: 0.0, y: tableView.contentOffset.y)
            })
            
            view.bringSubviewToFront(zoomScrollView!)
            zoomImageView = imageToZoom
            
            isZooming = true
        }
    }
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
    
    func startingFrameForZoomAnimation(startingView : UIImageView, cellOrigin: CGPoint) -> CGRect {
        var imageFrameInView = view.convertPoint(startingView.frame.origin, toView: view)
        imageFrameInView.y += cellOrigin.y - tableView.contentOffset.y
        return CGRect(origin: imageFrameInView, size: startingView.frame.size)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
