//
//  WUClaimABusinessStateZIPTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/30/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimABusinessStateZIPTableCell: UITableViewCell {
    
    @IBOutlet  weak var labelTitle           : UILabel!
    @IBOutlet  weak var textFieldTitle       : UITextField!
    @IBOutlet private weak var viewSeperator        : UIView!
    @IBOutlet private weak var buttonSelectState    : UIButton!
    
    var claimABusinessData : ClaimABusinessCellDataModel!{
        didSet{
            self.setDetail()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initialInterfaceSetUp() {
        self.backgroundColor = UIColor.DarkGrayColor
        self.viewSeperator.backgroundColor = UIColor.cliamBusinessSepratorColor
        Utill.setPlaceHolderTextAndColor(textfield: self.textFieldTitle, placeHolderString: Text.TextField.text_CAB_AddressLine1, placeHolderTextColor: UIColor.LightGrayColor)
        self.textFieldTitle.textColor = UIColor.SearchBarYellowColor
        self.labelTitle.textColor = UIColor.LightGrayColor
    }
    
    private func setDetail(){
        if self.claimABusinessData.cellDataType == .State{
            self.labelTitle.text = self.claimABusinessData.placeHolder
        }else{
            self.textFieldTitle.tag = self.claimABusinessData.cellDataType.rawValue
            self.textFieldTitle.keyboardType = .default
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldTitle, placeHolderString: self.claimABusinessData.placeHolder, placeHolderTextColor: UIColor.LightGrayColor)
        }        
    }
    
    @IBAction func buttonSelectStateAction(_ sender: Any) {
         Utill.printInTOConsole(printData:"buttonSelectStateAction Clicked :::::::")
    }
}
