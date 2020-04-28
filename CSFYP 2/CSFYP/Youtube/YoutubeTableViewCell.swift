//
//  YoutubeTableViewCell.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 28/12/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {
    @IBOutlet weak var YTimage: UIImageView!
    
    @IBOutlet weak var YTtitile: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
