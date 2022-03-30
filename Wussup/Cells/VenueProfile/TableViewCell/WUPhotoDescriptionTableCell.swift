//
//  WUPhotoDescriptionTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/19/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUPhotoDescriptionTableCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelDescription.font = UIFont.ProximaNovaRegular(16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
