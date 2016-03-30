//
//  FirstViewController.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/3/29.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData




class WhereNowController: UIViewController, CLLocationManagerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    var location: CLLocation?
    var placemark: CLPlacemark?
    var CurrentLocation: String!
    
    var startGeoCode = false
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    func initialize(){
        location = nil
        startGeoCode = false
    }
    

    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = "Tap 'Where am I' to locate yourself"
    }
    
    @IBAction func getCurrentLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted{
            permissonAlert()
            return
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        initialize()
        manager.startUpdatingLocation()
        message.text = "Searching..."
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
                }
            }
        }
    }
    
    func permissonAlert(){
        let alert = UIAlertController(title: "Location Permisson", message: "Location Service Disabled", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func alert(){
        let alert = UIAlertController(title: "Current Location", message: CurrentLocation, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        let action2 = UIAlertAction(title: "Save", style: .Default, handler: {_ in self.saveLocation()})
        alert.addAction(action)
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
        message.text = "Here you are!"
    }
    
    func saveLocation(){
        let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext) as! Location
        location.address = CurrentLocation!
        let date = NSDate()
        location.date = date
        
        do{
            try managedObjectContext.save()
        }catch{
            print("error")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.LocationUnknown.rawValue{
            return
        }
        stopUpdate()
        message.text = "Error"
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
    
    
    
    





