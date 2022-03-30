//
//  WUProfileImageLabelTableCell.swift
//  Wussup
//
//  Created by MAC26 on 03/07/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUProfileImageLabelTableCell: UITableViewCell {
    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
