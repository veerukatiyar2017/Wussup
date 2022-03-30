//
//  WUProfileEditViewController.swift
//  Wussup
//
//  Created by Alexandr on 18.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class WUProfileEditViewController: UIViewController {
   
    //MARK: - Variable
    private var user                          : User! = GlobalShared.user
    private var geolocationFilterData         : WUGeolocationFilterData! = GlobalShared.geolocationFilterData
    private var currentEditingtextField       : UITextField!
    private var indexOfSelectedRadius         : Int!
    private var isUserLogOut                  : Bool = false


    //MARK: - Outlets
    @IBOutlet weak var emailTextField              : UITextField!
    @IBOutlet weak var mobileTextField             : UITextField!
    @IBOutlet weak var birthdayTextField           : UITextField!
    @IBOutlet weak var homeZipTextField            : UITextField!
    @IBOutlet weak var searchRadiusTextField       : UITextField!
    
    @IBOutlet weak var datePicker                  : UIDatePicker!
    @IBOutlet var radiusPicker                     : UIPickerView!
    @IBOutlet var toolBar                          : UIToolbar!
    @IBOutlet weak var toolBarCancelButton         : UIBarButtonItem!
    @IBOutlet weak var toolBarDoneButton           : UIBarButtonItem!
    

    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        Utill.showAlert_YESNO_View(viewController: self, message:Text.Message.logOut) { (action) in
            if action == true{
                self.isUserLogOut = true
                self.callWS_LogoutUser()
            }
        }
    }
    
    @IBAction func birthdayButtonAction(_ sender: UIButton) {
        pickUpDate(self.birthdayTextField)
    }
    
    @IBAction func radiusButtonAction(_ sender: UIButton) {
        self.pickUpRadius(self.searchRadiusTextField)
    }
    
    @IBAction func buttonToolBarDoneClicked(_ sender: UIBarButtonItem) {
        
        if self.currentEditingtextField == self.birthdayTextField{
            self.birthdayTextField.text = self.datePicker.date.stringDateForBirthday
        }else{
            guard self.indexOfSelectedRadius != nil else {return}
            let lastIndexOfRadiusValueOptions = WUText.WUSearchFilterNames().radiusValueOptions.count - 1
            self.searchRadiusTextField.text = WUText.WUSearchFilterNames().radiusValueOptions[(self.indexOfSelectedRadius ?? lastIndexOfRadiusValueOptions)] + " miles"
            let radiusString = WUText.WUSearchFilterNames().radiusValueOptions[(self.indexOfSelectedRadius ?? lastIndexOfRadiusValueOptions)]
            self.call_api_SaveLatLongDetails()
            self.geolocationFilterData.Radius = radiusString.contains("+") ? 90 : Int(radiusString)!
        }
        
        self.view.endEditing(true)
      }
      
      @IBAction func buttonToolbarCancelClicked(_ sender: UIBarButtonItem) {
          self.view.endEditing(true)
      }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialInterfaceSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.saveProfileData()
    }

       // MARK: - Initial Setup
    private func initialInterfaceSetup(){
        self.isUserLogOut = false
        self.reloadDataForProfile()
        self.callWS_GetUserProfile()
   }
    
     private func saveProfileData(){
        if checkValidation() && !self.isUserLogOut{
           
            self.callWS_EditUserProfile { (isSuccess) in
                if isSuccess{
                    self.call_api_SaveLatLongDetails()
                }
            }
        }else{
            self.showAlert()
        }
    }
    
    
    // MARK: - Webservice Methods
  private  func callWS_GetUserProfile() {

        WEB_API.call_api_GetUserProfile()
            { (response, success, message) in
                
                if success {
                    let data = try! JSONSerialization.data(withJSONObject: response?["UserProfile"].dictionaryObject ?? [:], options: [])
                    let user = try! JSONDecoder().decode(WUUser.self, from: data)
                    user.Token = self.user.Token
                    Utill.saveUserModel(user)
                    Utill.printInTOConsole(printData:"response: \(response ?? "")")
                    
                    self.user.Mobile = Utill.formatNumber(GlobalShared.user.Mobile) ?? ""
                    self.user = GlobalShared.user
                    self.call_api_GetLatLongDetails(with: self.user)
                }
        }
    }
    
    private func call_api_GetLatLongDetails(with user: User){
           
           WEB_API.call_api_GetLatLongDetails(user: user) { (response, success, message) in
                                  
               let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
               GlobalShared.geolocationFilterData = try! JSONDecoder().decode(WUGeolocationFilterData.self, from: data)
            
               self.geolocationFilterData =  GlobalShared.geolocationFilterData
               self.reloadDataForProfile()
           }
       }
    
    private func callWS_EditUserProfile(completionHandler : @escaping (Bool) -> Void) {
        
        var birthday = ""
        
        if let strBirthday = self.birthdayTextField.text!.dateFromCustomString(withFormat: "MMMM dd, yyyy")
        {
            birthday = strBirthday.stringDate!
        }

        let mobile = Utill.formatNumber(self.mobileTextField.text!) ?? ""
        WEB_API.call_api_EditUserProfile(username           : self.user.UserName,
                                         imageUrl           : self.user.ImageURL,
                                         email              : self.emailTextField.text!,
                                         mobile             : mobile,
                                         birthDate          : birthday,
                                         city               : self.user.City,
                                         allowNotification  : self.user.IsAllowedNotification,
                                         postalCode         : self.homeZipTextField.text!,
                                         categoriesPreference: GlobalShared.arrayCategories.clone().filter({ $0.isSelected }).map { $0.ID }.joined(separator: ","))
        { (response, success, message) in

            if success {
                let data = try! JSONSerialization.data(withJSONObject: response?["UserProfile"].dictionaryObject ?? [:], options: [])
                let user = try! JSONDecoder().decode(WUUser.self, from: data)
                user.Token = self.user.Token
                Utill.saveUserModel(user)
                
            } else {
                Utill.printInTOConsole(printData:"response: \(response ?? "")")
                Utill.showAlertView(viewController: self, message: message)
            }
            
            completionHandler(success)
        }

    }
    
    private func callWS_LogoutUser(){
        WEB_API.call_api_LogoutUser { (response, success, message) in
            Utill.logOutAndClearData()
        }
    }
    
    private func call_api_SaveLatLongDetails(){
        
        if self.indexOfSelectedRadius != nil{
            let radiusString = WUText.WUSearchFilterNames().radiusValueOptions[(self.indexOfSelectedRadius)]
            self.geolocationFilterData.Radius = radiusString.contains("+") ? 90 : Int(radiusString)!
        }
      
        WEB_API.call_api_SaveLatLongDetails(user: self.user,
                                            latitude: self.geolocationFilterData.Latitude,
                                            longitude: self.geolocationFilterData.Longitude,
                                            radius: String(self.geolocationFilterData.Radius),
                                            isNearBy: self.geolocationFilterData.IsNearBy) { (response,status,message) in

          GlobalShared.geolocationFilterData = self.geolocationFilterData
        }
    }
    
    //MARK: - reloadDataForProfile
      func reloadDataForProfile() {

        //  Email
        self.emailTextField.text = self.user.Email
        
        // Mobile
        self.mobileTextField.text = Utill.arrangeUSFormat(strPhone: self.user.Mobile) // self.user.Mobile //
          
        // Birthday
        if let date = self.user.Birthdate.dateFromCustomString(withFormat: "MM/dd/yyyy")
        {
            self.birthdayTextField.text = date.stringDateForBirthday!
        } else {
            self.birthdayTextField.text = ""
        }
        
         // Zip Code
        self.homeZipTextField.text = self.user.PostalCode
        
        // Radius
        self.searchRadiusTextField.text = String(self.geolocationFilterData.Radius) + " miles"
        
        if self.geolocationFilterData.Radius == 90{
            self.searchRadiusTextField.text = "+" + self.searchRadiusTextField.text!
        }
      }
    
    
    func checkValidation() -> Bool {
        
        if self.emailTextField.text == ""{
            return false
        } else if  !(self.emailTextField.text?.isValidEmail)! {
            return false
        } else if self.mobileTextField.text != "" && (self.mobileTextField.text!.count) < 10  {
            return false
        } else if self.homeZipTextField.text != "" && !(self.homeZipTextField.text?.isvalidZipCode)! {
            return false
        }
        
        return true
    }
    
    func showAlert() {

        let profileEmail = self.emailTextField.text
        let profileMobile = self.mobileTextField.text
        let profileZipCode  = self.homeZipTextField.text
        
        if profileEmail == "" && profileMobile == "" {
            self.emailTextField?.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Message.pleaseEnterEmailORMobile)
                
        } else if profileEmail == "" || !(profileEmail?.isValidEmail)! {
            self.emailTextField?.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Message.pleaseEnterValidEmail)
                
        } else if profileMobile != "" && profileMobile!.count < 10  {
            self.emailTextField?.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Label.text_validPhoneNumberDigit)
        }else if profileZipCode != "" && !(profileZipCode?.isvalidZipCode)! {
            self.homeZipTextField?.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Label.text_validZipCode)
        }
    }
}

