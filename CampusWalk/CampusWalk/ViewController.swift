//
//  ViewController.swift
//  CampusWalk
//
//  Created by Max Marze on 10/19/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, BuildingDetailProtocol {

    let model = BuildingModel.sharedInstance
    let locationManager = CLLocationManager()
    
    var favoritesCount = 0
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let initialLocation = CLLocation(latitude: 40.7982173, longitude: -77.8620971)
        centerMapOnLocation(initialLocation)
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
    }
    
    override func viewDidLayoutSubviews() {
        refreshPins()
//        if favoritesCount != model.favoritesToPlot().count {
//            print("here")
//            favoritesCount = model.favoritesToPlot().count
//            mapView.addAnnotations(model.favoritesToPlot())
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    func refreshPins() {
        let favoritesToDelete = model.favoritesToDeleteFromMap()
        if !favoritesToDelete.isEmpty {
            UIView.animateWithDuration(1.1) { self.mapView.removeAnnotations(favoritesToDelete) }
            model.clearFavoritesToDelete()
        }
//        let favoriteAnnotations = mapView.annotations.filter {
//            if $0 is BuildingModel.Place {
//                print("In filter")
//                return true
//            }
////            if let x = $0 as? MKPinAnnotationView {
////                print("In filter")
////                if x.reuseIdentifier == "favoritePin" {
////                    return true
////                }
////            }
//            return false
//        }
        
        mapView.addAnnotations(model.favoritesToPlot())
        
        for x in model.favoritesToPlot() {
            let annotationView = mapView.viewForAnnotation(x)
            if let y = annotationView {
                y.hidden = false
            }
        }
        
        for x in model.favoritesToHide() {
            let annotationView = mapView.viewForAnnotation(x)
            if let y = annotationView {
                y.hidden = true
            }
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse {
//            mapView.showsUserLocation = true
//            locationManager.startUpdatingLocation()
//        } else {
//            mapView.showsUserLocation = false
//            locationManager.stopUpdatingLocation()
//        }
//    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let annotation = annotation as? BuildingModel.Place {
            let identifier : String = model.isPlaceFavorite(annotation) ? "favoritePin" : "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
                let rightCalloutButton = UIButton(type: .DetailDisclosure)
                
                view.rightCalloutAccessoryView = rightCalloutButton as UIView
                view.pinTintColor = identifier == "pin" ? MKPinAnnotationView.redPinColor() : MKPinAnnotationView.purplePinColor()
                view.animatesDrop = true
                
                
            }
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let buildingDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("buildingDetailVC") as! BuildingDetailViewController
        buildingDetailVC.delegate = self
        buildingDetailVC.placeToDisplay = view.annotation as? BuildingModel.Place
        
        self.presentViewController(buildingDetailVC, animated: true, completion: nil)
    }
    
//    func pinButtonTap(sender:AnyObject) {
//        print("PIN PRESS")
//    }

    func dismissBuildingDetailController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func deletePlaceFromMap(place: BuildingModel.Place) {
        mapView.removeAnnotation(place)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "searchSegue":
                let searchTableVC = (segue.destinationViewController as! UINavigationController).topViewController as! SearchTableViewController
                searchTableVC.mainViewController = self
        case "favoriteSegueFromMap":
            let favoritesTableVC = (segue.destinationViewController as! UINavigationController).topViewController as! FavoritesTableViewController
            favoritesTableVC.mainViewController = self
            
        default:
            break
        }
    }
    
    enum MapType : Int {
        case Standard = 0;
        case Hybrid = 1;
        case Satellite = 2;
    }
    
    @IBAction func changeMapType(sender: AnyObject) {
        let mapTypeSegmentedControl = sender as! UISegmentedControl
        let mapType = MapType(rawValue: mapTypeSegmentedControl.selectedSegmentIndex)
        switch (mapType!) {
        case .Standard:
            mapView.mapType = MKMapType.Standard
        case .Hybrid:
            mapView.mapType = MKMapType.Hybrid
        case .Satellite:
            mapView.mapType = MKMapType.Satellite
        }
    }
        
    func plotPlaceAtIndex(indexPath : NSIndexPath) {
        mapView.addAnnotations(model.placesToPlot())
    }

}

