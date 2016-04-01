//
//  Location.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/3/30.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Location: NSManagedObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    var title: String? {
        return address
    }
    
    var subtitle: String? {
        return ""
    }

}
