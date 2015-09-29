//
//  ViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 9/28/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    var parkModel = ParkModel()
    
    @IBOutlet var imageScrollView: UIScrollView!
    
    
    //// TEMP
    var tempImageView : UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempImageView = UIImageView(image: parkModel.photoEntries[0].photoImages[0])
        tempImageView!.contentMode = UIViewContentMode.ScaleAspectFit
        tempImageView!.frame.size = imageScrollView.frame.size
        imageScrollView.contentSize = tempImageView!.frame.size
        imageScrollView.addSubview(tempImageView!)

//        imageScrollView.delegate = self
//        imageScrollView.minimumZoomScale = 0.1
//        imageScrollView.maximumZoomScale = 4.0
//        imageScrollView.zoomScale = 1.0
        // Do any additional setup after loading the view, typically from a nib.
//        for x in parkModel.photoEntries {
//            for y in x.photoImages {
//                let imageView = UIImageView(image: y)
//                imageView.contentMode = UIViewContentMode.ScaleAspectFit
//                imageScrollView.addSubview(imageView)
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return tempImageView!
    }

}

