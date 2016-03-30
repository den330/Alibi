//
//  FirstViewController.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/3/29.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreLocation

class WhereNowController: UIViewController, CLLocationManagerDelegate {
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    var CurrentLocation = ""
    
    var startGeoCode = false
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getCurrentLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
    }
    
    func stopUpdate(){
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        if location == nil || newLocation.horizontalAccuracy < location!.horizontalAccuracy{
            location = newLocation
            if newLocation.horizontalAccuracy <= manager.desiredAccuracy{
                stopUpdate()
                startGeoCode = true
            }
        }
        if startGeoCode{
            geoCoder.reverseGeocodeLocation(location!){
                placemarks, _ in
                if let p = placemarks where !p.isEmpty{
                    self.placemark = p.last
                    self.CurrentLocation = self.stringFromPlacemark(self.placemark!)
                    self.alert()
                    self.startGeoCode = false
                }
            }
        }
    }
    
    func alert(){
        let alert = UIAlertController(title: "Current Location", message: CurrentLocation, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error")
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String{
        var line1 = ""
        
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        if let s = placemark.thoroughfare {
            line1 += s
        }
        
        var line2 = ""
        
        if let s = placemark.locality {
            line2 += s + " "
        }
        if let s = placemark.administrativeArea {
            line2 += s + " "
        }
        if let s = placemark.postalCode {
            line2 += s
        }
        
        return line1 + "\n" + line2
    }
}
    
    
    
    





