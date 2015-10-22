//
//  SearchTableViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit
import CoreLocation

class SearchTableViewController: UITableViewController {

    let model = BuildingModel.sharedInstance
    var mainViewController : ViewController?
    override func viewDidLoad() {
        
    }
    
    //MARK: UITableViewController DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.placesCountForSection(section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.letterForSection(section)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return model.sectionKeys()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("placesCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = model.nameForPlaceInSection(indexPath.section, row: indexPath.row)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        model.addPlaceToPlot(indexPath.section, row: indexPath.row)
        
        dismissViewControllerAnimated(true, completion: {() -> Void in
            self.mainViewController!.plotPlaceAtIndex(indexPath)
        })
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
//            print("more button tapped")
//        }
//        more.backgroundColor = UIColor.lightGrayColor()
        if model.isPlaceFavorite(indexPath.section, row: indexPath.row) {
            let favorite = UITableViewRowAction(style: .Normal, title: "Added") { action, index in
                print("Already Added")
            }
            favorite.backgroundColor = UIColor.purpleColor()
            return [favorite]
        } else {
            let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
                print("favorite button tapped")
                self.model.addFavorite(indexPath.section, row: indexPath.row)
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.None)
                
            }
            favorite.backgroundColor = UIColor.blueColor()
            return [favorite]
        }
        
        
//        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
//            print("share button tapped")
//        }
//        share.backgroundColor = UIColor.blueColor()
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        print(editingStyle)
//    }
}
