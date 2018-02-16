//
//  TableViewControllerTableViewCell.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 2/12/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import UIKit

class TableViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var voltageLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
