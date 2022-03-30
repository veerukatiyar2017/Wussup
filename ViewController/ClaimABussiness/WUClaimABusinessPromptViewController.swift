//
//  WUClaimABusinessPromptViewController.swift
//  Wussup
//
//  Created by MAC219 on 8/24/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimABusinessPromptViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var buttonBack               : UIButton!
    @IBOutlet private weak var labelBusinessName        : UILabel!
    @IBOutlet private weak var labelAddClaimBusiness    : UILabel!
    @IBOutlet private weak var labelClickHere           : UILabel!

    // MARK: - Variables
     var tapGesture      = UITapGestureRecognizer()
    var venue : Any!
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialData()
        self.configureLabels()
    }

    // MARK: - Initial Setup
    private func initialData() {
        
        if self.venue is WUVenueLocalPromotions{
            self.labelBusinessName.text = (self.venue as! WUVenueLocalPromotions).VenueName
        }else if self.venue is WUVenueDetail{
            self.labelBusinessName.text = (self.venue as! WUVenueDetail).VenueName
        }else if self.venue is WUVenue{
           self.labelBusinessName.text = (self.venue as! WUVenue).VenueName
        }else if self.venue is WUHomeBannerList{
            self.labelBusinessName.text = (self.venue as! WUHomeBannerList).Title
        }
    }
    
    private func configureLabels()
    {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelAddClaimABusinessAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        
        self.labelAddClaimBusiness.isUserInteractionEnabled = true
        self.labelAddClaimBusiness.addGestureRecognizer(self.tapGesture)
        
        let addClaimBusiness = NSMutableAttributedString(string:"Begin Promoting\nThis Business",
                                                         attributes:[.font: UIFont.ProximaNovaBold(20.0.propotional) as Any,
                                                                     .foregroundColor: UIColor.btnForgotPwdGreenColor,
                                                                     .underlineStyle: 1])
        
        self.labelAddClaimBusiness.attributedText = addClaimBusiness
        
        
        let clickHere = NSMutableAttributedString(string:"Click here to",
                                                  attributes:[.font: UIFont.ProximaNovaMedium(17.0.propotional) as Any,
                                                              .foregroundColor: UIColor.btnForgotPwdGreenColor,
                                                              .underlineStyle: 1])
        
        self.labelClickHere.attributedText = clickHere
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.buttonBack.isSelected = true
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .GreenColor ), for: .selected)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func labelAddClaimABusinessAction(_ sender : UITapGestureRecognizer) {
        if let vc = UIStoryboard.home.get(WUClaimABusinessViewController.self){
            vc.claimVenue = self.venue 
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
