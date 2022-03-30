//
//  WUClaimBussinessViewController.swift
//  Wussup
//
//  Created by MAC219 on 7/30/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

enum ClaimABusinessCellType {
    case OnlyText
    case ZipTextWithStateButton
    case BusinessTypeSelectButton
}

@objc enum ClaimABusinessCellDataType : Int {
    case BusinessOwnerName = 0
    case BusinessType
    case BusinessName
    case BusinessAddress1
    case BusinessAddress2
    case City
    case State
    case ZipCode
    case PhoneNumber
    case BusinessEmail
    case BusinessWebsite
    
}

class  ClaimABusinessCellDataModel: NSObject {
    var placeHolder : String = ""
    var cellType : ClaimABusinessCellType = .OnlyText
    var cellDataType : ClaimABusinessCellDataType = .BusinessOwnerName
    var cellKey : String = ""
}

class WUClaimBussinessViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var tableviewClaimBusiness   : UITableView!
    @IBOutlet private weak var buttonBack               : UIButton!
    @IBOutlet private weak var buttonSubmit             : UIButton!
    
    // MARK: - Variables
    private var arrClaimABusiness   : [ClaimABusinessCellDataModel] = []
    private var dicClaimBusiness    : [String : String]             = [:]
    private var currenttextField : UITextField!
   
    // MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.buttonBack.isSelected = false
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .btnLightGrayColor ), for: .normal)
        self.tableviewClaimBusiness.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableviewClaimBusiness.frame.width, height: 20.0.propotional)
        self.tableviewClaimBusiness.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.tableviewClaimBusiness.frame.width, height: 83.0.propotional)
        self.reloadDataForClaimABusiness()
    }
    
    func reloadDataForClaimABusiness() {
        self.arrClaimABusiness.removeAll()        
        //Set Owner Name Data
        let bussiness_OwnerName_Model               = ClaimABusinessCellDataModel.init()
        bussiness_OwnerName_Model.cellType          = .OnlyText
        bussiness_OwnerName_Model.cellDataType      = .BusinessOwnerName
        bussiness_OwnerName_Model.placeHolder       = Text.TextField.text_CAB_OwnerName
        bussiness_OwnerName_Model.cellKey           = Text.DictKeys.ownerName
        self.arrClaimABusiness.append(bussiness_OwnerName_Model)
        
        //Set Bussiness Type Data
        let bussinessType_Model                     = ClaimABusinessCellDataModel.init()
        bussinessType_Model.cellType                = .BusinessTypeSelectButton
        bussinessType_Model.cellDataType            = .BusinessType
        bussinessType_Model.placeHolder             = Text.TextField.text_CAB_BusinessType
        bussinessType_Model.cellKey                 = Text.DictKeys.businessType
        self.arrClaimABusiness.append(bussinessType_Model)
        
        //Set Bussiness Name Data
        let bussinessName_Model                     = ClaimABusinessCellDataModel.init()
        bussinessName_Model.cellType                = .OnlyText
        bussinessName_Model.cellDataType            = .BusinessName
        bussinessName_Model.placeHolder             = Text.TextField.text_CAB_BusinessName
        bussinessName_Model.cellKey                 = Text.DictKeys.businessName
        self.arrClaimABusiness.append(bussinessName_Model)
        
        //Set Bussiness AddressLine 1 Data
        let bussiness_Address1_Model                = ClaimABusinessCellDataModel.init()
        bussiness_Address1_Model.cellType           = .OnlyText
        bussiness_Address1_Model.cellDataType       = .BusinessAddress1
        bussiness_Address1_Model.placeHolder        = Text.TextField.text_CAB_AddressLine1
        bussiness_Address1_Model.cellKey            = Text.DictKeys.addressLine1
        self.arrClaimABusiness.append(bussiness_Address1_Model)
        
        //Set Bussiness AddressLine 2 Data
        let bussiness_Address2_Model                = ClaimABusinessCellDataModel.init()
        bussiness_Address2_Model.cellType           = .OnlyText
        bussiness_Address2_Model.cellDataType       = .BusinessAddress2
        bussiness_Address2_Model.placeHolder        = Text.TextField.text_CAB_AddressLine2
        bussiness_Address2_Model.cellKey            = Text.DictKeys.addressLine2
        self.arrClaimABusiness.append(bussiness_Address2_Model)
        
        //Set City Data
        let bussiness_City_Model                    = ClaimABusinessCellDataModel.init()
        bussiness_City_Model.cellType               = .OnlyText
        bussiness_City_Model.cellDataType           = .City
        bussiness_City_Model.placeHolder            = Text.TextField.text_CAB_City
        bussiness_City_Model.cellKey                = Text.DictKeys.city
        self.arrClaimABusiness.append(bussiness_City_Model)
        
        //Set State Data
        let bussiness_State_Model                   = ClaimABusinessCellDataModel.init()
        bussiness_State_Model.cellType              = .ZipTextWithStateButton
        bussiness_State_Model.cellDataType          = .State
        bussiness_State_Model.placeHolder           = Text.TextField.text_CAB_State
        bussiness_State_Model.cellKey                = Text.DictKeys.state
        self.arrClaimABusiness.append(bussiness_State_Model)
        
        //Set ZipCode Data
        let bussiness_ZipCode_Model                 = ClaimABusinessCellDataModel.init()
        bussiness_ZipCode_Model.cellType            = .ZipTextWithStateButton
        bussiness_ZipCode_Model.cellDataType        = .ZipCode
        bussiness_ZipCode_Model.placeHolder         = Text.TextField.text_CAB_ZipCode
        bussiness_ZipCode_Model.cellKey             = Text.DictKeys.zipCode
        self.arrClaimABusiness.append(bussiness_ZipCode_Model)
        
        //Set PhoneNumber Data
        let bussiness_PhoneNumber_Model             = ClaimABusinessCellDataModel.init()
        bussiness_PhoneNumber_Model.cellType        = .OnlyText
        bussiness_PhoneNumber_Model.cellDataType    = .PhoneNumber
        bussiness_PhoneNumber_Model.placeHolder     = Text.TextField.text_CAB_PhoneNumber
        bussiness_PhoneNumber_Model.cellKey         = Text.DictKeys.phoneNumber
        self.arrClaimABusiness.append(bussiness_PhoneNumber_Model)
        
        //Set Email Data
        let bussiness_Email_Model                   = ClaimABusinessCellDataModel.init()
        bussiness_Email_Model.cellType              = .OnlyText
        bussiness_Email_Model.cellDataType          = .BusinessEmail
        bussiness_Email_Model.placeHolder           = Text.TextField.text_CAB_Email
        bussiness_Email_Model.cellKey               = Text.DictKeys.businessEmail
        self.arrClaimABusiness.append(bussiness_Email_Model)
        
        //Set Website Data
        let bussiness_Website_Model                 = ClaimABusinessCellDataModel.init()
        bussiness_Website_Model.cellType            = .OnlyText
        bussiness_Website_Model.cellDataType        = .BusinessWebsite
        bussiness_Website_Model.placeHolder         = Text.TextField.text_CAB_Website
        bussiness_Website_Model.cellKey             = Text.DictKeys.website
        self.arrClaimABusiness.append(bussiness_Website_Model)
        
        self.tableviewClaimBusiness.reloadData()
    }
    
    // MARK: - Action Methods
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.buttonBack.isSelected = true
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .GreenColor ), for: .normal)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSubmitAction(_ sender: Any) {
        
        //        let cell =  UITableView.cell
        
        
        
        if self.dicClaimBusiness[Text.DictKeys.addressLine1]?.isEmpty == true{
//            let cell = self.tableviewClaimBusiness.cellForRow(at: <#T##IndexPath#>)
            Utill.setPlaceHolderTextAndColor(textfield: self.currenttextField, placeHolderString: Text.Message.msg_CAB_AddressLine1, placeHolderTextColor: .CABOrangeColor)
        }else if self.dicClaimBusiness[Text.DictKeys.city]?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.currenttextField, placeHolderString: Text.Message.msg_CAB_City, placeHolderTextColor: .CABOrangeColor)
        }else if self.dicClaimBusiness[Text.DictKeys.zipCode]?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.currenttextField, placeHolderString: Text.Message.msg_CAB_StateZip, placeHolderTextColor: .CABOrangeColor)
        }else if self.dicClaimBusiness[Text.DictKeys.phoneNumber]?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.currenttextField, placeHolderString: Text.Message.msg_CAB_PhoneNumber, placeHolderTextColor: .CABOrangeColor)
        }else if self.dicClaimBusiness[Text.DictKeys.businessEmail]?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.currenttextField, placeHolderString: Text.Message.msg_CAB_Email, placeHolderTextColor: .CABOrangeColor)
        }else{
            let accpetView = WUClaimABussinessAcceptView.instanceFromNib()
            accpetView.showInView(superView: self.view)
        }
    }
}
//MARK: - TableView
extension WUClaimBussinessViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrClaimABusiness.count-1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let businessDataModel = self.arrClaimABusiness[indexPath.row]
        if indexPath.row == ClaimABusinessCellDataType.BusinessType.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUClaimABusinessTypeTableCell())) as! WUClaimABusinessTypeTableCell
            cell.claimABusinessData = businessDataModel
            return cell
        }else if indexPath.row == ClaimABusinessCellDataType.State.rawValue  {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUClaimABusinessStateZIPTableCell())) as! WUClaimABusinessStateZIPTableCell
            if businessDataModel.cellDataType == .State {
                cell.claimABusinessData = businessDataModel
            }
            if self.arrClaimABusiness[indexPath.row + 1].cellDataType == .ZipCode{
                cell.textFieldTitle.delegate = self
                cell.claimABusinessData = self.arrClaimABusiness[indexPath.row + 1]
            }
            return cell
        }else if indexPath.row >= ClaimABusinessCellDataType.ZipCode.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUClaimABusinessTextTableCell())) as! WUClaimABusinessTextTableCell
            cell.textFieldTitle.delegate = self
            cell.claimABusinessData = self.arrClaimABusiness[indexPath.row+1]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUClaimABusinessTextTableCell())) as! WUClaimABusinessTextTableCell
            cell.textFieldTitle.delegate = self
            cell.claimABusinessData = businessDataModel
            return cell
        }
    }
}
//MARK: - TextField Delegate
extension WUClaimBussinessViewController : UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let cellModel = self.arrClaimABusiness[(textField.tag)]
        
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            
            if  cellModel.cellDataType == .BusinessOwnerName {
                 Utill.printInTOConsole(printData:"BusinessOwnerName")
                self.dicClaimBusiness[Text.DictKeys.ownerName] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_OwnerName, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .BusinessName {
                 Utill.printInTOConsole(printData:"BusinessName")
                self.dicClaimBusiness[Text.DictKeys.businessName] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_BusinessName, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .BusinessAddress1 {
                 Utill.printInTOConsole(printData:"BusinessAddress1")
                self.dicClaimBusiness[Text.DictKeys.addressLine1] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_AddressLine1, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .BusinessAddress2 {
                 Utill.printInTOConsole(printData:"BusinessAddress2")
                self.dicClaimBusiness[Text.DictKeys.addressLine2] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_AddressLine2, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .City {
                 Utill.printInTOConsole(printData:"City ::::: ")
                self.dicClaimBusiness[Text.DictKeys.city] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_City, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .ZipCode {
                 Utill.printInTOConsole(printData:"ZipCode ::::: ")
                self.dicClaimBusiness[Text.DictKeys.zipCode] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_ZipCode, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .PhoneNumber {
                 Utill.printInTOConsole(printData:"PhoneNumber ::::: ")
                self.dicClaimBusiness[Text.DictKeys.phoneNumber] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_PhoneNumber, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .PhoneNumber {
                 Utill.printInTOConsole(printData:"PhoneNumber ::::: ")
                self.dicClaimBusiness[Text.DictKeys.phoneNumber] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_PhoneNumber, placeHolderTextColor: .LightGrayColor)
                }
            }else if  cellModel.cellDataType == .BusinessEmail {
                 Utill.printInTOConsole(printData:"BusinessEmail ::::: ")
                self.dicClaimBusiness[Text.DictKeys.businessEmail] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_Email, placeHolderTextColor: .LightGrayColor)
                }
            }else  {
                 Utill.printInTOConsole(printData:"WebSite ::::: ")
                self.dicClaimBusiness[Text.DictKeys.website] = textField.text
                if finalText == ""{
                    textField.resignFirstResponder()
                    textField.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: textField, placeHolderString: Text.TextField.text_CAB_Website, placeHolderTextColor: .LightGrayColor)
                }
            }
        }
        return true
    }
}
