//
//  DirectionSearchTableViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/29/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class DirectionSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var delegate : DirectionSearchProtocol?
    
    let model = BuildingModel.sharedInstance
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        model.prepareForSearch()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = model.nameForPlaceInSection(indexPath.section, row: indexPath.row)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = model.placeInSection(indexPath.section, row: indexPath.row)
        searchController.view.removeFromSuperview()
        delegate?.directionSearchViewDismissed(place)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        model.searchPlaces(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    func dismissBuildingDetailController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

