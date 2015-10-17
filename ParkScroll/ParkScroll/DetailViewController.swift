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
    
    let captionLabel = UILabel()
    
    var isInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        captionLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: captionLabel.frame.size)
        captionLabel.center = CGPoint(x: detailImage.frame.width / 2.0, y: detailImage.frame.height / 2.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        if !isInitialized {
            let splitView = self.splitViewController!
            let leftView = splitView.viewControllers.first as! UINavigationController
            let parkTableController = leftView.topViewController as! ParkTableViewController
            
            let rightView = splitView.viewControllers.last as! DetailViewController
            parkTableController.delegate = rightView
            
            isInitialized = true
        }
        // SET FIRST PARK HERE, WILL NEED PARK MODEL
    }
    
    func parkSelected(indexPath: NSIndexPath) {
        
        let image = parkModel.imageAtIndexPath(indexPath)
        
        detailImage.image = image
        
        captionLabel.textColor = UIColor.whiteColor()
        captionLabel.font = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? UIFont(name: "Helvetica Bold", size: 36)! : UIFont(name: "Helvetica Bold", size: 20)!
//        captionLabel.font = textFont
        captionLabel.text = parkModel.captionAtIndexPath(indexPath)
        captionLabel.sizeToFit()
        
        captionLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: captionLabel.frame.size)
        captionLabel.center = CGPoint(x: detailImage.frame.width / 2.0, y: detailImage.frame.height / 2.0)
        detailImage.addSubview(captionLabel)
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
