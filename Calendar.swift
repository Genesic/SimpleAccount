//
//  Calendar.swift
//  Account
//
//  Created by chuhenwei on 2016/4/29.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

class Calendar: PDTSimpleCalendarViewController, PDTSimpleCalendarViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "選擇日期"
        
        self.delegate = self
        //self.lastDate =
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let start = NSDate().timeIntervalSince1970 - 60*86400
        let components = NSCalendar.currentCalendar().components([.Month , .Year], fromDate: NSDate(timeIntervalSince1970: start) )
        let dateString = "\(components.year)-\(components.month)-01"
        let time = dateFormatter.dateFromString(dateString)?.timeIntervalSince1970
        self.firstDate = NSDate(timeIntervalSince1970: time!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let targetTab = segue.destinationViewController as! UITabBarController
        var controller = targetTab.viewControllers![0]
        if let nav = controller as? UINavigationController {
            controller = nav.visibleViewController!
        }
        if let hvc = controller as? AccountViewController {
            hvc.selectDate = self.selectedDate
        }
//        var destination = segue.destinationViewController as UIViewController
//        if let nav = destination as? UINavigationController {
//            destination = nav.visibleViewController!
//        }
//        
//        if let hvc = destination as? AccountViewController {
//            hvc.selectDate = self.selectedDate
//        }
    }
    
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        self.performSegueWithIdentifier("SelectDate", sender: self)
    }
}
