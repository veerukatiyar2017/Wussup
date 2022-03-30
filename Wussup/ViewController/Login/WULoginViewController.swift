//
//  WULoginViewController.swift
//  Demo_Wussup
//
//  Created by MAC219 on 13/04/18.
//  Copyright © 2018 MAC219. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding.TPKeyboardAvoidingTableView
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import Firebase

class WULoginViewController: UIViewController{
    
    @IBOutlet private weak var tableViewLogin           : TPKeyboardAvoidingTableView!
    @IBOutlet private weak var viewLogin                : UIView!
    @IBOutlet private weak var textFieldEmail           : UITextField!
    @IBOutlet private weak var viewSeperator1           : UIView!
    @IBOutlet private weak var textFieldPassword        : UITextField!
    @IBOutlet private weak var viewSeperator2           : UIView!
    @IBOutlet private weak var buttonLogin              : UIButton!
    @IBOutlet private weak var viewSeperator3           : UIView!
    @IBOutlet private weak var buttonForgotPassword     : UIButton!

    @IBOutlet private weak var viewPasswordInfo         : UIView!
    @IBOutlet private weak var buttonTotalLetter        : UIButton!
    @IBOutlet private weak var buttonCapitalLetter      : UIButton!
    @IBOutlet private weak var buttonNumberLetter       : UIButton!
    @IBOutlet private weak var buttonNoSpace            : UIButton!
    @IBOutlet private weak var buttonOk                 : UIButton!
    
