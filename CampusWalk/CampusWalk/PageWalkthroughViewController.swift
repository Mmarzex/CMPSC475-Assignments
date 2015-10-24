//
//  PageWalkthroughViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/24/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class PageWalkthroughViewController: UIViewController {

    private var nameText:String?
    private var walkthroughImage:UIImage?
    var walkthroughIndex:Int?
    
    @IBOutlet var walkthroughImageView: UIImageView!
    @IBOutlet var walkthroughLabel: UILabel!
    
    func configure(description : String, index: Int, image : UIImage) {
        nameText = description
        walkthroughIndex = index
        walkthroughImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walkthroughLabel.text = nameText!
        walkthroughImageView.image = walkthroughImage!
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissButtonAction(sender: AnyObject) {
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
