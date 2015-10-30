//
//  BuildingModel.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class BuildingModel {
    
    class Place: NSObject, MKAnnotation {
        
        let title: String?
        let subtitle: String?
        let coordinate:CLLocationCoordinate2D
        
        let buildingCode : Int?
        let yearConstructed : Int?
        let photoName : String?
        
        var photoFromUserSelection : UIImage?
        
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
        
        func buildingImage() -> UIImage? {
            
            /// Need to include something here for the no-image image
            
            if let userSelectedImage = photoFromUserSelection {
                return userSelectedImage
            }
            return UIImage(named: photoName!)
        }
        
    }
    
    static let sharedInstance = BuildingModel()
    
    private let places : [Place]
    private let allPlacesDictionary : [String:[Place]]
    private let allKeysConstant : [String]
    
    private var placesDictionary : [String:[Place]]
    private var allKeys : [String]
    
    private var searchPlacesDictionary = [String:[Place]]()
    private var searchKeys = [String]()
    
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
            _places.append(place)
            
            let firstLetter = place.title!.firstLetter()!
            
            if let _ = _placesDictionary[firstLetter] {
                _placesDictionary[firstLetter]!.append(place)
            } else {
                _placesDictionary[firstLetter] = [place]
            }
        }
        
        places = _places
        allKeys = Array(_placesDictionary.keys).sort()
        
        for key in allKeys {
            _placesDictionary[key] = _placesDictionary[key]!.sort() { $0.title < $1.title }
        }
        
        allKeysConstant = allKeys
        allPlacesDictionary = _placesDictionary
        placesDictionary = _placesDictionary

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
        let place = placesDictionary[letterInSection]![row]
        placesOnMap.append(place)
    }
    
    func placesToPlot() -> [Place] {
        return placesOnMap
    }
    
    func isPlacePlotted(place:Place) -> Bool {
        return placesOnMap.contains(place) || favorites.contains(place)
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
    
    func isFavoriteHidden(place:Place) -> Bool {
        return hiddenFavorites.contains(place)
    }
    
    func hideFavorite(section:Int, row:Int) {
        let letterInSection = letterForFavoritesSection(section)
        let x = favoritesDictionary[letterInSection]![row]
        hiddenFavorites.append(x)
    }
    
    func hideFavorite(place:Place) {
        hiddenFavorites.append(place)
    }
    
    func showFavorite(section:Int, row:Int) {
        let letterInSection = letterForFavoritesSection(section)
        hiddenFavorites.remove(favoritesDictionary[letterInSection]![row])
    }
    
    func showFavorite(place:Place) {
        hiddenFavorites.remove(place)
    }
    
    func addFavorite(section:Int, row:Int) {
        let letterInSection = letterForSection(section)
        favorites.append(placesDictionary[letterInSection]![row])
        if let _ = favoritesDictionary[letterInSection] {
            favoritesDictionary[letterInSection]!.append(placesDictionary[letterInSection]![row])
            favoritesDictionary[letterInSection]!.sortInPlace() { $0.title < $1.title }
        } else {
            favoritesDictionary[letterInSection] = [placesDictionary[letterInSection]![row]]
            favoritesKeys.append(letterInSection)
            favoritesKeys.sortInPlace()
        }
    }
    
    func addFavorite(place : Place) {
        let firstLetter = place.title!.firstLetter()!
        favorites.append(place)
        if let _ = favoritesDictionary[firstLetter] {
            favoritesDictionary[firstLetter]!.append(place)
            favoritesDictionary[firstLetter]!.sortInPlace() { $0.title < $1.title }
        } else {
            favoritesDictionary[firstLetter] = [place]
            favoritesKeys.append(firstLetter)
            favoritesKeys.sortInPlace()
        }
    }
    
    func removeFavorite(section:Int, row:Int) -> (Bool, Int) {
        let letterInSection = letterForFavoritesSection(section)
        let favoriteToRemove = favoritesDictionary[letterInSection]![row]
        if !favorites.remove(favoriteToRemove) {
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
    
    func removeFavorite(place: Place) -> (Bool, Int) {
        let letterInSection = place.title!.firstLetter()!
        if !favorites.remove(place) {
            return (false, -1)
        }
        
        deletedFavorites.append(place)
        
        favoritesDictionary[letterInSection]!.remove(place)
        
        hiddenFavorites.remove(place)
        
        if favoritesDictionary[letterInSection]!.isEmpty {
            favoritesDictionary[letterInSection] = nil
            favoritesKeys.remove(letterInSection)
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
    
    func setUserSelectedImageForPlace(place:Place, image:UIImage) {
        place.photoFromUserSelection = image
    }
    
    func searchPlaces(searchStr: String) {
        if searchStr.isEmpty {
            resetSearch()
        } else {
            let searchString = searchStr.lowercaseString
            let results = places.filter({ return $0.title!.lowercaseString.rangeOfString(searchString) != nil})
            searchPlacesDictionary.removeAll()
            for (index, place) in results.enumerate() {
                let firstLetter = place.title!.firstLetter()!
                
                if let _ = searchPlacesDictionary[firstLetter] {
                    searchPlacesDictionary[firstLetter]!.append(results[index])
                } else {
                    searchPlacesDictionary[firstLetter] = [results[index]]
                }
            }
            
            searchKeys = Array(searchPlacesDictionary.keys).sort()
            
            placesDictionary = searchPlacesDictionary
            allKeys = searchKeys
        }
        
        
    }
    
    func resetSearch() {
        placesDictionary = allPlacesDictionary
        allKeys = allKeysConstant
    }
}