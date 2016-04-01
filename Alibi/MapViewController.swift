//
//  MapViewController.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/4/1.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
    }
    
    @IBAction func showUser(){
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations(){
        
    }
    
    func updateLocations(){
        mapView.removeAnnotations(locations)
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        locations = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Location]
        mapView.addAnnotations(locations)
    }
    
}

extension MapViewController: MKMapViewDelegate{
    
}
