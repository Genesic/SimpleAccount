//
//  MainTabController.swift
//  Account
//
//  Created by chuhenwei on 2016/5/1.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    var selectDate: NSDate?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let storyAccount = UIStoryboard(name: "Account", bundle: nil)
//        let accountViewController = storyAccount.instantiateViewControllerWithIdentifier("AccountNav") as! UINavigationController
//        accountViewController.tabBarItem = UITabBarItem(title: "Account", image: nil, tag: 0)
//        
//        let storyStatistic = UIStoryboard(name: "Statistic", bundle: nil)
//        let statisticViewControlller = storyStatistic.instantiateViewControllerWithIdentifier("StatisticNav") as! UINavigationController
//        statisticViewControlller.tabBarItem = UITabBarItem(title: "Statistic", image: nil, tag: 1)
//        
//        self.viewControllers = [accountViewController, statisticViewControlller]
//        performSegueWithIdentifier("SetDate", sender: self)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var destination = segue.destinationViewController as UIViewController
//        if let nav = destination as? UINavigationController {
//            destination = nav.visibleViewController!
//        }
//        
//        if let hvc = destination as? AccountViewController {
//            if let date = selectDate{
//                hvc.selectDate = date
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//        if item.tag == 1 {
//            if let nav = self.viewControllers?[1] as? UINavigationController {
//                if let table = nav.visibleViewController as? UITableViewController {
//                    table.tableView.reloadData()
//                }
//            }
//        } else if item.tag == 2 {
//            print("2")
//        }
//    }

}
