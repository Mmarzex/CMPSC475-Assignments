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
    let captionLabel = UILabel()
    
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
        
        
        captionLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        captionLabel.text = parkModel.captionAtIndexPath(indexPath)
        captionLabel.sizeToFit()
        captionLabel.textColor = UIColor.whiteColor()
        captionLabel.center = CGPoint(x: (view.frame.width / 2.0), y: view.frame.height - (captionLabel.frame.height * 1.5))
        view.addSubview(captionLabel)
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
