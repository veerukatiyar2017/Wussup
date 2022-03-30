//
//  WUClaimABusinessViewController.swift
//  Wussup
//
//  Created by MAC219 on 8/1/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TPKeyboardAvoiding.TPKeyboardAvoidingTableView

class WUClaimABusinessViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var tableViewClaimABusiness          : TPKeyboardAvoidingTableView!
    @IBOutlet private weak var viewHeader                       : UIView!
    @IBOutlet private weak var labelTitleCABFree                : UILabel!
    @IBOutlet private weak var viewSeperatorYellow              : UIView!
    @IBOutlet private weak var labelActivityInclude             : UILabel!
    @IBOutlet private weak var labelBusinessImagePhoto          : UILabel!
    @IBOutlet private weak var labelBusinessLocation            : UILabel!
    @IBOutlet private weak var labelBusinessOperation           : UILabel!
    @IBOutlet private weak var labelBusinessPhoneNumber         : UILabel!
    @IBOutlet private weak var viewSeperator                    : UIView!
    @IBOutlet private weak var labelDescriptionNapa             : UILabel!
    @IBOutlet private weak var textFieldMobileNumber            : UITextField!
    @IBOutlet private weak var textFieldEmail                   : UITextField!
    @IBOutlet private weak var labelBothField                   : UILabel!
    @IBOutlet private weak var viewSeperator1                   : UIView!
    @IBOutlet private weak var buttonClaimABusiness             : UIButton!
    @IBOutlet private weak var buttonBack                       : UIButton!
    @IBOutlet private weak var viewClaimVenueDisplay            : UIView!
    @IBOutlet private weak var tableviewClaimVenuesSuggestion   : UITableView!
    @IBOutlet private weak var textFieldSearch                  : UITextField!
    @IBOutlet private weak var buttonSearchClose                : UIButton!
    @IBOutlet private weak var labelNoVenueInDataBase           : UILabel!
    @IBOutlet private weak var buttonOK                         : UIButton!
   
    //MARK: - Variable
    var dictTextField : [String : String] = [Text.DictKeys.venueName : "",Text.DictKeys.venueFourSquareID : "",Text.DictKeys.mobileNumber : "" , Text.DictKeys.emailAddress : ""]
    var arraySearchSuggestion   : [WUVenueSuggestion] = []
    var mobileNumber = ""
    var email = ""
    var venueName = ""
    var claimVenue : Any!
    var isVenueNameFromOtherView : Bool = false
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func setUpUIView() {
        self.tableViewClaimABusiness.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewClaimABusiness.frame.size.width, height: 459.0.propotionalHeight)
        
        self.textFieldSearch.delegate       = self
        self.textFieldMobileNumber.delegate = self
        self.textFieldEmail.delegate        = self
        
        self.buttonBack.isSelected = false
        self.buttonOK.isHidden = true
        
        self.tableViewClaimABusiness.backgroundColor    = UIColor.DarkGrayColor
        self.viewHeader.backgroundColor                 = UIColor.DarkGrayColor
        self.viewSeperatorYellow.backgroundColor        = UIColor.SearchBarYellowColor
        self.viewSeperator.backgroundColor              = UIColor.white
        self.viewSeperator1.backgroundColor             = UIColor.white
        self.labelActivityInclude.textColor             = UIColor.white
        self.labelActivityInclude.textColor             = UIColor.white
        self.labelBusinessImagePhoto.textColor          = UIColor.white
        self.labelBusinessLocation.textColor            = UIColor.white
        self.labelBusinessOperation.textColor           = UIColor.white
        self.labelBusinessPhoneNumber.textColor         = UIColor.white
        self.labelDescriptionNapa.textColor             = UIColor.white
        self.labelBothField.textColor                   = UIColor.btnForgotPwdGreenColor
        self.textFieldSearch.layer.borderColor          = UIColor.btnForgotPwdGreenColor.cgColor
        self.textFieldSearch.backgroundColor            = UIColor.blackColor
        self.textFieldMobileNumber.layer.borderColor    = UIColor.btnForgotPwdGreenColor.cgColor
        self.textFieldMobileNumber.backgroundColor      = UIColor.blackColor
        self.textFieldEmail.layer.borderColor           = UIColor.btnForgotPwdGreenColor.cgColor
        self.textFieldEmail.backgroundColor             = UIColor.blackColor
        self.viewClaimVenueDisplay.layer.borderColor    = UIColor.btnForgotPwdGreenColor.cgColor
        self.buttonClaimABusiness.backgroundColor       = UIColor.GreenColor
        self.buttonClaimABusiness.layer.borderColor     = UIColor.black.cgColor
        if self.claimVenue != nil
        {
            self.isVenueNameFromOtherView = true
            
            if self.claimVenue is WUVenueLocalPromotions{
                self.textFieldSearch.text = (self.claimVenue as! WUVenueLocalPromotions).VenueName
                self.dictTextField[Text.DictKeys.venueName] = self.textFieldSearch.text
                self.dictTextField[Text.DictKeys.venueFourSquareID] = (self.claimVenue as! WUVenueLocalPromotions).VenueFourSquareID
            }else if self.claimVenue is WUVenueDetail {
                self.textFieldSearch.text = (self.claimVenue as! WUVenueDetail).VenueName
                self.dictTextField[Text.DictKeys.venueName] = self.textFieldSearch.text
                self.dictTextField[Text.DictKeys.venueFourSquareID] = (self.claimVenue as! WUVenueDetail).FourSquareVenueID
            }else if self.claimVenue is WUVenue {
                self.textFieldSearch.text = (self.claimVenue as! WUVenue).VenueName
                self.dictTextField[Text.DictKeys.venueName] = self.textFieldSearch.text
                self.dictTextField[Text.DictKeys.venueFourSquareID] = (self.claimVenue as! WUVenue).FourSquareVenueID
            }else if self.claimVenue is WUHomeBannerList {
                self.textFieldSearch.text = (self.claimVenue as! WUHomeBannerList).Title
                self.dictTextField[Text.DictKeys.venueName] = self.textFieldSearch.text
                self.dictTextField[Text.DictKeys.venueFourSquareID] = (self.claimVenue as! WUHomeBannerList).VenueFourSquareID
            }
//            self.callWS_getSuggestionList(searchText: self.textFieldSearch.text!)
        }
        else {
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldSearch, placeHolderString: Text.TextField.text_CAB_Search, placeHolderTextColor: .SearchBarYellowColor)
        }
        
        Utill.setPlaceHolderTextAndColor(textfield: self.textFieldMobileNumber, placeHolderString: Text.TextField.text_CAB_MobileNumber, placeHolderTextColor: .SearchBarYellowColor)
        Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_CAB_EmailAddress, placeHolderTextColor: .SearchBarYellowColor)
        
        self.textFieldMobileNumber.textColor = .btnLightGrayColor
        self.textFieldEmail.textColor = .btnLightGrayColor
        self.textFieldSearch.font = UIFont.ProximaNovaMedium(20.0.propotional)
        self.textFieldMobileNumber.font = UIFont.ProximaNovaMedium(18.0.propotional)
        self.textFieldEmail.font = UIFont.ProximaNovaMedium(18.0.propotional)
        self.viewClaimVenueDisplay.isHidden = true
        self.manageSearchFieldBorder(isFull: true)
        self.buttonSearchClose.isHidden = true
        
        if #available(iOS 11.0, *){
            self.viewClaimVenueDisplay.layer.cornerRadius = 8
            self.viewClaimVenueDisplay.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewClaimVenueDisplay.bounds,byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
            self.viewClaimVenueDisplay.layer.mask = rectShape
        }
        
        self.buttonSearchClose.imageView?.contentMode = .scaleAspectFit
        self.buttonSearchClose.frame = CGRect(x: (self.textFieldSearch.frame.size.width - 30.0.propotional), y: 10.0.propotionalHeight, width: (self.buttonSearchClose.imageView?.image?.size.width)! + 5.0, height: 15.0)
        self.buttonSearchClose.addTarget(self, action: #selector(self.buttonSearchCloseAction(_:)), for: .touchUpInside)
        self.textFieldSearch.rightView = self.buttonSearchClose
        self.textFieldSearch.rightViewMode = .always
    }
    
    private func manageSearchFieldBorder(isFull : Bool){
        if isFull == true{
            if #available(iOS 11.0, *){
                self.textFieldSearch.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner ,.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }else{
                let rectShape = CAShapeLayer()
                rectShape.path = UIBezierPath(roundedRect: self.textFieldSearch.bounds,byRoundingCorners: [.topLeft , .topRight,.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
                self.textFieldSearch.layer.mask = rectShape
                IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
            }
        }else{
            if #available(iOS 11.0, *){
                self.textFieldSearch.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }else{
                let rectShape = CAShapeLayer()
                rectShape.path = UIBezierPath(roundedRect: self.textFieldSearch.bounds,byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 8, height: 8)).cgPath
                self.textFieldSearch.layer.mask = rectShape
            }
            IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        }
    }
    
    private func callWS_getSuggestionList(searchText : String){
        self.arraySearchSuggestion.removeAll()
        self.viewClaimVenueDisplay.isHidden = false
        self.buttonSearchClose.isHidden = false
        self.manageSearchFieldBorder(isFull: false)
        
        WEB_API.call_api_GetClaimSuggestions(user: Utill.getUserModel()!, strSearchText: searchText){ (response, status, message) in
            if status == true{
                let data = try! JSONSerialization.data(withJSONObject: response?["VenueClaimSuggestionList"].arrayObject ?? [:], options: [])
                self.arraySearchSuggestion = try! JSONDecoder().decode([WUVenueSuggestion].self, from: data)
                if self.arraySearchSuggestion.count > 0 {
                    self.tableviewClaimVenuesSuggestion.isHidden = false
                    self.labelNoVenueInDataBase.isHidden = true
                    self.buttonOK.isHidden = true
                   self.buttonClaimABusiness.isHidden = false
                    if self.isVenueNameFromOtherView == true && self.claimVenue != nil {
                        if self.claimVenue is WUVenueLocalPromotions{
                            let arrF = self.arraySearchSuggestion.filter({$0.VenueFourSquareID == (self.claimVenue as! WUVenueLocalPromotions).VenueFourSquareID})
                            if arrF.count > 0 {
                                self.dictTextField[Text.DictKeys.venueFourSquareID] = arrF[0].VenueFourSquareID
                            }
                        }else if self.claimVenue is WUVenueDetail {
                            let arrF = self.arraySearchSuggestion.filter({$0.VenueFourSquareID == (self.claimVenue as! WUVenueDetail).FourSquareVenueID})
                            if arrF.count > 0 {
                                self.dictTextField[Text.DictKeys.venueFourSquareID] = arrF[0].VenueFourSquareID
                            }
                        }else if self.claimVenue is WUVenue{
                            let arrF = self.arraySearchSuggestion.filter({$0.VenueFourSquareID == (self.claimVenue as! WUVenue).FourSquareVenueID})
                            if arrF.count > 0 {
                                self.dictTextField[Text.DictKeys.venueFourSquareID] = arrF[0].VenueFourSquareID
                            }
                        }else if self.claimVenue is WUHomeBannerList{
                            let arrF = self.arraySearchSuggestion.filter({$0.VenueFourSquareID == (self.claimVenue as! WUHomeBannerList).VenueFourSquareID})
                            if arrF.count > 0 {
                                self.dictTextField[Text.DictKeys.venueFourSquareID] = arrF[0].VenueFourSquareID
                            }
                        }
                    }
                }else {
                    self.tableviewClaimVenuesSuggestion.isHidden = true
                    self.labelNoVenueInDataBase.isHidden = false
                    self.buttonOK.isHidden = false
                    self.buttonClaimABusiness.isHidden = true
                }
            }else{
                self.tableviewClaimVenuesSuggestion.isHidden = true
                self.labelNoVenueInDataBase.isHidden = false
                self.buttonOK.isHidden = false
                self.buttonClaimABusiness.isHidden = true
            }
            self.tableviewClaimVenuesSuggestion.reloadData()
        }
    }

    // MARK: - Action Methods
    @IBAction func buttonClaimABusinessAction(_ sender: Any) {
        self.checkValidation()
        //(self.mobileNumber.count >= 10 && self.mobileNumber.count <= 15)
        if (self.mobileNumber.count) == 10  && (self.email.count) > 0 && (self.venueName.count) > 0 {
            if (self.mobileNumber.isNumeric == true)  && (self.email.isValidEmail == true) && ((self.venueName.count) > 0 ) {
//                self.callWS_VenueClaim()
                self.performSegue(withIdentifier: Text.Segue.ClaimBusinessVCToAcceptVC, sender: nil)
            }else {
               self.checkValidationAndDisplayMessage()
            }
        }else {
            self.checkValidationAndDisplayMessage()
        }
    }
 
    @IBAction func buttonOkAction(_ sender: Any) {
        self.viewClaimVenueDisplay.isHidden = true
        self.manageSearchFieldBorder(isFull: true)
        self.view.endEditing(true)
        self.buttonOK.isHidden = true
        self.buttonClaimABusiness.isHidden = false
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.buttonBack.isSelected = true
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .GreenColor ), for: .normal)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearchCloseAction(_ sender: UIButton) {
        self.buttonSearchClose.isHidden = true
        self.textFieldSearch.text = ""
        Utill.setPlaceHolderTextAndColor(textfield: self.textFieldSearch, placeHolderString: Text.TextField.text_CAB_Search, placeHolderTextColor: .SearchBarYellowColor)
        self.dictTextField[Text.DictKeys.venueName] = self.textFieldSearch.text
        self.dictTextField[Text.DictKeys.venueFourSquareID] = ""
        self.viewClaimVenueDisplay.isHidden = true
        self.manageSearchFieldBorder(isFull: true)
        self.buttonSearchClose.isHidden = true
//        self.view.endEditing(true)
        self.checkValidationForBothFieldRequiredUI()
    }
    
    //MARK: - Check Validation
    private func checkValidation(){
        self.textFieldSearch.resignFirstResponder()
        self.textFieldMobileNumber.resignFirstResponder()
        self.textFieldEmail.resignFirstResponder()
        
        if  self.dictTextField[Text.DictKeys.venueName]?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldSearch, placeHolderString: Text.TextField.text_CAB_Search, placeHolderTextColor: .SearchBarYellowColor)
            self.textFieldSearch.layer.borderColor    = UIColor.RedColor.cgColor
            self.textFieldSearch.becomeFirstResponder()
            self.checkValidationForBothFieldRequiredUI()
        }
        
        if self.dictTextField[Text.DictKeys.emailAddress]?.isEmpty == true{
            self.textFieldEmail.text = Text.Label.text_BlankSpace
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_CAB_EmailAddress, placeHolderTextColor: .SearchBarYellowColor)
            self.textFieldEmail.layer.borderColor           = UIColor.RedColor.cgColor
            self.textFieldEmail.becomeFirstResponder()
            self.checkValidationForBothFieldRequiredUI()
        }else  if !(( self.dictTextField[Text.DictKeys.emailAddress]?.isValidEmail)!) == true{
            self.textFieldEmail.layer.borderColor           = UIColor.RedColor.cgColor
            self.textFieldEmail.becomeFirstResponder()
            self.checkValidationForBothFieldRequiredUI()
        }
        
        if  self.dictTextField[Text.DictKeys.mobileNumber]?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldMobileNumber, placeHolderString: Text.TextField.text_CAB_MobileNumber, placeHolderTextColor: .SearchBarYellowColor)
            self.textFieldMobileNumber.layer.borderColor    = UIColor.RedColor.cgColor
            self.textFieldMobileNumber.becomeFirstResponder()
            self.checkValidationForBothFieldRequiredUI()
        }else  if (self.dictTextField[Text.DictKeys.mobileNumber]!.count) < 10 || (self.dictTextField[Text.DictKeys.mobileNumber]!.count) > 15 {
            self.textFieldMobileNumber.layer.borderColor    = UIColor.RedColor.cgColor
            self.textFieldMobileNumber.becomeFirstResponder()
            self.checkValidationForBothFieldRequiredUI()
        }
    }
  
    private func checkValidationForBothFieldRequiredUI() {
        self.mobileNumber = self.dictTextField[Text.DictKeys.mobileNumber]!
        self.email = self.dictTextField[Text.DictKeys.emailAddress]!
        self.venueName = self.dictTextField[Text.DictKeys.venueName]!
        //&& self.mobileNumber.count <= 15)
        if (self.mobileNumber.count) == 10   && (self.email.count) > 0 && (self.venueName.count) > 0 {
            if (self.mobileNumber.isNumeric == true)  && (self.email.isValidEmail == true) && ((self.venueName.count) > 0 ) {
                self.labelBothField.textColor = UIColor.GreenColor
            }else{
                self.labelBothField.textColor = UIColor.RedColor
            }
        }else{
            self.labelBothField.textColor = UIColor.RedColor
        }
    }
    
    private func checkValidationAndDisplayMessage() {
        
        self.textFieldSearch.resignFirstResponder()
        self.textFieldMobileNumber.resignFirstResponder()
        self.textFieldEmail.resignFirstResponder()
        
        if (self.mobileNumber.count) == 0  && (self.email.count) == 0 && (self.venueName.count) == 0 {
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_venueEmailPhone)
        }else if ((self.venueName.count) == 0) && (self.mobileNumber.isNumeric == false){
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message:Text.Label.text_validVenuePhoneNumber)
        }else if ((self.venueName.count) == 0) && (self.email.isValidEmail == false){
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_validVenueEmail)
        }else if (self.mobileNumber.isNumeric == false) && (self.email.isValidEmail == false){
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_validPhoneNumberEmail)
        }else if((self.venueName.count) == 0){
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_validVenue)
        }else if (self.mobileNumber.isNumeric == false){
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_validPhoneNumber)
        }else if(self.email.isValidEmail == false){
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_validEmail)
        } else if  (self.dictTextField[Text.DictKeys.mobileNumber]!.count) < 10  { //|| (self.dictTextField[Text.DictKeys.mobileNumber]!.count) > 15
            Utill.showAlertView(viewController: self, title: Text.Label.text_allFieldRequired, message: Text.Label.text_validPhoneNumberDigit)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.ClaimBusinessVCToAcceptVC {
            let acceptVC  = segue.destination as! WUClaimABusinessAcceptViewController
            if self.claimVenue != nil{
                acceptVC.claimVenue = self.claimVenue
            }
            acceptVC.dictTextField = self.dictTextField
        }
    }
}

