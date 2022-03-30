//
//  WUFavoriteOptInTableCell.swift
//  Wussup
//
//  Created by MAC219 on 6/25/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUFavoriteOptInTableCell: PKSwipeTableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var viewContainer            : UIView!
    @IBOutlet private weak var imageViewIcon            : UIImageView!
    @IBOutlet private weak var labelTitle               : UILabel!
    //    @IBOutlet private weak var labelSubTitleAddress     : UILabel!
    @IBOutlet private weak var labelOpenNowStatus       : UILabel!
    @IBOutlet  weak var labelPromotionalAlerts          : UILabel!
    @IBOutlet  weak var switchToggle                    : UISwitch!
    @IBOutlet private weak var labelCloseTime           : UILabel!
    let btnDelete = UIButton(type: UIButtonType.custom)
    
    // MARK: - Variables
    var  favoriteVenue: WUVenueDetail!{
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRightViewInCell()
         self.initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.viewContainer.dropShadow(color: .lightGray, opacity: 1.0, offSet: CGSize(width: 0.0, height: 2.0), radius: 1.0, scale: true)
//        self.viewContainer.dropShadow()
    }
    
    private func setCellDetail(){
        self.imageViewIcon.sd_setShowActivityIndicatorView(true)
        self.imageViewIcon.sd_setIndicatorStyle(.white)
        self.imageViewIcon.sd_setImage(with: URL(string:self.favoriteVenue.VenueCoverPhoto.SquareImage.count > 0 ? self.favoriteVenue.VenueCoverPhoto.SquareImage : self.favoriteVenue.VenueCoverPhoto.RactangleImage ), placeholderImage:#imageLiteral(resourceName: "NullState_CoverPhoto"), options: [SDWebImageOptions.cacheMemoryOnly])
        self.labelTitle.text = self.favoriteVenue.VenueName.uppercased()
        self.switchToggle.isHidden = true
        self.switchToggle.isOn = self.favoriteVenue.UserFavoriteVenueNotificationSettings.IsSendPromotionalAlert.toBool()!
        
        if (self.favoriteVenue.VenueAtOpen == "" && self.favoriteVenue.VenueAtClose == "" ) {
            self.labelOpenNowStatus.textColor = .RedColor
            self.labelOpenNowStatus.text = Text.Label.text_Closed
            self.labelCloseTime.text = ""
        }else if (self.favoriteVenue.VenueAtOpen != "" && self.favoriteVenue.VenueAtClose != "" ) {
            self.labelOpenNowStatus.textColor = .OpenNowGreenColor
            self.labelOpenNowStatus.text = Text.Label.text_Open
            
            if self.favoriteVenue.VenueAtClose != ""{
                self.labelCloseTime.text =  Text.Label.text_Closes + "\(self.favoriteVenue.VenueAtClose)"
            }else {
                self.labelCloseTime.text = ""
            }
        }else {
            self.labelOpenNowStatus.textColor = .blackColor//.RedColor
            self.labelOpenNowStatus.text = Text.Label.text_Closed
            if self.favoriteVenue.VenueAtOpen != ""{
                self.labelCloseTime.text = Text.Label.text_Opens + "\(self.favoriteVenue.VenueAtOpen)"
            }else {
                self.labelCloseTime.text = ""
            }
        }
    }
    /*
     if self.favoriteVenue.VenueOpenStatus != ""{
     self.labelOpenNowStatus.textColor = .GreenColor
     self.labelOpenNowStatus.text = "OPEN NOW"
     }else{
     self.labelOpenNowStatus.text = ""
     }
     */
    private func addRightViewInCell() {
        
        let viewCall = UIView()
        viewCall.frame = CGRect(x: 0, y: 36,width: 106.0,height: 75.0)
        self.btnDelete.frame = CGRect(x: viewCall.frame.origin.x - 20 ,y: viewCall.frame.origin.y,width:viewCall.frame.width-5,height:viewCall.frame.height)
       
        btnDelete.setImage(UIImage(named: "Delete"), for: UIControlState())
        btnDelete.contentHorizontalAlignment = .center
        btnDelete.backgroundColor = .deleteRedButton
        btnDelete.layer.cornerRadius = 10.0
        btnDelete.layer.borderWidth = 0.5
        btnDelete.layer.borderColor = UIColor.black.cgColor
        btnDelete.addTarget(self, action: #selector(buttonDeleteAction), for: UIControlEvents.touchUpInside)
        viewCall.addSubview(btnDelete)
        super.addRightOptionsView(viewCall)
    }
    
    @objc func buttonDeleteAction(){
        if let delegate = self.delegate{
            delegate.buttonRemoveClicked(cell: self)
        }
    }
    
    @IBAction func switchToggleAction(_ sender: Any) {
        if let delegate = self.delegate{
            delegate.switchToggleClicked(cell: self)
        }
    }
}
