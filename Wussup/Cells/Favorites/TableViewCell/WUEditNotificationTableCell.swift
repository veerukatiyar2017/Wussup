//
//  WUEditNotificationTableCell.swift
//  Wussup
//
//  Created by MAC219 on 6/26/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEditNotificationTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var viewLabelTitle           : UIView!
    @IBOutlet private weak var viewLabelName            : UIView!
    @IBOutlet  weak var labelNotificationTitle          : UILabel!
    @IBOutlet  weak var labelName                       : UILabel!
    @IBOutlet  weak var switchToggle                    : UISwitch!
    
    // MARK: - Variables
    weak var delegate : WUUserCustomNotificationTableCellDelegate?
    var notifcationSwitchTag : NotificationButtonTag = .promotionalSwitchTag
    

    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialInterfaceSetUp()
        
    }
 
    private func initialInterfaceSetUp() {
        
        if #available(iOS 11.0, *){
            self.viewLabelTitle.layer.cornerRadius = 10
            self.viewLabelTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewLabelTitle.bounds,byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            self.viewLabelTitle.layer.mask = rectShape
        }
        if #available(iOS 11.0, *){
            self.viewLabelName.layer.cornerRadius = 10
            self.viewLabelName.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewLabelName.bounds,byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            self.viewLabelName.layer.mask = rectShape
        }
    }
    
    @IBAction func switchToggleAction(_ sender: UISwitch) {
         if let delegate = self.delegate{
            delegate.buttonToggleSwitchActions(buttonType: NotificationButtonTag(rawValue: sender.tag)!, cell: self)
        }
    }
}
