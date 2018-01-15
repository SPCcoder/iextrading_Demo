//
//  StockTableViewCell.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
   
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
