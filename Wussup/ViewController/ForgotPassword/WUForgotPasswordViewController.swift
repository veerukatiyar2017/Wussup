//
//  WUForgotPasswordViewController.swift
//  Demo_Wussup
//
//  Created by MAC219 on 13/04/18.
//  Copyright © 2018 MAC219. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding.TPKeyboardAvoidingTableView
import IQKeyboardManagerSwift

class WUForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var tableviewForGotPassword: TPKeyboardAvoidingTableView!
    @IBOutlet private weak var viewEnterForgotPassword  : UIView!
    @IBOutlet private weak var labelEmailDiscription    : UILabel!
    @IBOutlet private weak var viewSeperator1           : UIView!
    @IBOutlet private weak var textFieldEmailOrMobile   : UITextField!
    @IBOutlet private weak var viewSeperator2           : UIView!
    @IBOutlet private weak var buttonSubmit             : UIButton!
    @IBOutlet private weak var buttonBack               : UIButton!
    @IBOutlet private weak var buttonDone               : UIButton!
    @IBOutlet private weak var imageForgotEmailSent     : UIImageView!
    @IBOutlet private weak var viewForgotPasswordSent   : UIView!
    @IBOutlet private weak var labelPasswordSent        : UILabel!
    @IBOutlet private weak var viewSeperatorSent        : UIView!
    @IBOutlet private weak var labelUsersEmailOrMobileSent   : UILabel!
    @IBOutlet private weak var imageViewBeeGif             : UIImageView!
    @IBOutlet private weak var imageViewBGBeeDotLine       : UIImageView!
    var dictTextField : [String : String] = [Text.DictKeys.email : ""]
    
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Utill.removeKeyBoardManagement()
        initialInterfaceSetUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utill.enableKeyboardManagement()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    private func initialInterfaceSetUp() {
          self.tableviewForGotPassword.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableviewForGotPassword.frame.width, height: 667.0.propotionalHeight)
//        Utill.loadBeeAnimationForView(view: self.view)
         Utill.loadBeeGif(imageView: self.imageViewBeeGif)
        self.setUpUIView()
    }
    
    private func setUpUIView() {
        self.viewEnterForgotPassword.layer.borderColor = UIColor.white.cgColor
        self.viewEnterForgotPassword.backgroundColor = .blackColor
        //self.labelEmailDiscription.textColor =
        self.viewSeperator1.backgroundColor = .white
        self.textFieldEmailOrMobile.textColor = .btnLightGrayColor
        self.viewSeperator2.backgroundColor = .white
        
        Utill.setPlaceHolderTextAndColor(textfield: textFieldEmailOrMobile, placeHolderString: Text.TextField.text_EmailOrMobile, placeHolderTextColor:.SearchBarYellowColor)
        self.buttonSubmit.layer.borderColor = UIColor.SearchBarYellowColor.cgColor
        self.buttonSubmit.setTitleColor(.SearchBarYellowColor, for: .normal)
        
        self.buttonDone.isSelected = false
        self.buttonBack.isSelected = false
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1:Text.Label.text_Back , color: .btnLightGrayColor), for: .normal)
        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1:Text.Label.text_Done , color: .btnLightGrayColor), for: .normal)
        
        self.viewForgotPasswordSent.layer.borderColor = UIColor.white.cgColor
        self.labelPasswordSent.textColor = .btnLightGrayColor
         self.viewSeperatorSent.backgroundColor = .white
        self.viewForgotPasswordSent.backgroundColor = .blackColor
        self.labelUsersEmailOrMobileSent.textColor = .SearchBarYellowColor
        
    }
    
    
    // MARK: - Webservice Methods
    private func callWS_ForgotPassword(){
        FirebaseManager.sharedInstance.forgot_pass_ios(parameter: nil)
        WEB_API.call_api_ForgotPassword(userName: self.textFieldEmailOrMobile.text!) { (response, success, message) in
            if success{
                Utill.printInTOConsole(printData:"response: \(response ?? "")")
                self.labelUsersEmailOrMobileSent.text = self.textFieldEmailOrMobile.text
                self.manageForgotPasswordViewSent(isShow: true)
            }else {
                self.buttonSubmit.setTitleColor(.SearchBarYellowColor, for: .normal)
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
        self.textFieldEmailOrMobile.resignFirstResponder()
        if self.dictTextField[Text.DictKeys.email]?.isEmpty == true {
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmailOrMobile, placeHolderString: Text.TextField.text_EmailOrMobileError, placeHolderTextColor: UIColor.red)
        }else{
            if self.dictTextField[Text.DictKeys.email]?.isNumeric == true{
                if !((self.dictTextField[Text.DictKeys.email]?.count)! >= 9 && (self.dictTextField[Text.DictKeys.email]?.count)! <= 12) {
                    self.textFieldEmailOrMobile.text = Text.Label.text_BlankSpace
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmailOrMobile, placeHolderString: Text.TextField.text_MobileError, placeHolderTextColor: UIColor.red)
                }else {
                    self.callWS_ForgotPassword()
                }
            }else if !((self.dictTextField[Text.DictKeys.email]?.isValidEmail)!) == true {
                self.textFieldEmailOrMobile.text = Text.Label.text_BlankSpace
                Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmailOrMobile, placeHolderString: Text.TextField.text_EmailError, placeHolderTextColor: UIColor.red)
            }else {
                self.buttonSubmit.layer.borderColor = UIColor.GreenColor.cgColor
                self.buttonSubmit.setTitleColor(.GreenColor, for: .normal)
                self.callWS_ForgotPassword()
            }
        }
    }
    
    @IBAction func buttonDoneAction(_ sender: Any) {
        self.buttonDone.isSelected = true
        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1:Text.Label.text_Done , color: .SearchBarYellowColor), for: .normal)
        Utill.goToWelComeScreen(viewController: self)
    }
    
    //MARK: - ManageView Animation
    private func manageForgotPasswordViewSent(isShow : Bool){
        if isShow == true{
            self.view.bringSubview(toFront: self.viewForgotPasswordSent)
            
            self.imageForgotEmailSent.isHidden = false
            self.buttonDone.isHidden = false
            self.viewForgotPasswordSent.isHidden = false
            self.viewEnterForgotPassword.isHidden = true
            self.buttonBack.isHidden = true
            
            self.imageForgotEmailSent.alpha = 1.0
            self.buttonDone.alpha = 1.0
            self.viewForgotPasswordSent.alpha = 1.0
            self.viewEnterForgotPassword.alpha = 0.0
            self.buttonBack.alpha = 0.0
//            Utill.removeBeeAnimationForView(view: self.view)
            self.imageViewBeeGif.isHidden = true
            self.imageViewBGBeeDotLine.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: - TextField Delegate
extension WUForgotPasswordViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = self.dictTextField[Text.DictKeys.email]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            self.dictTextField[Text.DictKeys.email] = finalText
            if finalText ==  ""{
                self.textFieldEmailOrMobile.resignFirstResponder()
                self.textFieldEmailOrMobile.text = finalText
                Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmailOrMobile, placeHolderString: Text.TextField.text_EmailOrMobileError, placeHolderTextColor: .SearchBarYellowColor)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return false
    }
}
