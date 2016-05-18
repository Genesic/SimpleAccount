//
//  AccountModel.swift
//  Account
//
//  Created by chuhenwei on 2016/4/28.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import Foundation
import SQLite

class AccountImage {
    // image = UIImage , fileName = String  已儲存圖片
    // image = UIImage , fileName = nil     未儲存圖片
    // image = nil     , fileName = nil     無圖片
    var image: UIImage?
    var fileName: String?
    
    init(image: UIImage, fileName: String?){
        self.image = image
        self.fileName = fileName
    }
    
    func createFileName() -> String{
        return Int(NSDate().timeIntervalSince1970).description+".png"
    }
    
    func saveImage(documentPath: String){
        if fileName == nil {
            if let imageObj = image {
                if let data = UIImagePNGRepresentation(imageObj) {
                    let createName = createFileName()
                    let path = documentPath + createName
                    do{
                        try NSFileManager().createDirectoryAtPath(documentPath, withIntermediateDirectories: true, attributes: nil)
                    } catch let err as NSError {
                        print(err.localizedDescription)
                    }
                    let res = data.writeToFile(path, atomically: true)
                    if res {
                        self.fileName = createName
                    }
                }
            }
        }
    }
    
    func deleteImage(documentPath: String){
        if let imageName = fileName {
            let filePath = documentPath + imageName
            do{
                try NSFileManager().removeItemAtPath(filePath)
                image = nil
                fileName = nil
            } catch let err as NSError {
                print (err.localizedDescription)
            }
        }
    }
}

class AccountDetail {
    var id: Int?
    var item: String?
    var cost: Int?
    var pic: UIImage?
    var image: AccountImage?
    
    init(id: Int, item: String?, cost: Int?, image: AccountImage?){
        self.id = id
        self.item = item
        self.cost = cost
        self.image = image
    }
    
    init(item: String?, cost: Int?, image: AccountImage?){
        self.item = item
        self.cost = cost
        self.image = image
    }
}

class AccountModel {
    private var accountDetailList = [AccountDetail]()
    
    let selectDate: NSDate
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()

    init(date: NSDate){
        self.selectDate = date
        loadFromFile()
    }
    
    static func getDateString(date: NSDate) -> String {
        let components = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: date)
        return "\(components.year)-\(components.month)-\(components.day)"
    }
    
    func getFilePath() -> String {
        return NSHomeDirectory() + "/Documents/" + AccountModel.getDateString(selectDate) + "/"
    }
    
    func getInfoFilePath() -> String {
        return getFilePath() + "info"
    }
    
    func loadImage(imageName: String?) -> UIImage? {
        if let fileName = imageName {
            let path = getFilePath() + fileName
            if let image = UIImage(contentsOfFile: path) {
                return image
            }
        }
        return nil
    }
    
    func getTotalCount() -> Int {
        return accountDetailList.reduce(0) { $0 + ($1.cost ?? 0) }
    }
    
    func saveData(){
        var dictArray = [[String: String]]()
        for detail in accountDetailList {
            var newObj = [String: String]()
            if let item = detail.item{
                newObj["item"] = item
            }
            if let cost = detail.cost{
                newObj["cost"] = cost.description
            }
            if let imageObj = detail.image {
                imageObj.saveImage(getFilePath())
                if let fileName = imageObj.fileName {
                    newObj["imageName"] = fileName
                }
            }
            dictArray.append(newObj)
        }
        
        do{
            let json = try NSJSONSerialization.dataWithJSONObject(dictArray, options: .PrettyPrinted)
            try json.writeToFile(getInfoFilePath(), options: .DataWritingAtomic)
        }catch let err as NSError {
            print (err.localizedDescription)
        }
    }
    
    struct AccountList {
        static var id = Expression<Int>("id")
        static var date = Expression<Int>("date")
        static var ctime = Expression<Int>("ctime")
        static var item = Expression<String?>("item")
        static var amount = Expression<Int?>("amount")
        static var imageName = Expression<String?>("imageName")
        static var image = Expression<Blob?>("image")
    }
    
    func loadFromFile(){
        let fm = NSFileManager()
        let infoFilePath = getInfoFilePath()
        
        if fm.fileExistsAtPath(infoFilePath) {
            do {
                let jsonFile = try NSString(contentsOfFile: infoFilePath, encoding: NSUTF8StringEncoding)
                if let jsonData = jsonFile.dataUsingEncoding(NSUTF8StringEncoding){
                    let jsonAnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0))
                    if let list = jsonAnyObject as? [AnyObject] {
                        for element in list {
                            if let dict = element as? [String: String] {
                                let item = dict["item"]
                                var cost: Int? = nil
                                if let costString = dict["cost"]{
                                    cost = Int(costString)
                                }
                                let imageName = dict["imageName"]
                                var image: AccountImage? = nil
                                if let imageObj = loadImage(imageName) {
                                    image = AccountImage(image: imageObj, fileName: imageName)
                                }
                                let data = AccountDetail(item: item, cost: cost, image: image)
                                accountDetailList.append(data)
                            }
                        }
                    }
                }
            } catch let err as NSError {
                print(err.localizedDescription)
            }
        }
    }
    
    func addItem(newObj: AccountDetail){
        accountDetailList.append(newObj)
        saveData()
    }
    
    func removeItem(index: Int){
        accountDetailList[index].image?.deleteImage(getFilePath())
        accountDetailList.removeAtIndex(index)
        saveData()
    }
    
    func modifyItem(index: Int, modifier: AccountDetail){
        accountDetailList[index] = modifier
        saveData()
    }
    
    func getAccountList() -> [AccountDetail] {
        return accountDetailList
    }
}