extension WUProfileEditViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentEditingtextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.mobileTextField{
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            return false
        }
        return true
    }
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX - XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}


extension WUProfileEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
  
    // MARK: - DatePicker Methods
    private func pickUpDate(_ textField : UITextField){
        // DatePicker
        self.datePicker.maximumDate = Date()
        if let birthday = textField.text, birthday.count > 0,
            let strDate = birthday.dateFromCustomString(withFormat: "MMMM dd, yyyy") {
            self.datePicker.date = strDate
        }
        
        textField.inputView = self.datePicker
        textField.inputAccessoryView = self.toolBar
        
        textField.becomeFirstResponder()
    }
    
    // MARK: - RadiusPicker Methods
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.radiusPicker{
            self.indexOfSelectedRadius = row
        }
    }
    
    
       private func pickUpRadius(_ textField : UITextField){

        //self.radiusPicker.backgroundColor = UIColor.DarkGreyAppColor
        //self.toolBar.barTintColor = UIColor.black
        //self.toolBarCancelButton.tintColor = UIColor.LightYellowAppColor
        //self.toolBarDoneButton.tintColor = UIColor.LightYellowAppColor

        textField.inputView = self.radiusPicker
        textField.inputAccessoryView = self.toolBar
           
        textField.becomeFirstResponder()
       }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
      
     func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
         
         return NSAttributedString(string:  WUText.WUSearchFilterNames().radiusValueOptions[row] + " miles", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return WUText.WUSearchFilterNames().radiusValueOptions.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return WUText.WUSearchFilterNames().radiusValueOptions[row] + " miles"
     }
    
    
}

