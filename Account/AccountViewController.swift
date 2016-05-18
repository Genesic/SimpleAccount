//
//  ViewController.swift
//  Account
//
//  Created by chuhenwei on 2016/4/28.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

struct AcionType {
    static var selectTitle: String = "請選擇圖片來源"
    static var takePic: String = "拍照"
    static var choosePic: String = "相簿"
    static var deletePic: String = "刪除"
    static var cancel: String = "取消"
}

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var selectDateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        accountModel = AccountDbModel(date: selectDate)
        let dateString = AccountModel.getDateString(selectDate)
        selectDateButton.setTitle(dateString, forState: .Normal)
        accountTableView.delegate = self
        accountTableView.dataSource = self
        totalCost = accountModel.getTotalCost()
        didModified = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PDTSimpleCalendarViewController {
            if segue.identifier == "NowSelectDate" {
                destination.selectedDate = selectDate
            }
        }
    }
    
    var totalCost: Int = 0 {
        didSet {
            totalCount.text = totalCost.description
            if totalCost > 0 {
                totalCount.textColor = UIColor.greenColor()
            } else if totalCost < 0 {
                totalCount.textColor = UIColor.redColor()
            } else {
                totalCount.textColor = UIColor.blackColor()
            }
        }
    }
    var newDetail = AccountDbDetail(item: nil, amount: nil, image: nil)
    var accountModel = AccountDbModel(date: NSDate())
    var selectDate: NSDate = NSDate()
    var didModified: Bool = false {
        didSet {
            saveButton.enabled = didModified
        }
    }
    var accountDetailList: [AccountDbDetail] {
        get {
            return accountModel.list
        }
    }
    @IBOutlet weak var totalCount: UILabel!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountDetailList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountDetail", forIndexPath: indexPath ) as! AccountTableViewCell
        
        let index = indexPath.row
        cell.updateUI(self, accountModel: accountModel, detail: accountDetailList[index], index: index)
        return cell
    }
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBAction func editItemTextField(sender: UITextField) {
        if canSaveModified() {
            didModified = true
            newDetail.item = sender.text
        }
    }
    @IBOutlet weak var amountTextField: UITextField!
    @IBAction func ediAmountTextField(sender: UITextField) {
        if canSaveModified() {
            didModified = true
            newDetail.amount = Int(sender.text!)
        }
    }
    func canSaveModified() -> Bool {
        if itemTextField.text == nil && amountTextField.text == nil && newDetail.image == nil {
            return false
        } else if itemTextField.text == "" && amountTextField.text == "" && newDetail.image == nil {
            return false
        }
        
        return true
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func clickAddButton(sender: UIButton) {
        accountModel.insertDetail(newDetail)
        self.accountTableView.reloadData()
        totalCost = accountModel.getTotalCost()
        didModified = false
        
        // 把新增欄位變回預設狀態
        newDetail = AccountDbDetail(item: nil, amount: nil, image: nil)
        setImageButtonToDefault()
        itemTextField.text = nil
        amountTextField.text = nil
    }
    
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func clickImageButton(sender: UIButton) {
        processSelectPic(nil)
    }
    
    // TabelViewCell修改細項
    func modifyItem(index: Int, detail: AccountDbDetail){
        accountModel.modifyDetail(detail)
        self.accountTableView.reloadData()
    }
    
    //  TableViewCell刪除細項
    func deleteItem(id: Int){
        accountModel.removeDetail(id)
        totalCost = accountModel.getTotalCost()
        self.accountTableView.reloadData()
    }
    
//======== 處理圖片 ==========
    var selectTableCell: Int?
    func processSelectPic(index: Int?){
        selectTableCell = index
        let actionSheet = UIAlertController(title: AcionType.selectTitle, message: nil, preferredStyle: .ActionSheet)
        
        // 取消按鈕
        let cancelAct = UIAlertAction(title: AcionType.cancel, style: .Cancel) { action -> Void in
        }
        actionSheet.addAction(cancelAct)
        
        // 拍照按鈕
        if UIImagePickerController.isSourceTypeAvailable( .Camera ) {
            //            let camera = UIImagePickerController()
            //            camera.delegate = self
            //            camera.sourceType = .Camera
            //            camera.mediaTypes = [kUTTypeImage as String]
            let takePicAct = UIAlertAction(title: AcionType.takePic , style: .Default){ action -> Void in
                self.initWithImagePickView(AcionType.takePic)
            }
            actionSheet.addAction(takePicAct)
        }
        
        // 相冊按鈕
        let choosePic = UIAlertAction(title: AcionType.choosePic, style: .Default) { action -> Void in
            self.initWithImagePickView(AcionType.choosePic)
        }
        actionSheet.addAction(choosePic)
        
        // 刪除按鈕
        if let selectIndex = selectTableCell {
            let selectDetail = accountDetailList[selectIndex]
            if selectDetail.image != nil {
                let deletePic = UIAlertAction(title: AcionType.deletePic, style: .Default ) { action in
                    selectDetail.image = nil
                    self.accountModel.modifyDetail(selectDetail)
                    self.accountTableView.reloadData()
                }
                actionSheet.addAction(deletePic)
            }
        } else {
            if newDetail.image != nil {
                let deletePic = UIAlertAction(title: AcionType.deletePic, style: .Default ) { action in
                    self.setImageButtonToDefault()
                    self.newDetail.image = nil
                }
                actionSheet.addAction(deletePic)
            }
        }
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func setImageButtonToDefault() {
        let defaultImage = UIImage(named: "DefaultPicture")
        self.imageButton.setBackgroundImage(defaultImage, forState: .Normal)
    }
    
    func initWithImagePickView(type: NSString){
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.allowsEditing = true;
        
        switch type {
        case AcionType.takePic as String:
            camera.sourceType = .Camera
            break
        case AcionType.choosePic as String:
            camera.sourceType = .PhotoLibrary
            break
        default:
            print("error")
        }
        
        presentViewController(camera, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let editImage = info[UIImagePickerControllerEditedImage] as! UIImage
        if let index = selectTableCell {
            // 點擊TableViewCell圖片按鈕
            let detailObj = accountDetailList[index]
            detailObj.image = editImage
            accountModel.modifyDetail(detailObj)
            self.accountTableView.reloadData()
        } else {
            // 點擊新增欄
            newDetail.image = editImage
            imageButton.setBackgroundImage(editImage, forState: .Normal)
            didModified = true
        }
        
        self.dismissViewControllerAnimated(true){ () -> Void in }
    }
//==========處理圖片結束=============
}