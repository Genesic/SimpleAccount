//
//  StatisticHeaderView.swift
//  Account
//
//  Created by chuhenwei on 2016/5/1.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

protocol StatisticHeaderViewDelegate: NSObjectProtocol {
    func statisticHeaderView(statisticHeaderView: StatisticHeaderView, sectionOpen: Int )
    func statisticHeaderView(statisticHeaderView: StatisticHeaderView, sectionClose: Int )
}

class StatisticHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var disclosureBtn: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var delegate: StatisticHeaderViewDelegate?
    var section: Int!
    
    override func awakeFromNib() {
        self.disclosureBtn.setTitle("▾", forState: .Selected)
        disclosureBtn.selected = false
    }
    
    @IBAction func disclosureTap(sender: UIButton) {
        toggleOpenWithUserAction(true)
    }
    
    func setDetail(total: Int, title: String?, section: Int){
        self.section = section
        self.titleText.text = title
        if total > 0 {
            totalLabel.text = "+" + total.description
            totalLabel.textColor = UIColor.greenColor()
        } else if total < 0 {
            totalLabel.text = total.description
            totalLabel.textColor = UIColor.redColor()
        } else {
            totalLabel.text = "0"
            totalLabel.textColor = UIColor.blackColor()
        }
    }
    
    func toggleOpenWithUserAction(userAction: Bool){
        
        if userAction {
            if disclosureBtn.selected {
                delegate?.statisticHeaderView(self, sectionClose: section)
            } else {
                delegate?.statisticHeaderView(self, sectionOpen: section)
            }
        }
        
        disclosureBtn.selected = !disclosureBtn.selected
    }
}
