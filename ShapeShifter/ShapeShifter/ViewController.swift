//
//  ViewController.swift
//  ShapeShifter
//
//  Created by Max Marze on 9/13/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var boardImageView: UIImageView!
    
    @IBOutlet var tileHolderView: UIView!
    
    var tileImageViews = [UIImageView]()
    
    let pentominoesModel = PentominoesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        
//        var tempX = 0.0
//        let widthBetweenTiles = 15.0
//        
//        let tileImages = pentominoesModel.getTileImages()
//        
//        let tileImageView = UIImageView(image: tileImages[0])
//        tempX = tempX + widthBetweenTiles
//        let tempRect = CGRect(x: CGFloat(tempX), y: 0.0, width: tileImages[0].size.width, height: tileImages[0].size.height)
//        tileImageView.frame = tempRect
//        
//        tileHolderView.addSubview(tileImageView)
//        tileImageViews.append(tileImageView)
//        
//        
//        for (i, tileImage) in enumerate(tileImages) {
//            if i == 0 { continue }
//            
//            let tileImageView = UIImageView(image: tileImage)
//            tempX = tempX + widthBetweenTiles + Double(tileImageViews[i - 1].frame.origin.x)
//            let tempRect = CGRect(x: CGFloat(tempX), y: 0.0, width: tileImage.size.width, height: tileImage.size.height)
//            
//            
//            
//            tileImageView.frame = tempRect
//            
//            
//            tileHolderView.addSubview(tileImageView)
//            tileImageViews.append(tileImageView)
//            
//            
//        }
//        
//        for i in 1...tileImageViews.count - 1 {
//            let horizontalConstraint = NSLayoutConstraint(item: tileImageViews[i - 1], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: tileImageViews[i], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(widthBetweenTiles))
//            let verticalConstraint = NSLayoutConstraint(item: tileImageViews[i - 1], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
//
//            tileHolderView.addConstraint(horizontalConstraint)
////            tileImageViews[i].addConstraint(verticalConstraint)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeBoardImageButton(sender: AnyObject) {
        boardImageView.image = pentominoesModel.getBoard(numbered: sender.tag!)
    }

}

