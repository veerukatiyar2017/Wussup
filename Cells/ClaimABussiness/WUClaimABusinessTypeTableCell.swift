//
//  WUClaimABusinessTypeTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/30/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUClaimABusinessTypeTableCell: UITableViewCell {
    
     //MARK: - IBOutlets
    @IBOutlet private weak var labelTitle       : UILabel!
    @IBOutlet private weak var viewSeperator    : UIView!
    @IBOutlet private weak var buttonSelectType : UIButton!
    
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
        self.labelTitle.textColor = UIColor.LightGrayColor
        self.buttonSelectType.semanticContentAttribute = .forceRightToLeft
        self.buttonSelectType.backgroundColor = UIColor.blackColor
        self.buttonSelectType.layer.borderColor =  UIColor.btnForgotPwdGreenColor.cgColor
        self.buttonSelectType.titleLabel?.textColor = UIColor.btnForgotPwdGreenColor
        
    }
    
    private func setDetail(){
        self.labelTitle.text = self.claimABusinessData.placeHolder
    }
    
    //MARK: - Action Methods
    @IBAction func buttonSelectTypeAction(_ sender: Any) {
         Utill.printInTOConsole(printData:"buttonSelectTypeAction Clicked :::::::")
    }
}
