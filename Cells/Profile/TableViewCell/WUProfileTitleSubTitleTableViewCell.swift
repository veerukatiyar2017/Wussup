//
//  WUTitleSubTitleTableViewCell.swift
//  Wussup
//
//  Created by MAC26 on 02/07/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUProfileTitleSubTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle                               : UILabel!
    @IBOutlet weak var textFldSubtitle                          : UITextField!
    @IBOutlet weak var viewSeperatorNormalTitleSubTitleCell     : UIView!
    @IBOutlet weak var viewSeperatorActiveBottom                : UIView!
    @IBOutlet weak var viewSeperatorActiveTop                   : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
