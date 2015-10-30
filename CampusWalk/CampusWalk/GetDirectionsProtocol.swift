//
//  GetDirectionsProtocol.swift
//  CampusWalk
//
//  Created by Max Marze on 10/29/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import MapKit

protocol GetDirectionsProtocol {
    func buildingSourceAndDestinationSelected(source:MKAnnotation?, destination:MKAnnotation?)
    func cancelChildViewController()
}