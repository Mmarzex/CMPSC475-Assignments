//
//  WalkthroughModel.swift
//  ParkScroll
//
//  Created by Max Marze on 10/15/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import UIKit

public class WalkthroughModel {
    
    static let sharedInstance = WalkthroughModel()
    
    static let numberOfPages = 3

    struct PageContent {
        let name : String
        let description : String
//        let image : UIImage
    }
    let pages : [PageContent]
    
    private init() {
    
        let one = PageContent(name: "One", description: "ONE ONE ONE")
        let two = PageContent(name: "TWO", description: "TWO TWO TWO")
        let three = PageContent(name: "THREE", description: "THREE THREE THREE")
        
        pages = [one, two, three]
        
    }

    public func nameAtIndex(index: Int) -> String {
        return pages[index].name
    }
    
    public func descriptionAtIndex(index: Int) -> String {
        return pages[index].description
    }
}