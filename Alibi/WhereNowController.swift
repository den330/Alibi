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
    
    @IBOutlet weak var message: UILabel!    
    
    var managedObjectContext: NSManagedObjectContext!
    
    var location: CLLocation?
    var CurrentLocation: String!
    
    var startGeoCode = false
    
    var stateString = ""
    
    let (Searching, Finished, NotStarted, Error) = ("Searching", "Finished", "Not Started", "Error")
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    //Start, Stop, Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateString = NotStarted
        configureMessage()
    }
    
    func initialize(){
        location = nil
        startGeoCode = false
    }
    
    func startUpdate(){
        initialize()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.startUpdatingLocation()
        stateString = Searching
        configureMessage()
    }
    
    func stopUpdate(){
        manager.delegate = nil
        manager.stopUpdatingLocation()
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
        startUpdate()
    }
    
    func configureMessage(){
        switch stateString{
            case Searching: message.text = "Searching..."
            case Finished: message.text = "Here you go"
            case Error: message.text = "Found Error"
            case NotStarted: message.text = "Tap 'Where am I' to get start"
            default: break
        }
    }
    

    //Receiving End
    
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
                    self.stateString = self.Finished
                    self.CurrentLocation = stringFromPlacemark(p.last!)
                    self.alert()
                    self.configureMessage()
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.LocationUnknown.rawValue{
            return
        }
        
        stateString = Error
        stopUpdate()
        configureMessage()
    }
    
    
    
    //Some Alert
    
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
    }
    
    
    //Save
    
    func saveLocation(){
        let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext) as! Location
        location.address = CurrentLocation
        let date = NSDate()
        location.date = date
        
        do{
            try managedObjectContext.save()
        }catch{
            return
        }
    }
}
    
    
    
    





