//
//  WUSignUpViewController.swift
//  Demo_Wussup
//
//  Created by MAC219 on 13/04/18.
//  Copyright © 2018 MAC219. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding.TPKeyboardAvoidingTableView

class WUSignUpViewController: UIViewController {
    
    private let  viewSignUpHeightWithPWdInfo : CGFloat = 320.0.propotionalHeight
    private let viewSignUpHeightWithoutPWdInfo : CGFloat = 256.0.propotionalHeight
    
    @IBOutlet private weak var tableViewSignUp                  : TPKeyboardAvoidingTableView!
    @IBOutlet private weak var viewSignUp                       : UIView!
    @IBOutlet private weak var textFieldEmail                   : UITextField!
    @IBOutlet private weak var textFieldMobile                 : UITextField!
    @IBOutlet private weak var textFieldPassword                : UITextField!
    @IBOutlet private weak var textFieldConfrimPassword         : UITextField!
    @IBOutlet private weak var viewSeperatorCreatePassWord      : UIView!
    @IBOutlet private weak var viewSignUpHeight                 : NSLayoutConstraint!
    @IBOutlet private weak var viewPasswordInfoHeight           : NSLayoutConstraint!
    @IBOutlet private weak var viewSeperatorTopHeight           : NSLayoutConstraint!
    @IBOutlet private weak var viewSeperatorBottomUpHeight      : NSLayoutConstraint!
    @IBOutlet private weak var buttonTotalLetter                : UIButton!
    @IBOutlet private weak var buttonCapitalLetter              : UIButton!
    @IBOutlet private weak var buttonNumberLetter               : UIButton!
    @IBOutlet private weak var buttonNoSpace                    : UIButton!
    @IBOutlet private weak var imageViewFish                    : UIImageView!
    @IBOutlet private weak var buttonSubmit                     : UIButton!
    @IBOutlet private weak var buttonBack                       : UIButton!
    @IBOutlet private weak var imageViewBeeGif                  : UIImageView!
    @IBOutlet private weak var imageViewBGBeeDotLine            : UIImageView!
    
