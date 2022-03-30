//
//  WUProfileFavoriteSwitchTableCell.swift
//  Wussup
//
//  Created by MAC219 on 9/7/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUProfileFavoriteSwitchTableCellDelegate : class {
    func profileFavoriteSwitchTableCell(cell : WUProfileFavoriteSwitchTableCell, valueChange switchToggle : UISwitch)
}
extension WUProfileLableButtonTableCellDelegate{
    func profileFavoriteSwitchTableCell(cell : WUProfileFavoriteSwitchTableCell, valueChange switchToggle : UISwitch){
    }
}

class WUProfileFavoriteSwitchTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelTitle           : UILabel!
    @IBOutlet weak var switchNotification   : UISwitch!
    
    // MARK: - Variables
    weak var delegate : WUProfileFavoriteSwitchTableCellDelegate?
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Action Methods
    @IBAction func switchNotificationAction(_ sender: UISwitch) {
        if let delegate = self.delegate{
            delegate.profileFavoriteSwitchTableCell(cell: self, valueChange: sender)
        }
    }
}
