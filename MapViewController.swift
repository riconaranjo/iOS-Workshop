//
//  MapViewController.swift
//  Places
//
//  Created by Federico Naranjo Bellina on 25/3/18.
//  Copyright © 2018 Federico Naranjo Bellina. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    @IBAction func addPlace(_ sender: Any) {
        print("add place MapVC")
        getPlacemark(userLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sets up the delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // show user as blue dot
        mapView.showsUserLocation = true
        
        // allow long press to add map pin
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.addLongPressLocation(_:)))
        mapView.addGestureRecognizer(uilpgr)
        uilpgr.minimumPressDuration = 0.35
        
        addMapPins()
    }
    
    /// add location where long press
    @IBAction func addLongPressLocation(_ sender: UILongPressGestureRecognizer) {
        
        // gets location of long press relative to map
        if (sender.state == UIGestureRecognizerState.began) {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let pressed = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            getPlacemark(pressed)
        }
    }
    
    /// Add Map Pins in locations array
    func addMapPins() {
        for index in 0..<addresses.count {
            let annotation = MKPointAnnotation()
            let address = addresses[index]
            let long = longitudes[index]
            let lat = latitudes[index]
            
            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            annotation.title = address
            self.mapView.addAnnotation(annotation)
        }
    }
    
    /// store place in arrays
    func savePlace(address:String, longitude:CLLocationDegrees, latitude:CLLocationDegrees) {
        addresses.append(address)
        longitudes.append(longitude)
        latitudes.append(latitude)
    }
    
    /// takes the CLLocation, and finds the placemark from reverse geocoder
    func getPlacemark(_ cllocation:CLLocation) {
        CLGeocoder().reverseGeocodeLocation(cllocation, completionHandler: { (placemarks, error ) in
            
            if error != nil || placemarks == nil || placemarks!.count == 0 {
                print(error ?? "Unknown error in geocoder")
                return
            }

            let place = placemarks![0] as CLPlacemark

            // parse address and cordinates
            let address = self.parseAddress(place)
            let latitude = cllocation.coordinate.latitude
            let longitude = cllocation.coordinate.longitude

            // create map annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = address
            self.mapView.addAnnotation(annotation)
            self.savePlace(address: address, longitude: longitude, latitude: latitude)
        })
    }
    
    /// Parses location from CLPlacemark place and stores it in address
    func parseAddress(_ place: CLPlacemark) -> String {
        var address = ""
        var locality = place.locality ?? ""
        var thoroughfare = place.thoroughfare ?? ""
        var subThoroughfare = place.subThoroughfare ?? ""
        
        // if all paramters are empty, add country
        if subThoroughfare == "" && thoroughfare == "" && locality == "" {
            address = place.country ?? "No country or address found"
            return address
        }
        
        // add space after section if not empty
        if locality         != "" { locality += " " }
        if thoroughfare     != "" { thoroughfare += " " }
        if subThoroughfare  != "" { subThoroughfare += " " }
        
        address = "\(subThoroughfare)\(thoroughfare)\(locality)"
        print(address)
        return address
    }
    
    /// Automatically updates the GPS location of user and where map is centred.
    /// This function is called by the system
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        userLocation = locations[0]     // the last user location
        
        // field of view, how zoomed in the map is
        let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.02,0.02)
        
        // centre map on the user
        let region = MKCoordinateRegionMake(userLocation.coordinate,mapSpan)
        self.mapView.setRegion(region, animated: false)  // animated will make make zoom in on location
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
