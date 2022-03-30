//
//  WUEditDoneTableCell.swift
//  Wussup
//
//  Created by MAC26 on 02/07/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUProfileEditDoneTableCellDelegate : class {
    func profileEditDoneTableCell(cell : WUProfileEditDoneTableCell, didSelectDoneButton button : UIButton)
    func profileEditDoneTableCell(cell : WUProfileEditDoneTableCell, didSelectEditButton button : UIButton)
}
extension WUProfileEditDoneTableCellDelegate{
    func profileEditDoneTableCell(cell : WUProfileEditDoneTableCell, didSelectDoneButton button : UIButton){
        
    }
    func profileEditDoneTableCell(cell : WUProfileEditDoneTableCell, didSelectEditButton button : UIButton){
        
    }
}


class WUProfileEditDoneTableCell: UITableViewCell {

    
    @IBOutlet weak var buttonEdit                           : UIButton!
    @IBOutlet weak var buttonDone                           : UIButton!
    @IBOutlet weak var viewSeperatorNormalEditDoneCell      : UIView!
    
    weak var delegate : WUProfileEditDoneTableCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
    @IBAction func buttonDoneAction(_ sender: UIButton) {
        if let del = self.delegate {
            del.profileEditDoneTableCell(cell: self, didSelectDoneButton: sender)
        }
    }
    @IBAction func buttonEditAction(_ sender: UIButton) {
        if let del = self.delegate{
            del.profileEditDoneTableCell(cell: self, didSelectEditButton: sender)
        }
    }
}
