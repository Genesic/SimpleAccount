//
//  StatisticTableViewController.swift
//  Account
//
//  Created by chuhenwei on 2016/5/1.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

struct ViewId {
    static var StatisticHeaderViewId = "StatisticHeaderViewId"
    static var StatisticTableViewCellId = "StatisticTableViewCellId"
}

class StatisticCellInfo {
    var open: Bool = false
    var statisticGroup: StatisticGroup?
    var headerView: StatisticHeaderView?
    
    init(group:StatisticGroup){
        self.statisticGroup = group
    }
    
    func countOfRow() -> Int {
        return 1
    }
}

class StatisticTableViewController: UITableViewController, StatisticHeaderViewDelegate {
    
    var statisticModel = StatisticModel()
    var statisticCellInfo = [StatisticCellInfo]()
    var statisticData : [StatisticGroup] {
        get {
            return self.statisticModel.getStatisticData()
        }
    }
    var openSectionIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let statisticHeaderNib = UINib(nibName: "StatisticHeaderView", bundle: nil)
        tableView.registerNib(statisticHeaderNib, forHeaderFooterViewReuseIdentifier: ViewId.StatisticHeaderViewId )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        statisticModel = StatisticModel()
        for statisticGroup in statisticData {
            let cellInfo = StatisticCellInfo(group: statisticGroup)
            statisticCellInfo.append(cellInfo)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return statisticData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openSectionIndex != nil {
            if section == openSectionIndex {
                return 1
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewId.StatisticTableViewCellId) as! StatisticTableViewCell
        let cellInfo = statisticCellInfo[indexPath.section]
        if let statisticGroup = cellInfo.statisticGroup {
            cell.setDetail(statisticGroup.statisticDetail)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let statisticHeaderView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(ViewId.StatisticHeaderViewId) as! StatisticHeaderView
        let cellInfo = statisticCellInfo[section]
        cellInfo.headerView = statisticHeaderView
        
        if let statisticGroup = cellInfo.statisticGroup {
            let total = statisticGroup.statisticDetail.expand + statisticGroup.statisticDetail.income
            statisticHeaderView.setDetail(total, title: statisticGroup.title, section: section)
            statisticHeaderView.delegate = self
        }
        
        return statisticHeaderView
    }
    
    func statisticHeaderView(statisticHeaderView: StatisticHeaderView, sectionOpen: Int) {
        let cellInfo = statisticCellInfo[sectionOpen]
        cellInfo.open = true
        
        //var insertRows = 1
        let indexPathsToInsert = [NSIndexPath(forRow: 0, inSection: sectionOpen)]

        var indexPathsToDelete = [NSIndexPath]()
        if let lastOpenSection = openSectionIndex {
            let lastCellInfo = statisticCellInfo[lastOpenSection]
            lastCellInfo.open = false
            lastCellInfo.headerView?.toggleOpenWithUserAction(false)
            indexPathsToDelete.append(NSIndexPath(forRow: 0, inSection: lastOpenSection))
        }
        
        // 開關動畫
        let insertAnimation = openSectionIndex == nil || sectionOpen < openSectionIndex ? UITableViewRowAnimation.Top : UITableViewRowAnimation.Bottom
        let deleteAnimation = openSectionIndex == nil || sectionOpen < openSectionIndex ? UITableViewRowAnimation.Bottom : UITableViewRowAnimation.Top

        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: deleteAnimation)
        tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation: insertAnimation)
        
        openSectionIndex = sectionOpen
        tableView.endUpdates()
    }
    
    func statisticHeaderView(statisticHeaderView: StatisticHeaderView, sectionClose: Int) {
        let cellInfo = statisticCellInfo[sectionClose]
        cellInfo.open = false

        let indexPathsToDelete = [NSIndexPath(forRow: 0, inSection: sectionClose)]
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: UITableViewRowAnimation.Top)
        openSectionIndex = nil
        tableView.endUpdates()
    }
}
