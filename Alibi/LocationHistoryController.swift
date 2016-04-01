//
//  SecondViewController.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/3/29.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation



class LocationHistoryController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    func performFetch(){
        do{
            try fetchedResultsController.performFetch()
        }catch{
            return
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! LocationCell
            let location = fetchedResultsController.objectAtIndexPath(indexPath) as! Location
            cell.configureForLocation(location)
            return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let location = fetchedResultsController.objectAtIndexPath(indexPath) as! Location
            managedObjectContext.deleteObject(location)
            do{
                try managedObjectContext.save()
            }catch{
                return
            }
        }
    }
}

extension LocationHistoryController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        
        case .Insert:
            
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? LocationCell {
                let location = controller.objectAtIndexPath(indexPath!) as! Location
                cell.configureForLocation(location)
            }
            
        default: break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}


