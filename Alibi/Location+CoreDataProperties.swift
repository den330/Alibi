//
//  Location+CoreDataProperties.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/4/1.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var address: String?
    @NSManaged var date: NSDate
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double

}
