//
//  FavoritesTableViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/20/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    let model = BuildingModel.sharedInstance
    
    var mainViewController : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARKx: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numberOfFavoritesSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.favoritesCountForSection(section)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.letterForFavoritesSection(section)
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return model.favoritesSectionKeys()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath)

        cell.textLabel?.text = model.nameForFavoriteInSection(indexPath.section, row: indexPath.row)

        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            let response = self.model.removeFavorite(indexPath.section, row: indexPath.row)
            if response.0 {
                if self.model.numberOfFavoritesSections() > 0 {
                    if response.1 == -1 {
                        tableView.reloadData()
                    } else {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                } else {
                    self.dismissViewControllerAnimated(true) { () -> Void in
                        if let mainVC = self.mainViewController {
                            mainVC.refreshPins()
                        }
                    }
                }
                
            }
        }
        
        if model.isFavoriteHidden(indexPath.section, row: indexPath.row) {
            let hide = UITableViewRowAction(style: .Normal, title: "Unhide") { action, index in
                self.model.showFavorite(indexPath.section, row: indexPath.row)
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            }
            hide.backgroundColor = UIColor.purpleColor()
            return [delete, hide]
        } else {
            let hide = UITableViewRowAction(style: .Normal, title: "Hide") { action, index in
                self.model.hideFavorite(indexPath.section, row: indexPath.row)
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
            }
            hide.backgroundColor = UIColor.blueColor()
            return [delete, hide]
        }
    }

    @IBAction func dismissFavoritesView(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            if let mainVC = self.mainViewController {
                mainVC.refreshPins()
            }
        }
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
