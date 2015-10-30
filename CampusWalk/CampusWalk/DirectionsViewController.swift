//
//  DirectionsViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/28/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController, DirectionSearchProtocol {

    var delegate : GetDirectionsProtocol?
    
    var start : BuildingModel.Place?
    var end : BuildingModel.Place?
    
    var lastClickedField : UITextField?
    
    @IBOutlet var startLocation: UITextField!
    @IBOutlet var endLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ////// Set Place in the favorites for the current location here

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didStartEditingTextField(sender: AnyObject) {
        lastClickedField = sender as? UITextField
        
        let directionSearchNavigationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("directionSelection") as! UINavigationController
        let directionSearchViewController = directionSearchNavigationViewController.topViewController as! DirectionSearchTableViewController
        directionSearchViewController.delegate = self
        
        presentViewController(directionSearchNavigationViewController, animated: true, completion: nil)
    }

    @IBAction func routeButtonPressed(sender: UIButton) {
        print("Route Button Pressed")
        if let startPlace = start {
            if let endPlace = end {
                delegate?.buildingSourceAndDestinationSelected(startPlace, destination: endPlace)
            } else {
                print("Invalid Destination")
                let alertController = UIAlertController(title: "Invalid Destination", message: "Please enter a valid destination", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            print("Invalid Start")
            let alertController = UIAlertController(title: "Invalid Start Location", message: "Please enter a valid start location", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func directionSearchViewDismissed(place: BuildingModel.Place) {
        lastClickedField?.text = place.title!
        if lastClickedField?.tag == 0 {
            start = place
        } else {
            end = place
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
