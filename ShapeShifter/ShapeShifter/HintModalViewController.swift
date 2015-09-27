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
    
    var pentominoeModel : PentominoesModel!
    
    override func viewDidLoad() {
        pentominoeModel.currentHint++
        println(pentominoeModel.currentHint)
    }
    
    @IBAction func dismissHintModalAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
