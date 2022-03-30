//
//  WUNoEventTableCell.swift
//  Wussup
//
//  Created by MAC219 on 6/4/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUNoEventTableCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet private weak var labelTitle                       : UILabel!
    @IBOutlet private weak var constraintViewContainerBottom    : NSLayoutConstraint!
    @IBOutlet private weak var viewContainer                    : UIView!
    @IBOutlet private weak var viewSaperator                    : UIView!
   
    //MARK: - Variables
    var shadow : Bool = false{
        didSet{
            self.setDetail()
        }
    }
    
    //MARK: - IBOutlet
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDetail()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    
    private func setDetail(){
        if self.shadow == true {
            self.viewContainer.dropShadow()
            self.constraintViewContainerBottom.constant = 10
            self.viewSaperator.isHidden = true
            self.labelTitle.textAlignment = .center

        }else{
            self.viewContainer.clipsToBounds = true
            self.constraintViewContainerBottom.constant = 0
            self.viewSaperator.isHidden = false
            self.labelTitle.textAlignment = .left
        }
    }
}
