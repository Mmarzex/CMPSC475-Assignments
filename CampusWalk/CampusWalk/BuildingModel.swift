//
//  BuildingModel.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import MapKit

extension String {
    func firstLetter() -> String? {
        return (self.isEmpty ? nil : self.substringToIndex(self.startIndex.successor()))
    }
}

class BuildingModel {
    
    class Place: NSObject, MKAnnotation {
        
        let title: String?
        let subtitle: String?
        let coordinate:CLLocationCoordinate2D
        
        let buildingCode : Int?
        let yearConstructed : Int?
        let photoName : String?
        
        init(title: String, coordinate: CLLocationCoordinate2D, buildingCode: Int, yearConstructed: Int, photoName: String) {
            self.title = title
            self.coordinate = coordinate
            self.buildingCode = buildingCode
            self.yearConstructed = yearConstructed
            self.photoName = photoName
            self.subtitle = nil
            
            super.init()
        }
        
        func mapItem() -> MKMapItem {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = title
            
            return mapItem
        }
    }
    
    static let sharedInstance = BuildingModel()
    
    private let places : [Place]
    private let placesDictionary : [String:[Place]]
    private let allKeys : [String]
    
    private var placesOnMap = [Place]()
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist")
        let rawFile = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
        
        var _places = [Place]()
        var _placesDictionary = [String:[Place]]()
        
        for dictionary in rawFile {
            let place = Place(title: dictionary["name"]! as! String, coordinate: CLLocationCoordinate2DMake(dictionary["latitude"]! as! CLLocationDegrees, dictionary["longitude"]! as! CLLocationDegrees), buildingCode: dictionary["opp_bldg_code"]! as! Int, yearConstructed: dictionary["year_constructed"]! as! Int, photoName: dictionary["photo"]! as! String)
            
            _places.append(place)
            
            let firstLetter = place.title!.firstLetter()!
            
            if let _ = _placesDictionary[firstLetter] {
                _placesDictionary[firstLetter]!.append(place)
            } else {
                _placesDictionary[firstLetter] = [place]
            }
        }
        
        places = _places
        placesDictionary = _placesDictionary
        allKeys = Array(placesDictionary.keys).sort()
    }
    
    func placesCountForSection(section:Int) -> Int {
        let letterInSection = letterForSection(section)
        return placesDictionary[letterInSection]!.count
    }
    
    func letterForSection(section:Int) -> String {
        return allKeys[section]
    }
    
    func numberOfSections() -> Int {
        return allKeys.count
    }
    
    func sectionKeys() -> [String] {
        return allKeys
    }
    
    func nameForPlaceInSection(section:Int, row:Int) -> String {
        let letterInSection = letterForSection(section)
        return placesDictionary[letterInSection]![row].title!
    }
    
    func descriptionForPlaceInSection(section:Int, row:Int) -> String {
        let letterInSection = letterForSection(section)
        return placesDictionary[letterInSection]![row].subtitle!
    }
    
    func coordinateForPlaceInSection(section:Int, row:Int) -> CLLocationCoordinate2D {
        let letterInSection = letterForSection(section)
        return placesDictionary[letterInSection]![row].coordinate
    }
    
    func photoNameForPlaceInSection(section:Int, row:Int) -> String {
        let letterInSection = letterForSection(section)
        return placesDictionary[letterInSection]![row].photoName!
    }
    
    func placeInSection(section:Int, row:Int) -> Place {
        let letterInSection = letterForSection(section)
        return placesDictionary[letterInSection]![row]
    }
    
//    func placesToPlot() -> [Place] {
//        return places
//    }
    
    func addPlaceToPlot(section:Int, row:Int) {
        let letterInSection = letterForSection(section)
        placesOnMap.append(placesDictionary[letterInSection]![row])
    }
    
    func placesToPlot() -> [Place] {
        return placesOnMap
    }
//    func favoritePlacesToPlot() -> [Place] {
//        return favoritePlaces
//    }
//    
//    func addFavorite(place:Place) {
//        favoritePlaces.append(place)
//    }
}