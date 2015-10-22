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
    
    var delegate : BuildingDetailProtocol?
    var placeToDisplay : BuildingModel.Place?
    
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
            
//            if let y = place.addressString {
//                print(y)
//                locationLabel.text = y
//            } else {
//                locationLabel.text = "No address"
//            }
            
            if model.isPlaceFavorite(place) {
                favoriteActionButton.hidden = true
                detailActionButton.setTitle("Hide On Map", forState: .Normal)
                detailActionButton.backgroundColor = UIColor.blueColor()
            }
            
            let coordinate = place.coordinate
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
//                        if x.country != nil {
//                            addressString = addressString + x.country!
//                        }
                        
                        //                        print(addressString)
                    }
                    print(addressString)
                    self.locationLabel.text = addressString
                    self.locationLabel.sizeToFit()
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonAction(sender: AnyObject) {
    }
    @IBAction func detailButtonAction(sender: AnyObject) {
        if let del = delegate {
            del.deletePlaceFromMap(placeToDisplay!)
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
