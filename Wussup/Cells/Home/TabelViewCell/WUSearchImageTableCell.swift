//
//  WUSearchImageTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/3/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUSearchImageTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var labelCategoryTitle       : UILabel!
    @IBOutlet weak var imageViewCategoryIcon    : UIImageView!
    
    // MARK: - Variables
    
    var searchText : String!
    var category : WUCategory!{
        didSet{
            self.setCellDetail()
        }
    }
 
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    private func setCellDetail(){
        self.labelCategoryTitle.text = category.WussupName
        self.imageViewCategoryIcon.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewCategoryIcon.sd_setShowActivityIndicatorView(true)
//        self.imageViewCategoryIcon.sd_setIndicatorStyle(.white)
        self.imageViewCategoryIcon.sd_setImage(with: URL(string: category.UnSelectedImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
    }
 
}
