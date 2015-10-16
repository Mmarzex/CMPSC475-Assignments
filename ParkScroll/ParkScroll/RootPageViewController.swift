//
//  RootPageViewController.swift
//  ParkScroll
//
//  Created by Max Marze on 10/15/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class RootPageViewController: UIViewController, UIPageViewControllerDataSource {

    let walkthroughModel = WalkthroughModel.sharedInstance
    
    var pageViewController : UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        
        let firstPage = viewControllerAtIndex(0)
        pageViewController!.setViewControllers([firstPage], direction: .Forward, animated: false, completion: nil)
        
        pageViewController!.view.frame = self.view.bounds
        self.addChildViewController(pageViewController!)
        pageViewController!.didMoveToParentViewController(self)
        self.view.addSubview(pageViewController!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("pageContent") as! PageContentViewController
        contentViewController.configure(walkthroughModel.descriptionAtIndex(index), index: index, image: walkthroughModel.imageAtIndex(index))
//        contentViewController.nameLabel.text = walkthroughModel.nameAtIndex(index)
        
        return contentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! PageContentViewController
        var index = contentViewController.walkthroughIndex!
        if index == 0 {
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! PageContentViewController
        var index = contentViewController.walkthroughIndex!
        if index == WalkthroughModel.numberOfPages - 1 {
            return nil
        }
        
        index++
        return viewControllerAtIndex(index)
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
