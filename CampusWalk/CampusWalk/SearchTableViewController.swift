//
//  SearchTableViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

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
}
