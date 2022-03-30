//
//  WUInnerImageTableCell.swift
//  Wussup
//
//  Created by MAC219 on 5/31/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUInnerImageTableCell: UITableViewCell {
    
    @IBOutlet weak var imageViewCell                : UIImageView!
    @IBOutlet  weak var buttonClose                 : UIButton!
    @IBOutlet private weak var buttonShare          : UIButton!
    @IBOutlet private weak var buttonAddToCalendar  : UIButton!
    @IBOutlet  weak var viewButtonHeight            : NSLayoutConstraint!

    weak var delegate                               : WUVenueProfileTableCellDelegate?
    var isExpanded : Bool = false
    var isFromAdmission : Bool = false
    var venueProfileListInnerImage : Any!{
        didSet{
            self.setCellDetail()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
        self.buttonClose.semanticContentAttribute = .forceRightToLeft
        
    }
    
    private func setCellDetail() {
        self.buttonAddToCalendar.isHidden = false
//        self.isFromAdmission = false
        if isExpanded == true{
            self.viewButtonHeight.constant = 50.0
        }else{
            self.viewButtonHeight.constant = 0.0
        }
        self.imageViewCell.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imageViewCell.sd_setShowActivityIndicatorView(true)
//        self.imageViewCell.sd_setIndicatorStyle(.white)
        if self.venueProfileListInnerImage is WUVenueHours {
            self.imageViewCell.sd_setImage(with: URL(string:(self.venueProfileListInnerImage as! WUVenueHours).ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        }else if self.venueProfileListInnerImage is WUVenueMenus {
            self.buttonAddToCalendar.isHidden = true
            self.imageViewCell.sd_setImage(with: URL(string:(self.venueProfileListInnerImage as! WUVenueMenus).MenuImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        }else if self.venueProfileListInnerImage is WUVenueLiveMusic {
            self.imageViewCell.sd_setImage(with: URL(string:(self.venueProfileListInnerImage as! WUVenueLiveMusic).ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        }else if  self.venueProfileListInnerImage is WUEvent
        {
            self.imageViewCell.sd_setImage(with: URL(string:(self.venueProfileListInnerImage as! WUEvent).ConverPhotoURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        }
        else{
//            if self.venueProfileListInnerImage is WUMoreEvent {
            if self.isFromAdmission == true {
                self.buttonAddToCalendar.isHidden = true
            }
            self.imageViewCell.sd_setImage(with: URL(string:(self.venueProfileListInnerImage as! WUMoreEvent).ImageURL), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: .refreshCached)
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueShareButton(cell: self, didSelectShareButton: sender)
        }
    }
    
    @IBAction func buttonAddToCalendarAction(_ sender: UIButton) {
        if self.venueProfileListInnerImage is WUVenueMenus{
            
        }else{
            if let delegate = self.delegate {
                delegate.venueCalendarButton(cell: self, didSelectCalendarButton: sender)
            }
        }
    }
    
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
    }
    
}