    var dictTextField : [String : String] = [Text.DictKeys.email : "" ,Text.DictKeys.mobile : "" , Text.DictKeys.password : "", Text.DictKeys.confirmpassword : ""]
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    func initialInterfaceSetUp() {
        self.tableViewSignUp.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewSignUp.frame.width, height: 667.0.propotionalHeight)
        self.setUpUIView()
        //        Utill.loadBeeAnimationForView(view: self.view)
        Utill.loadBeeGif(imageView: self.imageViewBeeGif)
        self.setAttributedStringForButtons()
        self.viewSignUpHeight.constant = self.viewSignUpHeightWithoutPWdInfo
        self.viewSeperatorTopHeight.constant = 0.0
        self.viewSeperatorBottomUpHeight.constant = 0.0
        self.viewPasswordInfoHeight.constant = 0.0
        self.viewSeperatorCreatePassWord.isHidden = false
        self.buttonBack.isSelected = false
    }
    
    private func setUpUIView() {
        self.viewSignUp.layer.borderColor = UIColor.white.cgColor
        self.viewSignUp.backgroundColor = .blackColor
        
        Utill.setPlaceHolderTextAndColor(textfield:textFieldEmail , placeHolderString: Text.TextField.text_Email, placeHolderTextColor: .SearchBarYellowColor)
        Utill.setPlaceHolderTextAndColor(textfield:textFieldMobile , placeHolderString: Text.TextField.text_MobileNumber, placeHolderTextColor: .SearchBarYellowColor)
        Utill.setPlaceHolderTextAndColor(textfield:textFieldPassword , placeHolderString: Text.TextField.text_CreatePassword, placeHolderTextColor: .SearchBarYellowColor)
        Utill.setPlaceHolderTextAndColor(textfield:textFieldConfrimPassword , placeHolderString:Text.TextField.text_ConfirmPassword, placeHolderTextColor: .SearchBarYellowColor)
        
        self.textFieldEmail.textColor               = .btnLightGrayColor
        self.textFieldMobile.textColor              = .btnLightGrayColor
        self.textFieldPassword.textColor            = .btnLightGrayColor
        self.textFieldConfrimPassword.textColor     = .btnLightGrayColor
        
        self.buttonSubmit.setTitleColor(.SearchBarYellowColor, for: .normal)
        self.buttonSubmit.layer.borderColor = UIColor.SearchBarYellowColor.cgColor
        
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .btnLightGrayColor ), for: .normal)
        
    }
    
    private func setAttributedStringForButtons(){
        self.buttonTotalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_TotalLetter_Prefix, str2: Text.Label.text_TotalLetter_Suffix, color: .RedColor, fontSize: 16.0), for: .normal)
        
        self.buttonTotalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_TotalLetter_Prefix, str2: Text.Label.text_TotalLetter_Suffix, color: .GreenColor, fontSize: 16.0), for: .selected)
        
        self.buttonCapitalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_CapitalLetter_Prefix, str2: Text.Label.text_CapitalLetter_Suffix, color: .RedColor, fontSize: 16.0), for: .normal)
        
        self.buttonCapitalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_CapitalLetter_Prefix, str2: Text.Label.text_CapitalLetter_Suffix, color: .GreenColor, fontSize: 16.0), for: .selected)
        
        self.buttonNumberLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_NumberLetter_Prefix, str2: Text.Label.text_NumberLetter_Suffix, color: .RedColor, fontSize: 16.0), for: .normal)
        
        self.buttonNumberLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_NumberLetter_Prefix, str2: Text.Label.text_NumberLetter_Suffix, color: .GreenColor, fontSize: 16.0), for: .selected)
    }
    
    // MARK: - Webservice Methods
    private func callWS_SignUp(){
        WEB_API.call_api_SignUp(userName: self.dictTextField[Text.DictKeys.email]!, mobile: self.dictTextField[Text.DictKeys.mobile]!, passWord: self.dictTextField[Text.DictKeys.password]!) { (response, success, message) in
            if success{
                let data = try! JSONSerialization.data(withJSONObject: response?["UserDetail"].dictionaryObject ?? [:], options: [])
                let user = try! JSONDecoder().decode(WUUser.self, from: data)
                Utill.saveUserModel(user)
                UserDefault.set(true, forKey:Text.UDKeys.isFromSignUp)
                UserDefault.synchronize()
                Utill.printInTOConsole(printData:"response: \(response ?? "")")
                self.performSegue(withIdentifier: Text.Segue.signUpToSignUpConfirm, sender: nil)
            }else {
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.buttonBack.isSelected = true
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .GreenColor ), for: .normal)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSubmitAction(_ sender: Any) {
        self.checkValidation()
    }
    
    //MARK: - checkValidation
    private func checkValidation(){
        self.textFieldEmail.resignFirstResponder()
        self.textFieldMobile.resignFirstResponder()
        self.textFieldPassword.resignFirstResponder()
        self.textFieldConfrimPassword.resignFirstResponder()
        
        self.hideFishView(isHide: true)
        if (self.dictTextField[Text.DictKeys.email] == "" && self.dictTextField[Text.DictKeys.mobile] == "") || self.dictTextField[Text.DictKeys.email] == "" {
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_EmailError)
            Utill.showAlertView(viewController: self, message: Text.Message.incorrectEmailFormatErrorMessage)
            self.hideFishView(isHide: false)
        }else if self.dictTextField[Text.DictKeys.email] != ""{
            if !((self.dictTextField[Text.DictKeys.email]?.isValidEmail)!) == true{
                self.textFieldEmail.text = Text.Label.text_BlankSpace
                Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_EmailError)
                Utill.showAlertView(viewController: self, message: Text.Message.incorrectEmailFormatErrorMessage)
                self.hideFishView(isHide: false)
            }else{
                self.validateMobileNumber()
            }
        }
    }
    
    private func validateMobileNumber(){
        if self.dictTextField[Text.DictKeys.mobile]?.isEmpty != true {
            if (self.dictTextField[Text.DictKeys.mobile]!.count) < 10  { //|| (self.dictTextField[Text.DictKeys.mobile]!.count) > 15
                self.textFieldMobile.text = Text.Label.text_BlankSpace
                Utill.setPlaceHolderTextAndColor(textfield: self.textFieldMobile, placeHolderString: Text.TextField.text_MobileError)
                Utill.showAlertView(viewController: self, message: Text.Message.incorrectPhoneNumberFormatErrorMessage)
                self.hideFishView(isHide: false)
            }else{
                self.validatePassword()
            }
        }else {
            self.validatePassword()
        }
    }
    
    private func validatePassword(){
        if self.dictTextField[Text.DictKeys.password]?.isEmpty == true{//self.textFieldPassword.text?.isEmpty == true
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldPassword, placeHolderString: Text.TextField.text_CreatePassword)
            self.hideFishView(isHide: false)
            self.managePassWordInfoView(isShow: true)
        }
        else{
            if self.validatePasswordInFoView(password: self.dictTextField[Text.DictKeys.password]!) == false{
                self.managePassWordInfoView(isShow: true)
            }else {
                self.managePassWordInfoView(isShow: false)
                if (self.dictTextField[Text.DictKeys.confirmpassword]?.isEmpty == true){
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldConfrimPassword, placeHolderString: Text.TextField.text_ConfirmPassword)
                    self.hideFishView(isHide: false)
                } else if  self.dictTextField[Text.DictKeys.password] != self.dictTextField[Text.DictKeys.confirmpassword]{
                    self.textFieldConfrimPassword.text = Text.Label.text_BlankSpace
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldConfrimPassword, placeHolderString: Text.TextField.text_PasswordError)
                    Utill.showAlertView(viewController: self, message: Text.Message.passwordNotMatchErrorMessage)

                    self.hideFishView(isHide: false)
                }else{
                    self.callWS_SignUp()
                }
            }
        }
    }
    
    private func checkValidationForSubmitButtonUI() {
        let email = self.dictTextField[Text.DictKeys.email]
        let password = self.dictTextField[Text.DictKeys.password]
        let confirmPassword = self.dictTextField[Text.DictKeys.confirmpassword]
        let mobile = self.dictTextField[Text.DictKeys.mobile]
        if (mobile?.count)! > 0 {
            if (email?.count)! > 0  && (password?.count)! > 0 && (confirmPassword?.count)! > 0 {
                if (email!.isValidEmail == true) && (self.validatePasswordInFoView(password: password!) == true) && (password! == confirmPassword!) && (mobile!.isNumeric == true)  && (mobile?.count)! == 10 {  //&& (mobile?.count)! <= 15)
                    self.buttonSubmit.setTitleColor(.GreenColor, for: .normal)
                    self.buttonSubmit.layer.borderColor = UIColor.GreenColor.cgColor
                }else{
                    self.buttonSubmit.setTitleColor(.SearchBarYellowColor, for: .normal)
                    self.buttonSubmit.layer.borderColor = UIColor.SearchBarYellowColor.cgColor
                }
            }
        }else {
            if (email?.count)! > 0  && (password?.count)! > 0 && (confirmPassword?.count)! > 0 {
                if (email!.isValidEmail == true) && (self.validatePasswordInFoView(password: password!) == true) && (password! == confirmPassword!){
                    self.buttonSubmit.setTitleColor(.GreenColor, for: .normal)
                    self.buttonSubmit.layer.borderColor = UIColor.GreenColor.cgColor
                }else{
                    self.buttonSubmit.setTitleColor(.SearchBarYellowColor, for: .normal)
                    self.buttonSubmit.layer.borderColor = UIColor.SearchBarYellowColor.cgColor
                }
            }
        }
    }
    
    private func hideFishView(isHide : Bool){
        if isHide == true{
            //            Utill.hideBeeAnimation(isHide: false, inView: self.view)
            self.imageViewBeeGif.isHidden = false
            self.imageViewBGBeeDotLine.isHidden = false
            self.imageViewFish.isHidden = true
        }else{
            Utill.hideBeeAnimation(isHide: true, inView: self.view)
            self.imageViewBeeGif.isHidden = true
            self.imageViewBGBeeDotLine.isHidden = true
            self.imageViewFish.isHidden = false
        }
    }
    
    private func validatePasswordInFoView(password: String) -> Bool {
        self.buttonTotalLetter.isSelected = false
        self.buttonCapitalLetter.isSelected = false
        self.buttonNumberLetter.isSelected = false
        self.buttonNoSpace.isSelected = true
        
        if  password.count >= 8 && password.count <= 20 {
            self.buttonTotalLetter.isSelected = true
        }
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        if  texttest.evaluate(with: password){
            self.buttonCapitalLetter.isSelected = true
        }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        if texttest1.evaluate(with: password){
            self.buttonNumberLetter.isSelected = true
        }
        
        let spaceCharacterRegEx  = ".*[\\s]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", spaceCharacterRegEx)
        if texttest2.evaluate(with: password) {
            self.buttonNoSpace.isSelected = false
        }
        
        if self.buttonTotalLetter.isSelected && self.buttonCapitalLetter.isSelected && self.buttonNumberLetter.isSelected && self.buttonNoSpace.isSelected {
            return true
        }
        return false
    }
    
    //MARK: - ManageView Animation
    private func managePassWordInfoView(isShow : Bool){
        if isShow == true{
            UIView.animate(withDuration: 0.3, animations: {
                self.viewSignUpHeight.constant = self.viewSignUpHeightWithPWdInfo
                self.viewSeperatorTopHeight.constant = 1.0
                self.viewSeperatorBottomUpHeight.constant = 1.0
                self.viewPasswordInfoHeight.constant = 100.0.propotionalHeight
                self.viewSeperatorCreatePassWord.isHidden = true
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.viewSignUpHeight.constant = self.viewSignUpHeightWithoutPWdInfo
                self.viewSeperatorTopHeight.constant = 0.0
                self.viewSeperatorBottomUpHeight.constant = 0.0
                self.viewPasswordInfoHeight.constant = 0.0
                self.viewSeperatorCreatePassWord.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: - TextField Delegate
extension WUSignUpViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideFishView(isHide: true)
        if textField == self.textFieldEmail{
            textField.text = self.dictTextField[Text.DictKeys.email]
        }else if textField == self.textFieldMobile{
            textField.text = Utill.arrangeUSFormat(strPhone: self.dictTextField[Text.DictKeys.mobile]!)
        }else if textField == self.textFieldPassword{
            textField.text = self.dictTextField[Text.DictKeys.password]
            if self.validatePasswordInFoView(password: textField.text!) == false{
                self.managePassWordInfoView(isShow: true)
            }else {
                self.managePassWordInfoView(isShow: false)
            }
        }else{
            Utill.setPlaceHolderTextAndColor(textfield:textFieldConfrimPassword , placeHolderString:Text.TextField.text_ConfirmPassword, placeHolderTextColor: .SearchBarYellowColor)
            textField.text = self.dictTextField[Text.DictKeys.confirmpassword]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            if textField == self.textFieldEmail{
                if (textField.text?.count)! >= 50 {
                    if range.length == 0 {
                        return false
                    }
                }
                self.dictTextField[Text.DictKeys.email] = finalText
                if finalText == ""{
                    //                    self.textFieldEmail.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield:textFieldEmail , placeHolderString: Text.TextField.text_Email, placeHolderTextColor: .SearchBarYellowColor)
                }
            }else if textField == self.textFieldMobile{
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
                self.dictTextField[Text.DictKeys.mobile] = Utill.formatNumber(finalText)
                if finalText == ""{
                    //                    self.textFieldMobile.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldMobile, placeHolderString: Text.TextField.text_MobileNumber, placeHolderTextColor: .SearchBarYellowColor)
                }
            }else if textField == self.textFieldPassword{
                self.dictTextField[Text.DictKeys.password] = finalText
                
                if finalText == ""{
                    Utill.setPlaceHolderTextAndColor(textfield:textFieldPassword , placeHolderString: Text.TextField.text_CreatePassword, placeHolderTextColor: .SearchBarYellowColor)
                    self.managePassWordInfoView(isShow: false)
                }else{
                    if self.validatePasswordInFoView(password: finalText) == false{
                        self.managePassWordInfoView(isShow: true)
                    }else {
                        self.managePassWordInfoView(isShow: false)
                    }
                }
                
            }else if textField == self.textFieldConfrimPassword{
                self.dictTextField[Text.DictKeys.confirmpassword] = finalText
                if finalText == ""{
                    Utill.setPlaceHolderTextAndColor(textfield:textFieldConfrimPassword , placeHolderString:Text.TextField.text_ConfirmPassword, placeHolderTextColor: .SearchBarYellowColor)
                }
            }
        }
        self.checkValidationForSubmitButtonUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.textFieldEmail{
            self.textFieldMobile.becomeFirstResponder()
        }else if textField == self.textFieldMobile{
            self.textFieldPassword.becomeFirstResponder()
        }else if textField == self.textFieldPassword{
            self.textFieldConfrimPassword.becomeFirstResponder()
        }else{
            self.textFieldConfrimPassword.resignFirstResponder()
        }
        return false
    }
}
