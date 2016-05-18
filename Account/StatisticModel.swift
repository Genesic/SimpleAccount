//
//  Statistic.swift
//  Account
//
//  Created by chuhenwei on 2016/5/1.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit
import SQLite

class StatisticDetail {
    var income: Int = 0
    var expand: Int = 0
    
    init(){
    }
    
    init(income: Int, expand: Int){
        self.income = income
        self.expand = expand
    }
}

class StatisticGroup {
    var title: String = ""
    var statisticDetail = StatisticDetail()
    
    init(title: String, detail: StatisticDetail ) {
        self.title = title
        self.statisticDetail = detail
    }
}

class StatisticModel {
    private var statisticGroup = [StatisticGroup]()
    let db = AccountDb()
    let dbConnection: Connection
    let accountTable: Table
    
    init(){
        self.dbConnection = db.dbConnection!
        self.accountTable = db.accountTable!
        loadData()
    }
    
    func loadData(){
        do {
            var dateDict = [Int: Int]()
            var incomeDict = [Int : Int]()
            var expandDict = [Int : Int]()
            // 計算收入
            let sql = "select date, sum(amount) from AccountList where amount > 0 group by date order by date"
            for row in try dbConnection.prepare(sql) {
                let date = Int(row[0] as! Int64)
                let income = Int(row[1] as! Int64)
                incomeDict[date] = income
                dateDict[date] = 1
            }
        
            // 計算支出
            let sql2 = "select date, sum(amount) from AccountList where amount < 0 group by date order by date"
            for row in try dbConnection.prepare(sql2) {
                let date = Int(row[0] as! Int64)
                let income = Int(row[1] as! Int64)
                expandDict[date] = income
                dateDict[date] = 1
            }
            
            // 計算每個月的收入和支出
            var monthDict = [Int: (String, Int, Int)]()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            for date in dateDict.keys {
                let nsDate = NSDate(timeIntervalSince1970: Double(date))
                let components = NSCalendar.currentCalendar().components([.Month , .Year], fromDate: nsDate)
                let title = "\(components.year)-\(components.month)"
                let dateString = "\(components.year)-\(components.month)-01"
                let time = dateFormatter.dateFromString(dateString)?.timeIntervalSince1970
                if let keyDoubleType = time {
                    let key = Int(keyDoubleType)
                    let income = incomeDict[date] ?? 0
                    let expand = expandDict[date] ?? 0
                    if let array = monthDict[key] {
                        let (name, incomeBefore, expandBefore) = array
                        monthDict[key] = (name, incomeBefore+income, expandBefore+expand )
                    } else {
                        monthDict[key] = (title, income, expand)
                    }
                }
            }
            
            // 把結果存進statisticGroup
            for key in monthDict.keys.sort(<) {
                let (title, income, expand) = monthDict[key]!
                let detail = StatisticDetail(income: income, expand: expand)
                let group = StatisticGroup(title: title, detail: detail)
                statisticGroup.append(group)
            }
        } catch let err as NSError {
            print (err.localizedFailureReason)
        }
    }
    
    func setStatisticData() {
        for month in 1...4 {
            let title = "2016-"+month.description
            let detail = StatisticDetail(income: 50000, expand: -month*10000)
            let group = StatisticGroup(title: title, detail: detail)
            statisticGroup.append(group)
        }
    }
    
    func getStatisticData() -> [StatisticGroup] {
        return statisticGroup
    }
}