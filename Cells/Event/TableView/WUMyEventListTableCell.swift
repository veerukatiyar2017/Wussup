//
//  WUMyEventListTableCell.swift
//  Wussup
//
//  Created by MAC219 on 6/4/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

// MARK: - Delegate
protocol WUMyEventListTableCellDelegate : class {
    func eventCrossDelete(cell : WUMyEventListTableCell , withCalenderEvent  calenderEventM: WUMyEventList)
}

extension WUMyEventListTableCellDelegate{
    func eventCrossDelete(cell : WUMyEventListTableCell , withCalenderEvent  calenderEventM: WUMyEventList){
        
    }
}

class WUMyEventListTableCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var buttonDeleteEvent    : UIButton!
    @IBOutlet private weak var labelEventTitle      : UILabel!
    
    //MARK: - Variable
    var delegate : WUMyEventListTableCellDelegate?
    var myEventList : WUMyEventList!{
        didSet{
            self.setEventList()
        }
    }
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setEventList(){
        self.buttonDeleteEvent.isSelected = false
        self.labelEventTitle.text = self.myEventList.Name
    }
    
    //MARK: - Action Methods
    @IBAction func buttonDeleteEventAction(_ sender: UIButton) {
        self.buttonDeleteEvent.isSelected = true
        if let delegate = self.delegate{
            delegate.eventCrossDelete(cell: self, withCalenderEvent: self.myEventList)
        }
    }
    
}
