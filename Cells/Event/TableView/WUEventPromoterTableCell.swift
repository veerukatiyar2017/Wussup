//
//  WUEventPromoterTableViewCell.swift
//  Wussup
//
//  Created by MAC219 on 6/4/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage

class WUEventPromoterTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet  weak var imageViewPromoter        : UIImageView!
    @IBOutlet private weak var viewDescription          : UIView!
    @IBOutlet private weak var labelTitle               : UILabel!
    @IBOutlet private weak var labelDescription         : UILabel!
    @IBOutlet private weak var buttonShare              : UIButton!
    @IBOutlet private weak var buttonAddToCalendar      : UIButton!
    @IBOutlet weak var buttonClose                      : UIButton!
    @IBOutlet  private weak var viewButtonHeight        : NSLayoutConstraint!
    @IBOutlet private weak var viewSeparatorHeight      : NSLayoutConstraint!
    @IBOutlet private weak var viewDescriptionHeight    : NSLayoutConstraint!
    @IBOutlet private weak var cnstlabelTitleTop        : NSLayoutConstraint!
    @IBOutlet private weak var cnstlabelTitleBottom     : NSLayoutConstraint!
    @IBOutlet private weak var cnstlabelDescriptionBottom    : NSLayoutConstraint!
    @IBOutlet private weak var viewButton               : UIView!
    
    // MARK: - Variables
    weak var delegate      : WUVenueProfileTableCellDelegate?
    var isExpanded         : Bool = false
    
    var eventPromotor : WUEventPromotor!{
        didSet{
            self.setCellDetail()
        }
    }
    
    //MARK: - Load Methods
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
    
    //MARK: - setCellDetail
    private func setCellDetail() {
         self.mangeConstraints(isExpanded: false)
        if self.isExpanded == true{
            self.mangeConstraints(isExpanded: true)
        }
        self.labelTitle.text! = self.eventPromotor.Name
        self.labelDescription.text! = self.eventPromotor.Description
//         self.mangeConstraints(isExpanded: true)
        self.imageViewPromoter.sd_setShowActivityIndicatorView(true)
        self.imageViewPromoter.sd_setIndicatorStyle(.white)
        
        self.imageViewPromoter.sd_setImage(with: URL(string:self.eventPromotor.ImageURL), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [SDWebImageOptions.cacheMemoryOnly]) { (image, error, cacheType, url) in
            if  (self.delegate != nil) &&  image != nil{
                self.delegate?.expandableImageTableCell(innerCell: self, didLoadImage: image!)
            }
        }
    }
    
    private func mangeConstraints(isExpanded : Bool){
        if isExpanded == true{
            self.viewButtonHeight.constant      = 50.0 
           
//            let descriptionTextHeight = Utill.findHeightForText(text: self.labelDescription.text!, havingWidth: self.labelDescription.frame.size.width, andFont: self.labelDescription.font)
            
//            let titleTextHeight = Utill.findHeightForText(text:  self.labelTitle.text!, havingWidth: self.labelTitle.frame.size.width, andFont: self.labelTitle.font)
            self.cnstlabelTitleTop.constant = 5.0
            self.cnstlabelTitleBottom.constant = 5.0
            self.cnstlabelDescriptionBottom.constant = 5.0
            self.viewSeparatorHeight.constant   = 1.0
//            self.viewDescriptionHeight.constant = titleTextHeight + descriptionTextHeight + 9
        }else{
            self.viewButtonHeight.constant      = 0.0
            self.viewSeparatorHeight.constant   = 0.0
            self.labelTitle.text = ""
            self.labelDescription.text = ""
            self.cnstlabelTitleTop.constant = 0.0
            self.cnstlabelTitleBottom.constant = 0.0
            self.cnstlabelDescriptionBottom.constant = 0.0
//            self.viewDescriptionHeight.constant = 0.0
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func buttonShareAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueShareButton(cell: self, didSelectShareButton: sender)
        }
    }
    
    @IBAction func buttonAddToCalendarAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueCalendarButton(cell: self, didSelectCalendarButton: sender)
        }
    }
    
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.venueCloseButton(cell: self, didSelectCloseButton: sender)
        }
        
    }
    
}

