//
//  DetailViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 10/12/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, ParkSelectionDelegate {

    let parkModel = ParkModel.sharedInstance
    
    @IBOutlet var detailImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parkSelected(indexPath: NSIndexPath) {
        detailImage.image = parkModel.imageAtIndexPath(indexPath)
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
