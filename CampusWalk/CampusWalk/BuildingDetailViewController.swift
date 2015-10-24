//
//  BuildingDetailViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/22/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit
import CoreLocation

class BuildingDetailViewController: UIViewController {

    let model = BuildingModel.sharedInstance
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var detailActionButton: UIButton!
    
    @IBOutlet var favoriteActionButton: UIButton!
    
    @IBOutlet var addToMapActionButton: UIButton!
    
    var delegate : BuildingDetailProtocol?
    var placeToDisplay : BuildingModel.Place?
    
    enum ButtonType : Int {
        case addFavorite
        case hideFavorite
        case removeFavorite
        case showFavorite
        case delete
    }
    
    let hideFavoriteText = "Hide On Map"
    let showFavoriteText = "Show on Map"
    let removeFavoriteText = "Remove From Favorites"
    let deleteText = "Delete"
    let addFavoriteText = "Add Favorite"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let place = placeToDisplay {
            nameLabel.text = place.title
            if let x = place.photoName {
                print(x)
                if x != "" {
                    imageView.image = UIImage(named: x)
                }
            }
            
            if model.isPlaceFavorite(place) {
                if model.isFavoriteHidden(place) {
                    favoriteActionButton.setTitle(showFavoriteText, forState: .Normal)
                    favoriteActionButton.backgroundColor = UIColor.blueColor()
                    favoriteActionButton.tag = ButtonType.showFavorite.rawValue
                } else {
                    favoriteActionButton.setTitle(hideFavoriteText, forState: .Normal)
                    favoriteActionButton.backgroundColor = UIColor.blueColor()
                    favoriteActionButton.tag = ButtonType.hideFavorite.rawValue
                }
                
                detailActionButton.setTitle(removeFavoriteText, forState: .Normal)
                detailActionButton.tag = ButtonType.removeFavorite.rawValue
            } else {
                favoriteActionButton.tag = ButtonType.addFavorite.rawValue
                detailActionButton.tag = ButtonType.delete.rawValue
            }
            
            if model.isPlacePlotted(place) {
                addToMapActionButton.hidden = true
            }
            
            let coordinate = place.coordinate
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                var addressString = ""
                if let unwrappedPlacemarks = placemarks {
                    print(unwrappedPlacemarks.count)
                    for x in unwrappedPlacemarks {
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
                    }
                    print(addressString)
                    self.locationLabel.text = addressString
                    self.locationLabel.sizeToFit()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonAction(sender: AnyObject) {
        if ButtonType(rawValue: sender.tag) == .addFavorite {
            model.addFavorite(placeToDisplay!)
            favoriteActionButton.setTitle(hideFavoriteText, forState: .Normal)
            favoriteActionButton.tag = ButtonType.hideFavorite.rawValue
            
            detailActionButton.setTitle(removeFavoriteText, forState: .Normal)
            detailActionButton.tag = ButtonType.removeFavorite.rawValue
            
            if let del = delegate {
                del.deletePlaceFromMap(placeToDisplay!)
            }
            
        } else if ButtonType(rawValue: sender.tag) == .hideFavorite {
            model.hideFavorite(placeToDisplay!)
            favoriteActionButton.setTitle(showFavoriteText, forState: .Normal)
            favoriteActionButton.tag = ButtonType.showFavorite.rawValue
            
        } else if ButtonType(rawValue: sender.tag) == .showFavorite {
            model.showFavorite(placeToDisplay!)
            favoriteActionButton.setTitle(hideFavoriteText, forState: .Normal)
            favoriteActionButton.tag = ButtonType.hideFavorite.rawValue
            
        }
    }
    
    @IBAction func detailButtonAction(sender: AnyObject) {
        if ButtonType(rawValue: sender.tag) == .delete {
            print("delete")
            if let del = delegate {
                del.deletePlaceFromMap(placeToDisplay!)
                del.dismissBuildingDetailController()
            }
        } else if ButtonType(rawValue: sender.tag) == .removeFavorite {
            print("remove")
            model.removeFavorite(placeToDisplay!)
            if let del = delegate {
                del.dismissBuildingDetailController()
            }
        }
        
    }
    
    @IBAction func addToMapAction(sender: AnyObject) {
        if let del = delegate {
            del.plotOnMap(placeToDisplay!)
            del.dismissBuildingDetailController()
        }
    }

    @IBAction func doneButtonAction(sender: AnyObject) {
        if let del = delegate {
            del.dismissBuildingDetailController()
        }
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
