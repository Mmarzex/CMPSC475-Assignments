//
//  SettingsViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 11/3/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let model = Models.sharedInstance.settingsModel
    var dismissCompletitionBlock : () -> Void = {}
    
    @IBOutlet var mapViewSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewSegment.selectedSegmentIndex = model.getDefaultMapType().rawValue
        mapViewSegment.selected = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultMapViewSelected(sender: UISegmentedControl) {
        let mapType = MapType(rawValue: sender.selectedSegmentIndex)
        model.setDefaultMapType(mapType!)
    }

    @IBAction func doneButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: dismissCompletitionBlock)
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
