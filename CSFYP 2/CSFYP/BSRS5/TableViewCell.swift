//
//  TableViewCell.swift
//  CSFYP
//
//  Created by Hong Yuk Yu on 13/11/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Result: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization cod
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
