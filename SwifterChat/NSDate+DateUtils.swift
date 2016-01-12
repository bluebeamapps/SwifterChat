//
//  NSDate+DateUtils.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 1/2/16.
//  Copyright © 2016 Bluebeam Apps. All rights reserved.
//

import Foundation

extension NSDate {
    
    //Returns date as a time elapsed string.
    func elapsedTimeString() -> String {
        let now = NSDate()
        
        var fromDate: NSDate?
        var toDate: NSDate?
        
        let calendar = NSCalendar.currentCalendar()
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &toDate, interval: nil, forDate: now)
        
        let components = calendar.components(NSCalendarUnit.Day, fromDate: fromDate!, toDate: toDate!, options: NSCalendarOptions())
        let days = components.day
        
        var dateString: String?
        
        if days > 30 {
            //Normal date.
            let df = NSDateFormatter()
            df.dateStyle = NSDateFormatterStyle.MediumStyle
            dateString = df.stringFromDate(self)
        }
        else if days > 1 {
            //Days ago.
            dateString = "\(days) days ago"
        }
        else if days == 1 {
            //Yesterday
            dateString = "Yesterday"
        }
        else if days <= 0 {
            //Today
            dateString = "Today"
        }
        
        return dateString!
    }

    
}