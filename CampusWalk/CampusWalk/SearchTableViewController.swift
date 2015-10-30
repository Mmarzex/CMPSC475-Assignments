//
//  SearchTableViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchTableViewController: UITableViewController, BuildingDetailProtocol, GetDirectionsProtocol, UISearchResultsUpdating {

    var delegate: WalkDirectionsOverlayProtocol?
    
    let model = BuildingModel.sharedInstance
    var mainViewController : ViewController?
    
    var finalSource:BuildingModel.Place?
    var finalDest:BuildingModel.Place?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        if let mainVC = mainViewController {
            if mainVC.firstLoad {
                let rootWalkthroughVC = self.storyboard?.instantiateViewControllerWithIdentifier("walkthroughRoot") as! RootWalkthroughViewController
                self.presentViewController(rootWalkthroughVC, animated: true, completion: nil)
                mainVC.firstLoad = false
            }
        }
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        searchController.view!.removeFromSuperview()
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
//        model.resetSearch()
        plotOnMap(model.placeInSection(indexPath.section, row: indexPath.row))
//        dismissViewControllerAnimated(true, completion: {() -> Void in
//            self.mainViewController!.plotOnMap(self.model.placeInSection(indexPath.section, row: indexPath.row))
//        })
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        model.searchPlaces(searchController.searchBar.text!)
        tableView.reloadData()
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
            dismissViewControllerAnimated(true, completion: { () -> Void in
                self.model.resetSearch()
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func getDirections() {
        let walkingRouteRequest = MKDirectionsRequest()
        
        walkingRouteRequest.transportType = .Walking
        walkingRouteRequest.source = finalSource?.mapItem()
        walkingRouteRequest.destination = finalDest?.mapItem()
        
        walkingRouteRequest.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: walkingRouteRequest)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            if error != nil {
                
            } else {
                self.delegate?.directionsFound(response, source: self.finalSource!, destination: self.finalDest!)
            }
        }
    }
    
    func cancelChildViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buildingSourceAndDestinationSelected(source: MKAnnotation?, destination: MKAnnotation?) {
        
        finalSource = source as? BuildingModel.Place
        finalDest = destination as? BuildingModel.Place
        getDirections()
        
    }
    
//    @IBAction func directionsAction(sender: AnyObject) {
//        let directionNavVC = self.storyboard?.instantiateViewControllerWithIdentifier("directionNavController") as! UINavigationController
//        
//        let directionsVC = directionNavVC.topViewController as! DirectionsViewController
//        directionsVC.delegate = self
//        
//        presentViewController(directionsVC, animated: true, completion: nil)
//    }
    
    @IBAction func doneAction(sender: AnyObject) {
        self.model.resetSearch()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "directionSegue" {
            print("Direction segue")
            
            let directionsVC = (segue.destinationViewController as! UINavigationController).topViewController as! DirectionsViewController
            directionsVC.delegate = self
        }
    }

}
