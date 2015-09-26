//
//  HintModalViewController.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/25/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

class HintModalViewController : UIViewController {
    
    var test : String!
    
    override func viewDidLoad() {
        println(test)
    }
    
    @IBAction func dismissHintModalAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
