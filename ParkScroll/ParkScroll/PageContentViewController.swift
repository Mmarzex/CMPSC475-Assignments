//
//  PageContentViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 10/15/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var dismissButton: UIButton!
    
    private var nameText:String?
    var walkthroughIndex:Int?
    
    func configure(name : String, index: Int) {
        nameText = name
        walkthroughIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameText!
        if walkthroughIndex! != WalkthroughModel.numberOfPages - 1 {
            dismissButton.hidden = true
        } else {
            dismissButton.hidden = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissButtonAction(sender: AnyObject) {
        performSegueWithIdentifier("mainSegue", sender: self)
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
