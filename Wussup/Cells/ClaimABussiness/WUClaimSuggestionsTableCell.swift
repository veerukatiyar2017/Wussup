//
//  WUClaimSuggestionsTableCell.swift
//  Wussup
//
//  Created by MAC219 on 8/27/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimSuggestionsTableCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var seperator: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelTitle.font = UIFont.ProximaNovaRegular(22.0.propotional)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