//MARK: - TextField Delegate
extension WUClaimABusinessViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewClaimVenueDisplay.isHidden = true
        self.manageSearchFieldBorder(isFull: true)
        
        if textField == self.textFieldSearch {
            if ((textField.text?.count)! > 0) {
                self.callWS_getSuggestionList(searchText: self.textFieldSearch.text!)
                self.buttonSearchClose.isHidden = false
            }
        self.textFieldSearch.layer.borderColor = UIColor.btnForgotPwdGreenColor.cgColor
        }else if textField == self.textFieldMobileNumber {
            self.textFieldMobileNumber.layer.borderColor = UIColor.btnForgotPwdGreenColor.cgColor
        }else {
            self.textFieldEmail.layer.borderColor = UIColor.btnForgotPwdGreenColor.cgColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            
            if textField == self.textFieldSearch {
                self.isVenueNameFromOtherView = false
                self.dictTextField[Text.DictKeys.venueName] = finalText
                self.dictTextField[Text.DictKeys.venueFourSquareID] = ""
                if (finalText.count > 0) {
                    self.callWS_getSuggestionList(searchText: finalText)
                }else {
//                    self.textFieldSearch.resignFirstResponder()
                    self.textFieldSearch.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldSearch, placeHolderString: Text.TextField.text_CAB_Search, placeHolderTextColor: .SearchBarYellowColor)
                    self.tableviewClaimVenuesSuggestion.isHidden = true
                    self.labelNoVenueInDataBase.isHidden = false
                    self.buttonOK.isHidden = false
                    self.buttonClaimABusiness.isHidden = true
                    self.buttonSearchClose.isHidden = true
                    self.view.endEditing(true)
                }
            }else if textField == self.textFieldMobileNumber{
                
                let length = Int(Utill.getLength(textField.text))
                
                if length >= 10 {
                    if range.length == 0 {
                        return false
                    }
                }
                
                if length == 3 {
                    let num = Utill.formatNumber(textField.text)
                    textField.text = "(\(num ?? "")) "
                    
                    if range.length > 0 {
                        textField.text = "\((num as NSString?)?.substring(to: 3) ?? "")"
                    }
                } else if length == 6 {
                    let num = Utill.formatNumber(textField.text)
                    textField.text = "(\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "") - "
                    
                    if range.length > 0 {
                        textField.text = "(\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "")"
                    }
                }
                self.dictTextField[Text.DictKeys.mobileNumber] = Utill.formatNumber(finalText)
                
                if finalText == ""{
//                    self.textFieldMobileNumber.resignFirstResponder()
                    self.textFieldMobileNumber.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldMobileNumber, placeHolderString: Text.TextField.text_CAB_MobileNumber, placeHolderTextColor: .SearchBarYellowColor)
                }
            }else if textField == self.textFieldEmail{
                if (textField.text?.count)! >= 50 {
                    if range.length == 0 {
                        return false
                    }
                }
                self.dictTextField[Text.DictKeys.emailAddress] = finalText
                if finalText == ""{
//                    self.textFieldEmail.resignFirstResponder()
                    self.textFieldEmail.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_CAB_EmailAddress, placeHolderTextColor: .SearchBarYellowColor)
                }
            }
        }
        self.checkValidationForBothFieldRequiredUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.textFieldSearch {
            self.buttonSearchClose.isHidden = true
            self.view.endEditing(true)
            return true
        }else if textField == self.textFieldMobileNumber{
            self.textFieldEmail.becomeFirstResponder()
        }else{
            self.textFieldEmail.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textFieldSearch {
            self.buttonSearchClose.isHidden = true
            self.viewClaimVenueDisplay.isHidden = true
            self.manageSearchFieldBorder(isFull: true)
            self.buttonOK.isHidden = true
            self.buttonClaimABusiness.isHidden = false
            self.view.endEditing(true)
        }else {
            self.buttonOK.isHidden = true
            self.buttonClaimABusiness.isHidden = false
        }
    }
}

//MARK: - TableView
extension WUClaimABusinessViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arraySearchSuggestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUClaimSuggestionsTableCell()), for: indexPath) as! WUClaimSuggestionsTableCell
        if indexPath.row < self.arraySearchSuggestion.count {
            cell.labelTitle.text = self.arraySearchSuggestion[indexPath.row].Name
            cell.seperator.isHidden = false
            if indexPath.row == self.arraySearchSuggestion.count - 1{
                cell.seperator.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.arraySearchSuggestion.count {
            self.textFieldSearch.text = self.arraySearchSuggestion[indexPath.row].Name
            self.dictTextField[Text.DictKeys.venueName] = self.textFieldSearch.text
            self.dictTextField[Text.DictKeys.venueFourSquareID] = self.arraySearchSuggestion[indexPath.row].VenueFourSquareID
            self.viewClaimVenueDisplay.isHidden = true
            self.manageSearchFieldBorder(isFull: true)
        }
    }
}
