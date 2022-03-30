//
//  WUProfileLableButtonTableCell.swift
//  Wussup
//
//  Created by MAC26 on 03/07/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUProfileLableButtonTableCellDelegate : class {
    func profileLableButtonTableCell(cell : WUProfileLableButtonTableCell, didSelectButton button : UIButton)
}
extension WUProfileLableButtonTableCellDelegate{
    func profileLableButtonTableCell(cell : WUProfileLableButtonTableCell, didSelectButton button : UIButton){
        
    }
}

class WUProfileLableButtonTableCell: UITableViewCell {

    @IBOutlet weak var buttonSelect                           : UIButton!
    @IBOutlet weak var labelTitle                             : UILabel!
    @IBOutlet weak var viewSeperatorNormalLableButtonCell     : UIView!
    
    weak var delegate : WUProfileLableButtonTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonSelectAction(_ sender: UIButton)
    {
        if let delegate = self.delegate {
            delegate.profileLableButtonTableCell(cell: self, didSelectButton: sender)
        }
    }
}
