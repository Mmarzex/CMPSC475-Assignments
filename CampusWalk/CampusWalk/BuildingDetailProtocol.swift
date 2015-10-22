//
//  BuildingDetailProtocol.swift
//  CampusWalk
//
//  Created by Max Marze on 10/22/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation

protocol BuildingDetailProtocol {
    func dismissBuildingDetailController()
    func deletePlaceFromMap(place : BuildingModel.Place)
}