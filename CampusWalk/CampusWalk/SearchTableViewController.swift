//
//  SearchTableViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit
import CoreLocation

class SearchTableViewController: UITableViewController, BuildingDetailProtocol {

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
        
        let more = UITableViewRowAction(style: .Normal, title: "More Info") { action, index in
            let detailNavVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailNavController") as! UINavigationController
            let buildingDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("buildingDetailVC") as! BuildingDetailViewController
            detailNavVC.setViewControllers([buildingDetailVC], animated: true)
            buildingDetailVC.placeToDisplay = self.model.placeInSection(indexPath.section, row: indexPath.row)
            buildingDetailVC.delegate = self
            self.presentViewController(detailNavVC, animated: true, completion: nil)

        }
        more.backgroundColor = UIColor.grayColor()
        if model.isPlaceFavorite(indexPath.section, row: indexPath.row) {
            let favorite = UITableViewRowAction(style: .Normal, title: "Added") { action, index in
            }
            favorite.backgroundColor = UIColor.purpleColor()
            return [favorite, more]
        } else {
            let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
                self.model.addFavorite(indexPath.section, row: indexPath.row)
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.None)
                
            }
            favorite.backgroundColor = UIColor.blueColor()
            return [favorite, more]
        }
        
    }
    
    func dismissBuildingDetailController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deletePlaceFromMap(place: BuildingModel.Place) {
        if let mainVC = mainViewController {
            mainVC.deletePlaceFromMap(place)
        }
    }
    
    func plotOnMap(place: BuildingModel.Place) {
        if let mainVC = mainViewController {
            mainVC.plotOnMap(place)
        }
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
