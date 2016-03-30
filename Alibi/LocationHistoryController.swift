//
//  SecondViewController.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/3/29.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreData

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

class LocationHistoryController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchrequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchrequest.entity = entity
        fetchrequest.sortDescriptors = [sortDescriptor]
        
        do{
            let foundObjects = try managedObjectContext.executeFetchRequest(fetchrequest)
            locations = foundObjects as! [Location]
        }catch{
            return
        }
    }
    
    func getDate(date: NSDate) -> String{
        return dateFormatter.stringFromDate(date)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
            let location = locations[indexPath.row]
            let addressLabel = cell.viewWithTag(1000) as! UILabel
            let dateLabel = cell.viewWithTag(1001) as! UILabel
            addressLabel.text = location.address
            dateLabel.text = getDate(location.date)
            return cell
    }

}

