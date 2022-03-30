//
//  WUSearchFilterCollectionCell.swift
//  Wussup
//
//  Created by MAC26 on 27/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUSearchFilterCollectionCell: UICollectionViewCell {
    
    // MARK: -IBOutlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewSeprator: UIView!
    
    // MARK: - Variables
    var setFilterData : WUSearchFilters! {
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Initial Interface SetUp
    private func setCellDetail() {
        self.labelTitle.text = self.setFilterData.filterName
        self.labelTitle.textColor = .LightGrayColor
        if self.setFilterData.isSelected == true{
            self.labelTitle.textColor = .SearchBarYellowColor
        }
    }
    
}
