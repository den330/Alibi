//
//  LocationCell.swift
//  Alibi
//
//  Created by Yaxin Yuan on 16/3/31.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

class LocationCell: UITableViewCell{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func getDate(date: NSDate) -> String{
        return dateFormatter.stringFromDate(date)
    }
    
    func configureForLocation(location: Location){
        addressLabel.text = location.address
        dateLabel.text = getDate(location.date)
    }
    
    
    
    

}