    @IBOutlet private weak var buttonBack               : UIButton!
    @IBOutlet private weak var imageViewBeeGif          : UIImageView!
    
    
    var dictTextField : [String : String] = [Text.DictKeys.email : "" , Text.DictKeys.password : ""]
 
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    func initialInterfaceSetUp() {
        self.tableViewLogin.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.tableViewLogin.frame.width, height: 667.0.propotionalHeight)
        self.setUpUIView()
//        Utill.loadBeeAnimationForView(view: self.view)
         Utill.loadBeeGif(imageView: self.imageViewBeeGif)
        self.buttonBack.isSelected = false
        self.setAttributedStringForButtons()
    }
    
    private func setUpUIView() {
        self.viewLogin.layer.borderColor = UIColor.white.cgColor
        self.viewLogin.backgroundColor = .blackColor
        
        Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_EmailOrMobile, placeHolderTextColor: .SearchBarYellowColor)
        self.textFieldEmail.textColor = .btnLightGrayColor
        self.viewSeperator1.backgroundColor = .white
        
        Utill.setPlaceHolderTextAndColor(textfield: self.textFieldPassword, placeHolderString: Text.TextField.text_Password, placeHolderTextColor: .SearchBarYellowColor)
        self.textFieldPassword.textColor = .btnLightGrayColor
        self.viewSeperator2.backgroundColor = .white
        
        self.buttonLogin.setTitleColor(.SearchBarYellowColor, for: .normal)
        self.viewSeperator3.backgroundColor = .white
        
        self.buttonForgotPassword.setTitleColor(.btnForgotPwdGreenColor, for: .normal)        
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .btnLightGrayColor ), for: .normal)
    }
    private func setAttributedStringForButtons(){
        self.buttonTotalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_TotalLetter_Prefix, str2: Text.Label.text_TotalLetter_Suffix, color: .RedColor, fontSize: 18.0), for: .normal)
        
        self.buttonTotalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_TotalLetter_Prefix, str2: Text.Label.text_TotalLetter_Suffix, color: .GreenColor, fontSize: 18.0), for: .selected)
        
        self.buttonCapitalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_CapitalLetter_Prefix, str2: Text.Label.text_CapitalLetter_Suffix, color: .RedColor, fontSize: 18.0), for: .normal)
        
        self.buttonCapitalLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_CapitalLetter_Prefix, str2: Text.Label.text_CapitalLetter_Suffix, color: .GreenColor, fontSize: 18.0), for: .selected)
        
        self.buttonNumberLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_NumberLetter_Prefix, str2: Text.Label.text_NumberLetter_Suffix, color: .RedColor, fontSize: 18.0), for: .normal)
        
        self.buttonNumberLetter.setAttributedTitle(Utill.setAttributedStringForAutopurchase(str1: Text.Label.text_NumberLetter_Prefix, str2: Text.Label.text_NumberLetter_Suffix, color: .GreenColor, fontSize: 18.0), for: .selected)
    }
    
    // MARK: - Webservice Methods
    private func callWS_Login(){
        WEB_API.call_api_Login(userName: self.dictTextField[Text.DictKeys.email]!, passWord: self.textFieldPassword.text!) { (response, success, message) in
            if success{
                 FirebaseManager.sharedInstance.login_complete_ios(parameter: nil)
                let data = try! JSONSerialization.data(withJSONObject: response?["UserDetail"].dictionaryObject ?? [:], options: [])
                let user = try! JSONDecoder().decode(WUUser.self, from: data)
                Utill.saveUserModel(user)
                Utill.printInTOConsole(printData:"response: \(response ?? "")")
                UserDefault.set(false, forKey:Text.UDKeys.isFromSignUp)
                UserDefault.synchronize()
                self.performSegue(withIdentifier: Text.Segue.loginToHome, sender: nil)
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
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        self.checkValidation()
    }
    
    @IBAction func buttonForgotPasswordAction(_ sender: Any) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: Text.Segue.loginToForgotPasssword, sender: nil)
    }
    
    @IBAction func buttonOk(_ sender: Any) {
        self.manageViewPasswordInclude(isShow: false)
    }
    
    //MARK: - Check Validation
    private func checkValidation(){
        self.textFieldEmail.resignFirstResponder()
        self.textFieldPassword.resignFirstResponder()
        
        let finalUserName =  Utill.formatNumber(self.dictTextField[Text.DictKeys.email]!)
        
        if finalUserName?.isEmpty == true{
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_EmailOrMobileError)
        }else {
            if  finalUserName!.isNumeric == true {
                if (self.textFieldEmail.text?.count)! < 10  { //&& (self.textFieldEmail.text?.count)! >= 15)
                    self.textFieldEmail.text = Text.Label.text_BlankSpace
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_MobileError)
                }else{
                    self.validatePassword()
                }
            }else if !((finalUserName!.isValidEmail)) == true{
                self.textFieldEmail.text = Text.Label.text_BlankSpace
                Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_EmailError)
            }else{
                self.validatePassword()
            }
        }
    }
    
    private func validatePassword(){
        if self.dictTextField[Text.DictKeys.password]?.isEmpty == true{
            self.textFieldPassword.text = Text.Label.text_BlankSpace
            Utill.setPlaceHolderTextAndColor(textfield: self.textFieldPassword, placeHolderString: Text.TextField.text_PasswordError)
        }else{
          //  self.callWS_Login()
            callFirebaseLogin()
        }
    }
    
    private func callFirebaseLogin() {
//        let email = "example@gmail.com"
//        let password = "testtest"
        
        Auth.auth().signIn(withEmail: self.textFieldEmail.text!, password: self.textFieldPassword.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(strongSelf)
          // ...
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
                print("Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.")
              // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
            case .userDisabled:
                print("Error: The user account has been disabled by an administrator.")
              // Error: The user account has been disabled by an administrator.
            case .wrongPassword:
                print("Error: The password is invalid or the user does not have a password.")
              // Error: The password is invalid or the user does not have a password.
            case .invalidEmail:
              // Error: Indicates the email address is malformed.
                print("Error: Indicates the email address is malformed.")
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
            print("User signs in successfully")
            let userInfo = Auth.auth().currentUser
              let uid = userInfo?.uid
              // Add a new document in collection "cities"
              var dbb = Firestore.firestore()
              dbb.collection("users")
                  .document(uid!)
                  .getDocument { (querySnapshot, err) in
                      if let err = err {
                          print("Error getting documents: \(err)")
                          Utill.hideProgressHud()
                      } else {
                          print(querySnapshot!.documentID)
                          print(querySnapshot!.data()!["mobile"]!)
                          print((querySnapshot!.data()!["favoriteCategories"]! as AnyObject).count!)
                          for document in querySnapshot!.data()! {
                              Utill.hideProgressHud()
                              print("\(document) => ")
                          }
                      }
                      self?.performSegue(withIdentifier: Text.Segue.signUpConfirmToInterest, sender: nil)
                  }
          }
        }
    }
    
    private func validatePasswordInFoView(password: String) -> Bool {
        self.buttonTotalLetter.isSelected = false
        self.buttonCapitalLetter.isSelected = false
        self.buttonNumberLetter.isSelected = false
        self.buttonNoSpace.isSelected = false
        
        if  password.count >= 8 && password.count <= 20{
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
        if !texttest2.evaluate(with: password) {
            self.buttonNoSpace.isSelected = true
        }
        
        if self.buttonTotalLetter.isSelected && self.buttonCapitalLetter.isSelected && self.buttonNumberLetter.isSelected && self.buttonNoSpace.isSelected {
            return true
        }
        return false
    }
    
    //MARK: - ManageView Animation
    private func manageViewPasswordInclude(isShow : Bool){
        
        if isShow == true{
//            Utill.hideBeeAnimation(isHide: false, inView: self.view)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.bringSubview(toFront: self.viewPasswordInfo)
                self.viewLogin.isHidden = true
                self.viewLogin.alpha = 0.0
                self.viewPasswordInfo.isHidden = false
                self.viewPasswordInfo.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.view.bringSubview(toFront: self.viewLogin)
                self.viewLogin.isHidden = false
                self.viewLogin.alpha = 1.0
                self.viewPasswordInfo.isHidden = true
                self.viewPasswordInfo.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.loginToHome{
            let tabbarvc = segue.destination as! WUTabbarViewController
            AppDel.tabbar = tabbarvc
        }
    }
}

//MARK: - TextField Delegate

extension WULoginViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textFieldEmail{
            if (self.dictTextField[Text.DictKeys.email]?.isNumeric)! {
              textField.text = Utill.arrangeUSFormat(strPhone: self.dictTextField[Text.DictKeys.email]!)
            }else{
                textField.text = self.dictTextField[Text.DictKeys.email]
            }
        }else{
            textField.text = self.dictTextField[Text.DictKeys.password]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            
            if textField == self.textFieldEmail{
                if (string.isNumeric || string == "") && (Utill.formatNumber(finalText)?.isNumeric)!{
                    
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
                }else {
                    textField.text = Utill.formatNumber(textField.text)
                }
                self.dictTextField[Text.DictKeys.email] = Utill.formatNumber(finalText)
                if finalText == ""{
//                    self.textFieldEmail.resignFirstResponder()
                    self.textFieldEmail.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldEmail, placeHolderString: Text.TextField.text_EmailOrMobileError, placeHolderTextColor: .SearchBarYellowColor)
                }
            }else if textField == self.textFieldPassword{
                self.dictTextField[Text.DictKeys.password] = finalText
                if finalText == ""{
//                    self.textFieldPassword.resignFirstResponder()
                    self.textFieldPassword.text = finalText
                    Utill.setPlaceHolderTextAndColor(textfield: self.textFieldPassword, placeHolderString: Text.TextField.text_PasswordError, placeHolderTextColor: .SearchBarYellowColor)
//                    self.manageViewPasswordInclude(isShow: true)
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.textFieldEmail{
            self.textFieldPassword.becomeFirstResponder()
        }else{
            self.textFieldPassword.resignFirstResponder()
        }
        return false
    }
}
/*
 //                else if string == "" {
 //                    if finalText.range(of: "(") != nil {
 //                        textField.text = finalText
 //                    }else {
 //
 //                    }
 //
 //                }
 
 //                self.dictTextField[Text.DictKeys.mobile] = Utill.formatNumber(finalText)
 
 
 
 
 //                 self.dictTextField[Text.DictKeys.email] = finalText
 
 
 //                else if string.isNumeric {
 //                    let length = Int(Utill.getLength(textField.text))
 //
 //                    if length > 15 {
 //                        if range.length == 0 {
 //                            return false
 //                        }
 //                    }
 //
 //                    if length == 3 {
 //                        let num = Utill.formatNumber(textField.text)
 //                        textField.text = "(\(num ?? "")) "
 //
 //                        if range.length > 0 {
 //                            textField.text = "\((num as NSString?)?.substring(to: 3) ?? "")"
 //                        }
 //                    } else if length == 6 {
 //                        let num = Utill.formatNumber(textField.text)
 //                        textField.text = "(\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "") - "
 //
 //                        if range.length > 0 {
 //                            textField.text = "(\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "")"
 //                        }
 //                    }
 ////                     self.dictTextField[Text.DictKeys.email] = Utill.formatNumber(textField.text)
 //                }else {
 //                    textField.text = Utill.formatNumber(textField.text)
 //                    self.dictTextField[Text.DictKeys.email] = textField.text
 //                }
 */
