//
//  WUTimeSheetTableCell.swift
//  Wussup
//
//  Created by MAC219 on 6/28/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUTimeSheetTableCellDelegate: class {
    func timeSheetTableCell(cell : WUTimeSheetTableCell, buttonCloseTimeSheet button : UIButton)
}

extension WUTimeSheetTableCellDelegate {
    
    func timeSheetTableCell(cell : WUTimeSheetTableCell, buttonCloseTimeSheet button : UIButton){
        
    }
}

class WUTimeSheetTableCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var labelWeekDayName             : UILabel!
    @IBOutlet weak var labelTime                    : UILabel!
    @IBOutlet weak var buttonCloseTimeSheet         : UIButton!
    weak var delegate                               : WUTimeSheetTableCellDelegate?
    
    //MARK: - Load Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelTime.font = UIFont.ProximaNovaRegular(15.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - Button Actions
    @IBAction func buttonCloseTimeSheetAction(_ sender: UIButton)
    {
        Utill.printInTOConsole(printData:"//////buttonCloseTimeSheetAction")
        
        if let delegate = self.delegate {
            delegate.timeSheetTableCell(cell: self, buttonCloseTimeSheet: sender)
        }
    }
}

