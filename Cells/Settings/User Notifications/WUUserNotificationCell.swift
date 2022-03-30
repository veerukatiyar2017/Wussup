//
//  WUUserNotificationCell.swift
//  Wussup
//
//  Created by Alexandr on 21.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class WUUserNotificationCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var isNotificationUnreadView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with notificationData : WUUserNotificationSettings){
        
        self.categoryImage.sd_setImage(with:URL(string: notificationData.CategoryImage), placeholderImage: UIImage(named:"placeholder.png" ))
        self.notificationImage.sd_setImage(with:URL(string: notificationData.ImageURL), placeholderImage: UIImage(named:"placeholder.png" ))
        self.isNotificationUnreadView.isHidden = notificationData.HasRead
        
        if notificationData.Type.count != 0{
            self.titleLabel.text = ("\(notificationData.Type) \(notificationData.NotificationType)")
        }else{
            self.titleLabel.text = ("\(notificationData.NotificationType)")
        }
        
        self.descriptionLabel.text = ("\(notificationData.VenueName) in \(notificationData.City), \(notificationData.State)")
        self.notificationImage.superview?.dropShadow()
    }

}
