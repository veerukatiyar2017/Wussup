//
//  WUHomeSearchFilterCell.swift
//  Wussup
//
//  Created by MAC219 on 5/3/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUHomeSearchFilterCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet var labelTitle : UILabel!
    @IBOutlet var buttonFilterCheck: UIButton!
    @IBOutlet var labelSeparator : UILabel!
    // MARK: - Variables
    var setFilterData : WUSearchFilters! {
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Initial Interface SetUp
    
    private func setCellDetail() {
        self.labelTitle.text = self.setFilterData.filterName
    }
    //MARK: - Action Methods
   
    @IBAction func buttonFilterCheckAction(_ sender: Any) {
    
    }
    
}
