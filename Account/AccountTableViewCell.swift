//
//  AccountTableViewCell.swift
//  Account
//
//  Created by chuhenwei on 2016/4/29.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var indexText: UILabel!
    var viewController: AccountViewController?
    var accountModel: AccountDbModel?
    var detail: AccountDbDetail?
    var index: Int? {
        didSet {
            if let show = index {
                indexText.text = (show+1).description
            }
        }
    }
    
    func updateUI(viewController: AccountViewController, accountModel: AccountDbModel, detail: AccountDbDetail, index: Int){
        self.viewController = viewController
        self.accountModel = accountModel
        self.detail = detail
        self.index = index
        
        itemTextField.text = detail.item
        amountTextField.text = detail.amount?.description
        if let image = detail.image {
            imageButton.setBackgroundImage(image, forState: .Normal)
        } else {
            let defaultImage = UIImage(named: "DefaultPicture")
            imageButton.setBackgroundImage(defaultImage, forState: .Normal)
        }
    }
    
    @IBAction func editItemTextEnd(sender: UITextField) {
        if sender.text != nil {
            if let detail = self.detail {
                detail.item = sender.text
                accountModel?.modifyDetail(detail)
            }
        }
    }
    @IBAction func editAmountText(sender: AnyObject) {
        if sender.text != nil {
            if let detail = self.detail {
                detail.amount = Int(sender.text!)
                accountModel?.modifyDetail(detail)
                viewController?.totalCost = accountModel?.getTotalCost() ?? 0
            }
        }
    }

    @IBAction func clickImageButton(sender: UIButton) {
        viewController?.processSelectPic(index)
    }
    @IBAction func deleteDetail(sender: UIButton) {
        if let obj = detail {
            viewController?.deleteItem(obj.id!)
        }
    }
}
