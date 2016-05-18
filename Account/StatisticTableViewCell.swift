//
//  StatisticTableViewCell.swift
//  Account
//
//  Created by chuhenwei on 2016/5/1.
//  Copyright © 2016年 chuhenwei. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {

    @IBOutlet weak var incomeText: UILabel!
    @IBOutlet weak var expendText: UILabel!
    
    func setDetail(statisticDetail: StatisticDetail){
        incomeText.text = statisticDetail.income.description
        expendText.text = statisticDetail.expand.description
    }
}
