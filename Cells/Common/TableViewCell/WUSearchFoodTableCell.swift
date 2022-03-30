//
//  WUSearchFoodTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/19/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUSearchFoodTableCell: UITableViewCell {

    @IBOutlet weak var labelFoodCategory: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var viewSeperator: UIView!
    
    var foodCategory : WUCategory!{
        didSet{
            self.setCellDetail()
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initialInterfaceSetUp() {
        self.labelFoodCategory.textColor = UIColor.blackColor
        self.viewIcon.backgroundColor = UIColor.DarkGrayColor
    }
    
    private func setCellDetail()
    {
        self.labelFoodCategory.text = self.foodCategory.Name
        self.imageViewIcon.isHidden = true
        self.viewIcon.isHidden = true
        if self.foodCategory.ImageURL.count > 0
        {
            self.imageViewIcon.sd_setShowActivityIndicatorView(true)
            self.imageViewIcon.sd_setIndicatorStyle(.white)
            self.imageViewIcon.sd_setImage(with: URL(string: self.foodCategory.ImageURL), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .cacheMemoryOnly, completed : nil)
        }
        else {
            self.imageViewIcon.isHidden = true
            self.viewIcon.isHidden = true
        }
    }
    
    
}
