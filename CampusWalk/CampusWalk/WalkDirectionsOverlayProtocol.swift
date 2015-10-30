//
//  WalkDirectionsOverlayProtocol.swift
//  CampusWalk
//
//  Created by Max Marze on 10/29/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import MapKit

protocol WalkDirectionsOverlayProtocol {
    func directionsFound(response: MKDirectionsResponse?, source: BuildingModel.Place, destination: BuildingModel.Place)
}