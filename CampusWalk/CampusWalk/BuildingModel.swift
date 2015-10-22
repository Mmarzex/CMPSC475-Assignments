//
//  BuildingModel.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import MapKit

class BuildingModel {
    
    class Place: NSObject, MKAnnotation {
        
        let title: String?
        let subtitle: String?
        let coordinate:CLLocationCoordinate2D
        
        let buildingCode : Int?
        let yearConstructed : Int?
        let photoName : String?
        
        var addressString : String?
        
        init(title: String, coordinate: CLLocationCoordinate2D, buildingCode: Int, yearConstructed: Int, photoName: String) {
            self.title = title
            self.coordinate = coordinate
            self.buildingCode = buildingCode
            self.yearConstructed = yearConstructed
            self.photoName = photoName + ".jpg"
            self.subtitle = nil
            
            super.init()
        }
        
        func mapItem() -> MKMapItem {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = title
            
            return mapItem
        }
        
        func findAddress() {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                var addressString = ""
                if let unwrappedPlacemarks = placemarks {
                    print(unwrappedPlacemarks.count)
                    for x in unwrappedPlacemarks {
                        //                        var addressString = ""
                        if x.subThoroughfare != nil {
                            addressString = x.subThoroughfare! + " "
                        }
                        if x.thoroughfare != nil {
                            addressString = addressString + x.thoroughfare! + ", "
                        }
                        if x.postalCode != nil {
                            addressString = addressString + x.postalCode! + " "
                        }
                        if x.locality != nil {
                            addressString = addressString + x.locality! + ", "
                        }
                        if x.administrativeArea != nil {
                            addressString = addressString + x.administrativeArea! + " "
                        }
                        if x.country != nil {
                            addressString = addressString + x.country!
                        }
                        self.addressString = addressString
//                        print(addressString)
                    }
                }
                
//                if self.addressString == "" {
//                    self.addressString = nil
//                    print("No address")
//                }
            }
        }
    }
    
    static let sharedInstance = BuildingModel()
    
    private let places : [Place]
    private let placesDictionary : [String:[Place]]
    private let allKeys : [String]
    
    private var placesOnMap = [Place]()
    
    private var favorites = [Place]()
    private var favoritesDictionary = [String:[Place]]()
    private var favoritesKeys = [String]()
    
    private var deletedFavorites = [Place]()
    private var hiddenFavorites = [Place]()
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("buildings", ofType: "plist")
        let rawFile = NSArray(contentsOfFile: path!) as! [[String:AnyObject]]
        
        var _places = [Place]()
        var _placesDictionary = [String:[Place]]()
        
        for dictionary in rawFile {
            let place = Place(title: dictionary["name"]! as! String, coordinate: CLLocationCoordinate2DMake(dictionary["latitude"]! as! CLLocationDegrees, dictionary["longitude"]! as! CLLocationDegrees), buildingCode: dictionary["opp_bldg_code"]! as! Int, yearConstructed: dictionary["year_constructed"]! as! Int, photoName: dictionary["photo"]! as! String)
//            place.findAddress()
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
    
    func addPlaceToPlot(section:Int, row:Int) {
        let letterInSection = letterForSection(section)
        placesOnMap.append(placesDictionary[letterInSection]![row])
    }
    
    func placesToPlot() -> [Place] {
        return placesOnMap
    }
    
    func isPlaceFavorite(section:Int, row:Int) -> Bool {
        let letterInSection = letterForSection(section)
        return favorites.contains(placesDictionary[letterInSection]![row])
    }
    
    func isPlaceFavorite(place:Place) -> Bool {
        return favorites.contains(place)
    }
    
    func isFavoriteHidden(section:Int, row:Int) -> Bool {
        let letterInSection = letterForFavoritesSection(section)
        return hiddenFavorites.contains(favoritesDictionary[letterInSection]![row])
    }
    
    func hideFavorite(section:Int, row:Int) {
        let letterInSection = letterForFavoritesSection(section)
        let x = favoritesDictionary[letterInSection]![row]
        hiddenFavorites.append(x)
    }
    
    func showFavorite(section:Int, row:Int) {
        let letterInSection = letterForFavoritesSection(section)
        hiddenFavorites.remove(favoritesDictionary[letterInSection]![row])
    }
    
    func addFavorite(section:Int, row:Int) {
        let letterInSection = letterForSection(section)
        favorites.append(placesDictionary[letterInSection]![row])
        if let _ = favoritesDictionary[letterInSection] {
            favoritesDictionary[letterInSection]!.append(placesDictionary[letterInSection]![row])
        } else {
            favoritesDictionary[letterInSection] = [placesDictionary[letterInSection]![row]]
            favoritesKeys.append(letterInSection)
            favoritesKeys.sortInPlace()
        }
    }
    
    func removeFavorite(section:Int, row:Int) -> (Bool, Int) {
        let letterInSection = letterForFavoritesSection(section)
        let favoriteToRemove = favoritesDictionary[letterInSection]![row]
        if !favorites.remove(favoriteToRemove) {
            print("NOT DELETED")
            return (false, -1)
        }
        
        deletedFavorites.append(favoritesDictionary[letterInSection]![row])
        
        favoritesDictionary[letterInSection]!.removeAtIndex(row)
        
        hiddenFavorites.remove(favoriteToRemove)
        
        if favoritesDictionary[letterInSection]!.isEmpty {
            favoritesDictionary[letterInSection] = nil
            favoritesKeys.removeAtIndex(section)
            return (true, -1)
        }
        
        return (true, allKeys.indexOf(letterInSection)!)
    }
    
    func favoritesToPlot() -> [Place] {
        return favorites
    }
    
    func favoritesToHide() -> [Place] {
        return hiddenFavorites
    }
    
    func favoritesToDeleteFromMap() -> [Place] {
        return deletedFavorites
    }
    
    func clearFavoritesToDelete() {
        deletedFavorites.removeAll()
    }
    
    func favoritesCountForSection(section:Int) -> Int {
        let letterInSection = letterForFavoritesSection(section)
        return favoritesDictionary[letterInSection]!.count
    }
    
    func letterForFavoritesSection(section:Int) -> String {
        return favoritesKeys[section]
    }
    
    func numberOfFavoritesSections() -> Int {
        return favoritesKeys.count
    }
    
    func favoritesSectionKeys() -> [String] {
        return favoritesKeys
    }
    
    func nameForFavoriteInSection(section:Int, row:Int) -> String {
        let letterInSection = letterForFavoritesSection(section)
        return favoritesDictionary[letterInSection]![row].title!
    }
    
    func descriptionForFavoriteInSection(section:Int, row:Int) -> String {
        let letterInSection = letterForFavoritesSection(section)
        return favoritesDictionary[letterInSection]![row].subtitle!
    }
    
    func coordinateForFavoriteInSection(section:Int, row:Int) -> CLLocationCoordinate2D {
        let letterInSection = letterForFavoritesSection(section)
        return favoritesDictionary[letterInSection]![row].coordinate
    }
    
    func photoNameForFavoriteInSection(section:Int, row:Int) -> String {
        let letterInSection = letterForFavoritesSection(section)
        return favoritesDictionary[letterInSection]![row].photoName!
    }
    
    func favoriteInSection(section:Int, row:Int) -> Place {
        let letterInSection = letterForFavoritesSection(section)
        return favoritesDictionary[letterInSection]![row]
    }
}