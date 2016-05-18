//
//  AccountDbModel.swift
//  Account
//
//  Created by chuhenwei on 2016/5/4.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import Foundation
import SQLite

class AccountDbDetail {
    var id: Int?
    var item: String?
    var amount: Int?
    var image: UIImage?
    
    init(){
    }
    
    init(item: String?, amount: Int?, image: UIImage?) {
        self.item = item
        self.amount = amount
        self.image = image
    }
}

struct DbTable {
    static var id = Expression<Int>("id")
    static var date = Expression<Int>("date")
    static var ctime = Expression<Int>("ctime")
    static var item = Expression<String?>("item")
    static var amount = Expression<Int?>("amount")
    static var imageName = Expression<String?>("imageName")
    static var image = Expression<Blob?>("image")
}

class AccountDb {
    let path = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true).first!
    var dbConnection: Connection?
    var accountTable: Table?
    
    init(){
        do {
            dbConnection = try Connection(path+"/AccountDb.sqlite3")
            accountTable = Table("AccountList")
            //let stmt = "CREATE TABLE IF NOT EXISTS AccountList (id INTEGER PRIMARY KEY, date INTEGER NOT NULL, ctime INTEGER NOT NULL, item TEXT, amount INTEGER, imageName TEXT, image BLOB)"
            try dbConnection!.run(accountTable!.create(ifNotExists: true){ t in
                t.column(DbTable.id, primaryKey: true)
                t.column(DbTable.date)
                t.column(DbTable.item)
                t.column(DbTable.amount)
                t.column(DbTable.image)
            })
        } catch let err as NSError {
            print (err.localizedFailureReason)
        }
    }
}

class AccountDbModel {
    var list = [AccountDbDetail]()
    var selectDate: NSDate
    let db = AccountDb()
    let dbConnection: Connection
    let accountTable: Table
    
    init(date: NSDate){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateString = formatter.stringFromDate(date)
        self.selectDate = formatter.dateFromString(dateString)!
        self.dbConnection = db.dbConnection!
        self.accountTable = db.accountTable!
        self.loadData()
    }
    
    func loadData() {
        do {
            //let stmt = "CREATE TABLE IF NOT EXISTS AccountList (id INTEGER PRIMARY KEY, date INTEGER NOT NULL, ctime INTEGER NOT NULL, item TEXT, amount INTEGER, imageName TEXT, image BLOB)"
            try dbConnection.run(accountTable.create(ifNotExists: true){ t in
                t.column(DbTable.id, primaryKey: true)
                t.column(DbTable.date)
                t.column(DbTable.item)
                t.column(DbTable.amount)
                t.column(DbTable.image)
                })
            
            let time = Int(selectDate.timeIntervalSince1970)
            let stmt = accountTable.select(DbTable.id, DbTable.item, DbTable.amount, DbTable.imageName, DbTable.image).filter(DbTable.date == time ).order(DbTable.id)
            for account in try dbConnection.prepare(stmt) {
                let detail = AccountDbDetail()
                detail.id = account[DbTable.id]
                detail.item = account[DbTable.item]
                detail.amount = account[DbTable.amount]
                if let imageObj = account[DbTable.image] {
                    detail.image = UIImage.fromDatatypeValue(imageObj)
                }
                list.append(detail)
            }
        } catch let err as NSError {
            print (err.localizedDescription)
        }
    }
    
    func insertDetail(detail: AccountDbDetail) {
        do {
            print("date:"+selectDate.datatypeValue.description )
            let stmt = accountTable.insert(
                DbTable.date <- selectDate.datatypeValue ,
                DbTable.item <- detail.item,
                DbTable.amount <- detail.amount,
                DbTable.image <- detail.image?.datatypeValue
            )
            print(stmt.template)
            try dbConnection.run(stmt)
            list.append(detail)
        } catch let err as NSError {
            print ("desc: " + err.localizedDescription)
            print (err.localizedFailureReason)
        }
    }
    
    func removeDetail(id: Int) {
        do {
            let stmt = accountTable.filter(DbTable.id == id).delete()
            try dbConnection.run(stmt)
            list = list.filter({$0.id != id})
        }catch let err as NSError {
            print (err.localizedDescription)
        }
    }
    
    func modifyDetail(detail: AccountDbDetail){
        if let id = detail.id {
            do {
                let stmt = accountTable.filter(DbTable.id == id).update(DbTable.item <- detail.item, DbTable.amount <- detail.amount, DbTable.image <- detail.image?.datatypeValue)
                try dbConnection.run(stmt)
                
                
                if let idx = list.indexOf({$0.id == detail.id}) {
                    list[idx] = detail
                }
            } catch let err as NSError {
                print (err.localizedDescription)
            }
            
        }
    }
    
    // 取得list內所有amount的總和
    func getTotalCost() -> Int {
        return list.flatMap({$0.amount}).reduce(0, combine: +)
    }
}

extension NSDate {
    class var declaredDatatype: String {
        return Int.declaredDatatype
    }
    class func fromDatatypeValue(intValue: Int) -> Self {
        return self.init(timeIntervalSince1970: NSTimeInterval(intValue))
    }
    var datatypeValue: Int {
        return Int(timeIntervalSince1970)
    }
}

extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    public class func fromDatatypeValue(blobValue: Blob) -> UIImage {
        return UIImage(data: NSData.fromDatatypeValue(blobValue))!
    }
    public var datatypeValue: Blob {
        return UIImagePNGRepresentation(self)!.datatypeValue
    }
}
