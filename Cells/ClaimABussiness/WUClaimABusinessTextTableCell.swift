//
//  WUClaimABusinessTextTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/30/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimABusinessTextTableCell: UITableViewCell {

     //MARK: - IBOutlets
    @IBOutlet weak var textFieldTitle           : UITextField!
    @IBOutlet private weak var viewSeperator    : UIView!
    
    // MARK: - Variables
    var claimABusinessData : ClaimABusinessCellDataModel!{
        didSet{
            self.setDetail()
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
        self.backgroundColor = UIColor.DarkGrayColor
        self.viewSeperator.backgroundColor = UIColor.cliamBusinessSepratorColor
          Utill.setPlaceHolderTextAndColor(textfield: self.textFieldTitle, placeHolderString: Text.TextField.text_CAB_OwnerName, placeHolderTextColor: UIColor.LightGrayColor)
        self.textFieldTitle.textColor = UIColor.SearchBarYellowColor
    }
    
    private func setDetail(){
         Utill.setPlaceHolderTextAndColor(textfield: self.textFieldTitle, placeHolderString: self.claimABusinessData.placeHolder, placeHolderTextColor: UIColor.LightGrayColor)
        self.textFieldTitle.tag = self.claimABusinessData.cellDataType.rawValue
        if self.claimABusinessData.cellDataType == .PhoneNumber{
            self.textFieldTitle.keyboardType = .numberPad
        }else if self.claimABusinessData.cellDataType == .BusinessEmail {
            self.textFieldTitle.keyboardType = .emailAddress
        }else if self.claimABusinessData.cellDataType == .BusinessWebsite {
            self.textFieldTitle.keyboardType = .URL
        }else{
            self.textFieldTitle.keyboardType = .default
        }
    
    }
}
