//
//  ParkTableControllerTableViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 10/5/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController, ParkTableHeaderCellDelegate {

    let parkModel = ParkModel.sharedInstance
    
    let maxScale : CGFloat = 10.0
    
    let minScale : CGFloat = 1.0
    
    var sectionIsCollapsed = [Bool]()
    
    var zoomScrollView : UIScrollView?
    
    var zoomImageView : UIImageView?
    
    var isZooming = false
    
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
        if scrollView.zoomScale == 1.0 {
            print("TAAAAAP")
            
            zoomImageView!.removeFromSuperview()
            zoomScrollView!.removeFromSuperview()
            
            zoomImageView = nil
            
            isZooming = false
        }
    }
    
    func didSelectParkTableHeaderCell(selected: Bool, parkHeader: ParkTableHeaderCell) {
        let name = parkHeader.headerButton.titleForState(.Normal)!
        print("selected header with name, \(name), section: \(parkHeader.tag)")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: parkHeader.tag)
        
        sectionIsCollapsed[parkHeader.tag] = !sectionIsCollapsed[parkHeader.tag]
        
        let range = NSMakeRange(indexPath.section, 1)
        let sectionToReload = NSIndexSet(indexesInRange: range)
        
        self.tableView.reloadSections(sectionToReload, withRowAnimation: .Fade)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !isZooming {
            print("Section : \(indexPath.section), row: \(indexPath.row) tapped")
            
            zoomScrollView!.frame = view.bounds
            
            let image = parkModel.imageAtIndexPath(indexPath)
            let imageToZoom = UIImageView(image: image)
            imageToZoom.contentMode = .ScaleAspectFit
            imageToZoom.frame = zoomScrollView!.frame
            print("Main View: width: \(view.frame.width), height: \(view.frame.height)")
            print("scroll View: width: \(zoomScrollView!.frame.width), height: \(zoomScrollView!.frame.height)")
            zoomScrollView!.contentSize = imageToZoom.frame.size
            zoomScrollView!.addSubview(imageToZoom)
            print("image View: width: \(imageToZoom.frame.width), height: \(imageToZoom.frame.height)")
            let newImageFrame = CGRect(x: 0.0, y: 0.0, width: imageToZoom.frame.size.width, height: imageToZoom.frame.size.height)
            print("NewImage frame: width: \(newImageFrame.width), height: \(newImageFrame.height)")
            imageToZoom.frame = newImageFrame
            
            view.addSubview(zoomScrollView!)
            zoomScrollView!.frame.origin = CGPoint(x: self.tableView.bounds.origin.x, y: self.tableView.bounds.origin.y)
            view.bringSubviewToFront(zoomScrollView!)
            zoomImageView = imageToZoom
            
            isZooming = true
        }
    }
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
    
    override func scrollViewDidZoom(scrollView: UIScrollView) {
//        if scrollView.zoomScale <= minScale && scrollView.pinchGestureRecognizer!.state == .Ended {
//            endScrolling()
//        }
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
