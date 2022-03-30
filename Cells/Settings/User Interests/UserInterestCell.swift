//
//  UserInterestCell.swift
//  Wussup
//
//  Created by Alexandr on 19.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class UserInterestCell: UITableViewCell {

    @IBOutlet weak var interestImage: UIImageView!
    @IBOutlet weak var interestTitle: UILabel!
    @IBOutlet weak var interestSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(with category: WUCategory, user: User){
        
        self.interestTitle.text = category.Name.count > 0 ? category.Name : "Happy Hour Test"
        if user.CategoriesPreference.compactMap({$0.ID}).contains(category.ID){
            self.interestSwitch.isOn = true
            self.interestImage.sd_setImage(with:URL(string: category.SelectedImageURL), placeholderImage: UIImage(named:"placeholder.png" ))
        }else{
            self.interestSwitch.isOn = false
            self.interestImage.sd_setImage(with:URL(string: category.UnSelectedImageURL), placeholderImage: UIImage(named:"placeholder.png" ))
        }
        
    }

}
