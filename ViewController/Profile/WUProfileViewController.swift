//
//  WUProfileViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/21/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SDWebImage
import Photos
import TPKeyboardAvoiding.TPKeyboardAvoidingTableView

// MARK: - Profile Model
enum ProfileCellType {
    case cellTypeOnlyLabel
    case cellTypeEditDone
    case cellTypeTitleSubTitle
    case cellTypeLabelButton
    case cellTypeImageLabel
    case cellFavoriteSwitch
}

enum ProfileCellDataType {
    case cellDataTypeProfileInfo
    case cellDataTypeEditDone
    case cellDataTypeUserName
    case cellDataTypeCity
    case cellDataTypeEmail
    case cellDataTypeMobile
    case cellDataTypeBirthday
    case cellDataTypeInterest
    case cellDataTypeCategory
    case cellDataTypeNotification
    case cellDataTypeLogout
    
}

class  ProfileCellDataModel: NSObject {
    var profilePlaceHoder       : String                = ""
    var profilePlaceHoderValue  : String                = ""
    var profileCellType         : ProfileCellType       = .cellTypeImageLabel
    var profileCellDataType     : ProfileCellDataType   = .cellDataTypeCategory
}

class WUProfileViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonUserProfile    : UIButton!
    @IBOutlet weak var imageUserProfile     : UIImageView!
    @IBOutlet weak var labelCity            : UILabel!
    @IBOutlet weak var labelName            : UILabel!
    @IBOutlet weak var tableViewProfile     : TPKeyboardAvoidingTableView!
    @IBOutlet weak var datePicker           : UIDatePicker!
    @IBOutlet var toolBar                   : UIToolbar!
    
    //MARK: - Variable
    private var arrUserProfile          : [ProfileCellDataModel] = []
    private var dicEditedUserProfile    : Dictionary<String, String> = [:]
    private var currentEditingtextField : UITextField!
    private var user                    : User! = GlobalShared.user
    var profileImageToEdit              : UIImage?
    var isEditingEnable = false
    var arrtextField                    : [UITextField] = []
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialInterfaceSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    func initialInterfaceSetup() {
        self.isEditingEnable = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateEditedProfileDictionary(notification:)), name: .interestToProfile, object: nil)
        if UserDefault.bool(forKey: Text.UDKeys.isProfileViewedFirst) == false {
            self.navigationController?.setViewControllers([(self.storyboard?.get(WUProfileViewController.self))!], animated: false)
            UserDefault.set(true, forKey: Text.UDKeys.isProfileViewedFirst)
            UserDefault.synchronize()
        }
//        self.user = GlobalShared.user
//        self.reloadDataForProfile()
        self.callWS_GetUserProfile()

    }
    
    @objc func updateEditedProfileDictionary(notification: NSNotification) {
        //        let selectedIds = notification.object as! String
        let arrselectedCategory = notification.object as! [WUCategory]
        self.dicEditedUserProfile[Text.DictKeys.profileCategory] = arrselectedCategory.filter{$0.isSelected == true}.map({$0.ID}).joined(separator: ",")
        
        let arr = self.arrUserProfile.filter{$0.profileCellType != .cellTypeImageLabel}
        self.arrUserProfile = arr
        var index = self.arrUserProfile.index(of: self.arrUserProfile.filter{$0.profilePlaceHoderValue == Text.Label.text_ProfileSelect}.first!)
        
        
        for objCat in arrselectedCategory{
            index = index!+1
            let profileInterestModel = ProfileCellDataModel.init()
            profileInterestModel.profileCellType = .cellTypeImageLabel
            profileInterestModel.profilePlaceHoder = objCat.SelectedImageURL
            profileInterestModel.profilePlaceHoderValue = objCat.WussupName
            profileInterestModel.profileCellDataType = .cellDataTypeInterest
            self.arrUserProfile.insert(profileInterestModel, at: index!)
        }
        self.tableViewProfile.reloadData()
    }
    //MARK: - reloadDataForProfile
    func reloadDataForProfile() {
        
        self.arrUserProfile.removeAll()
        let profileInfoModel = ProfileCellDataModel.init()
        profileInfoModel.profilePlaceHoder = Text.Label.text_ProfileInfo
        profileInfoModel.profileCellType = .cellTypeOnlyLabel
        profileInfoModel.profileCellDataType = .cellDataTypeProfileInfo
        self.arrUserProfile.append(profileInfoModel)
        
        let profileEditDoneModel = ProfileCellDataModel.init()
        profileEditDoneModel.profileCellType = .cellTypeEditDone
        profileEditDoneModel.profileCellDataType = .cellDataTypeEditDone
        self.arrUserProfile.append(profileEditDoneModel)
        
        let profileUserNameModel = ProfileCellDataModel.init()
        profileUserNameModel.profileCellType = .cellTypeTitleSubTitle
        profileUserNameModel.profilePlaceHoder = Text.Label.text_ProfileUserName
        if self.user.FacebookID != "" {
            profileUserNameModel.profilePlaceHoderValue = Text.Label.text_LoggedWithFacebook
        }else {
          profileUserNameModel.profilePlaceHoderValue = self.user.UserName.lowercased() == self.user.Email.lowercased() ? "" : self.user.UserName
        }
        profileUserNameModel.profileCellDataType = .cellDataTypeUserName
        self.arrUserProfile.append(profileUserNameModel)
        
        let profilCityNameModel = ProfileCellDataModel.init()
        profilCityNameModel.profileCellType = .cellTypeTitleSubTitle
        profilCityNameModel.profilePlaceHoder = Text.Label.text_ProfileCity
        profilCityNameModel.profileCellDataType = .cellDataTypeCity
        profilCityNameModel.profilePlaceHoderValue = self.user.City
        self.arrUserProfile.append(profilCityNameModel)
        
        let profileEmailModel = ProfileCellDataModel.init()
        profileEmailModel.profileCellType = .cellTypeTitleSubTitle
        profileEmailModel.profilePlaceHoder = Text.Label.text_ProfileEmail
        profileEmailModel.profileCellDataType = .cellDataTypeEmail
        profileEmailModel.profilePlaceHoderValue = self.user.Email
        self.arrUserProfile.append(profileEmailModel)
        
        let profileMobileModel = ProfileCellDataModel.init()
        profileMobileModel.profileCellType = .cellTypeTitleSubTitle
        profileMobileModel.profilePlaceHoder = Text.Label.text_ProfileMobile
        profileMobileModel.profileCellDataType = .cellDataTypeMobile
        profileMobileModel.profilePlaceHoderValue = self.user.Mobile//Utill.formatLogin(self.user.Mobile)!
        self.arrUserProfile.append(profileMobileModel)
        
        let profileBirthdateModel = ProfileCellDataModel.init()
        profileBirthdateModel.profileCellType = .cellTypeTitleSubTitle
        profileBirthdateModel.profilePlaceHoder = Text.Label.text_ProfileBirthday
        profileBirthdateModel.profileCellDataType = .cellDataTypeBirthday
        profileBirthdateModel.profilePlaceHoderValue = ""
        if let date = self.user.Birthdate.dateFromCustomString(withFormat: "MM/dd/yyyy")
        {
            profileBirthdateModel.profilePlaceHoderValue = date.stringDateForBirthday!
        }
        self.arrUserProfile.append(profileBirthdateModel)
        
        let profileInterestModel = ProfileCellDataModel.init()
        profileInterestModel.profileCellType = .cellTypeLabelButton
        profileInterestModel.profilePlaceHoder = Text.Label.text_ProfileInterest
        profileInterestModel.profilePlaceHoderValue = Text.Label.text_ProfileSelect
        profileInterestModel.profileCellDataType = .cellDataTypeInterest
        self.arrUserProfile.append(profileInterestModel)
        
        print("CategoriesPreference  count! \(self.user.CategoriesPreference.count)")

        for objCat in self.user.CategoriesPreference{
            let profileInterestModel = ProfileCellDataModel.init()
            profileInterestModel.profileCellType = .cellTypeImageLabel
            profileInterestModel.profilePlaceHoder = objCat.SelectedImageURL
            profileInterestModel.profilePlaceHoderValue = objCat.WussupName
            profileInterestModel.profileCellDataType = .cellDataTypeInterest
            self.arrUserProfile.append(profileInterestModel)
        }
        
        let profileFavModel = ProfileCellDataModel.init()
        profileFavModel.profileCellType = .cellFavoriteSwitch
        profileFavModel.profilePlaceHoder = Text.Label.text_ProfileFavorites
        profileFavModel.profilePlaceHoderValue = Text.Label.text_ProfileNotification
        profileFavModel.profileCellDataType = .cellDataTypeNotification
        self.arrUserProfile.append(profileFavModel)
        
        let profileLogoutModel = ProfileCellDataModel.init()
        profileLogoutModel.profileCellType = .cellTypeLabelButton
        profileLogoutModel.profilePlaceHoderValue = Text.Label.text_ProfileLogout
        profileLogoutModel.profileCellDataType = .cellDataTypeLogout
        self.arrUserProfile.append(profileLogoutModel)
        
        self.tableViewProfile.reloadData()
        if self.user.FacebookID != ""{
             self.labelName.text = self.user.Email.count > 0 ? self.user.Email : Text.Label.text_LoggedWithFacebook
        }else {
             self.labelName.text = self.user.UserName.count > 0 ? self.user.UserName : self.user.Email
        }
       
        self.labelCity.text = self.user.City
        
        if self.user.ImageURL != "" {
            self.imageUserProfile.sd_setShowActivityIndicatorView(true)
            self.imageUserProfile.sd_setIndicatorStyle(.white)
            self.imageUserProfile.sd_setImage(with: URL(string:self.user.ImageURL), placeholderImage: #imageLiteral(resourceName: "profilePic"), options: .continueInBackground, completed: nil)
        }
        else {
            self.imageUserProfile.image = #imageLiteral(resourceName: "profilePic")
        }
        self.dicEditedUserProfile[Text.DictKeys.profileEmail] = self.user.Email
        self.dicEditedUserProfile[Text.DictKeys.profileCity] = self.user.City
        self.dicEditedUserProfile[Text.DictKeys.profileUsername] = self.user.UserName.lowercased() == self.user.Email.lowercased() ? "" : self.user.UserName//self.user.UserName
        self.dicEditedUserProfile[Text.DictKeys.profileMobile] = self.user.Mobile//Utill.arrangeUSFormat(strPhone: self.user.Mobile)
        
        if let date = self.user.Birthdate.dateFromCustomString(withFormat: "MM/dd/yyyy")
        {
            self.dicEditedUserProfile[Text.DictKeys.profileBirthday] = date.stringDateForBirthday!
        } else {
            self.dicEditedUserProfile[Text.DictKeys.profileBirthday] = ""
        }
        self.dicEditedUserProfile[Text.DictKeys.profileUserImageUrl] = self.user.ImageURL
        
        let strIDSepratedByCommas = self.user.CategoriesPreference.map { $0.ID }.joined(separator: ",") //joined(separator: ",")
        self.dicEditedUserProfile[Text.DictKeys.profileCategory] = strIDSepratedByCommas
        self.dicEditedUserProfile[Text.DictKeys.profileFavNotification] = self.user.IsAllowedNotification
    }
    
    func isProfileEdited() -> Bool {
        var isProfileEdit : Bool = false
        
        var dic = self.dicEditedUserProfile
        if self.dicEditedUserProfile[Text.DictKeys.profileBirthday] != nil {
            if let strBirthday = self.dicEditedUserProfile[Text.DictKeys.profileBirthday]!.dateFromCustomString(withFormat: "MMMM dd, yyyy")
            {
                dic[Text.DictKeys.profileBirthday] = strBirthday.stringDate
            }
        }
        let userCategory = self.user.CategoriesPreference.map { $0.ID }.joined(separator: ",")
        
        if dic[Text.DictKeys.profileUsername] != self.user.UserName
            || dic[Text.DictKeys.profileCity] != self.user.City
            || dic[Text.DictKeys.profileMobile] != self.user.Mobile
            || dic[Text.DictKeys.profileEmail] != self.user.Email
            || dic[Text.DictKeys.profileBirthday] != self.user.Birthdate
            || dic[Text.DictKeys.profileUserImageUrl] != self.user.ImageURL
            || dic[Text.DictKeys.profileFavNotification] != self.user.IsAllowedNotification
            || dic[Text.DictKeys.profileCategory] != userCategory
        {
            isProfileEdit = true
        }
        return isProfileEdit
    }
    // MARK: - Webservice Methods
    func callWS_GetUserProfile() {
        print("CategoriesPreference  count \(self.user.CategoriesPreference.count)")

        WEB_API.call_api_GetUserProfile()
            { (response, success, message) in
                
                if success {
                    let data = try! JSONSerialization.data(withJSONObject: response?["UserProfile"].dictionaryObject ?? [:], options: [])
                    let user = try! JSONDecoder().decode(WUUser.self, from: data)
                    user.Token = self.user.Token
                    Utill.saveUserModel(user)
                    Utill.printInTOConsole(printData:"response: \(response ?? "")")
                }
                self.user = GlobalShared.user

                self.reloadDataForProfile()
        }
    }
    
    func callWS_EditUserProfile(completionHandler : @escaping (Bool) -> Void) { 
        
        Utill.printInTOConsole(printData:"response: \(self.dicEditedUserProfile)")
        var dic = self.dicEditedUserProfile
        
        if let strBirthday = self.dicEditedUserProfile[Text.DictKeys.profileBirthday]!.dateFromCustomString(withFormat: "MMMM dd, yyyy")
        {
            dic[Text.DictKeys.profileBirthday] = strBirthday.stringDate
        }
        
        
        if self.isProfileEdited()
        {
            //            let mobile = Utill.formatNumber(self.dicEditedUserProfile[Text.DictKeys.profileMobile])
            WEB_API.call_api_EditUserProfile(username           : dic[Text.DictKeys.profileUsername]!,
                                             imageUrl           : dic[Text.DictKeys.profileUserImageUrl]!,
                                             email              : dic[Text.DictKeys.profileEmail]!,
                                             mobile             : dic[Text.DictKeys.profileMobile]!,
                                             birthDate          : dic[Text.DictKeys.profileBirthday]!,
                                             city               : dic[Text.DictKeys.profileCity]!,
                                             allowNotification  : dic[Text.DictKeys.profileFavNotification]!,
                                             postalCode         : "",
                                             categoriesPreference:  GlobalShared.arrayCategories.clone().map { $0.ID }.joined(separator: ","))
            { (response, success, message) in
                let cell = self.tableViewProfile.cellForRow(at: IndexPath(row: 1, section: 0)) as? WUProfileEditDoneTableCell
                if success {
                    let data = try! JSONSerialization.data(withJSONObject: response?["UserProfile"].dictionaryObject ?? [:], options: [])
                    let user = try! JSONDecoder().decode(WUUser.self, from: data)
                    user.Token = self.user.Token
                    Utill.saveUserModel(user)
                    self.user = GlobalShared.user
                    self.reloadDataForProfile()
                    Utill.printInTOConsole(printData:"response: \(response ?? "")")
                    cell?.buttonDone.isSelected = true
                    completionHandler(success)
                } else {
                    cell?.buttonDone.isSelected = false
                    Utill.printInTOConsole(printData:"response: \(response ?? "")")
                    Utill.showAlertView(viewController: self, message: message)
                }
            }
        }
        else {
            self.reloadDataForProfile()
        }
        
    }
    
    private func callWS_LogoutUser(){
        WEB_API.call_api_LogoutUser { (response, success, message) in
//            if success{
//                Utill.logOutAndClearData()
//            } else {
                Utill.logOutAndClearData()
          //  }
        }
    }
    
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
    }
    
    @IBAction func buttonToolBarDoneClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.currentEditingtextField.text = datePicker.date.stringDateForBirthday
        self.dicEditedUserProfile[Text.DictKeys.profileBirthday] = self.currentEditingtextField.text
    }
    
    @IBAction func buttonToolbarCancelClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    // MARK: - Action Methods
    @IBAction func buttonUserProfileAction(_ sender: UIButton) {
        if self.isEditingEnable == true {
            self.view.endEditing(true)
            self.showActionSheetToSelectPhoto()
        }
    }
    
    private func showActionSheetToSelectPhoto() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    private func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let status : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .authorized
            {
                let cameraPickerController = UIImagePickerController()
                cameraPickerController.delegate = self;
                cameraPickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(cameraPickerController, animated: true, completion: nil)
            }
            else if(status == .denied || // denied
                status == .restricted ) // restricted
            {
                Utill.showAlert_GoToSettingCancle_View(viewController: self, message: Text.Message.cameraPermissionMsg, completion: { (bool) in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                })
            }
            else {
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    if status == true
                    {
                        let cameraPickerController = UIImagePickerController()
                        cameraPickerController.delegate = self;
                        cameraPickerController.sourceType = UIImagePickerControllerSourceType.camera
                        self.present(cameraPickerController, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    private func openPhotoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let status : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            if status == .authorized
            {
                let galleryPickerController = UIImagePickerController()
                galleryPickerController.delegate = self;
                galleryPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(galleryPickerController, animated: true, completion: nil)
            }
            else if status == .denied || status == .restricted
            {
                Utill.showAlert_GoToSettingCancle_View(viewController: self, message: Text.Message.photoPermissionMsg, completion: { (bool) in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                })
            }
            else if status == .notDetermined
            {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized
                    {
                        let galleryPickerController = UIImagePickerController()
                        galleryPickerController.delegate = self;
                        galleryPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                        self.present(galleryPickerController, animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    func uploadImageToAWSAndUpdateProfile(image : UIImage , completionHandler completion : @escaping (Bool) -> Void){
        amazonImageManager.uploadImageonS3(image: image) { (success, imageUrl) in
            let cell = self.tableViewProfile.cellForRow(at: IndexPath(row: 1, section: 0)) as? WUProfileEditDoneTableCell
            if success == true{
                self.profileImageToEdit = nil
                Utill.printInTOConsole(printData:"uploaded url : \(imageUrl)")
                self.dicEditedUserProfile[Text.DictKeys.profileUserImageUrl] = imageUrl
                self.callWS_EditUserProfile(completionHandler: { (sucess) in
                    if success == true{
                        cell?.buttonDone.isSelected = true
                        self.manageThankScreenFlowFromProfile()
                        completion(success)
                    }else {
                        cell?.buttonDone.isSelected = false
                    }
                })
            }else{
                cell?.buttonDone.isSelected = false
                Utill.showAlertView(viewController: self, message: Text.Message.imageUploadError)
            }
        }
    }
    
    func uploadImageToAWSAndUpdateProfileWithTabChangeOrLogOut(image : UIImage , completionHandler completion : @escaping (Bool) -> Void){
        amazonImageManager.uploadImageonS3(image: image) { (success, imageUrl) in
            let cell = self.tableViewProfile.cellForRow(at: IndexPath(row: 1, section: 0)) as? WUProfileEditDoneTableCell
            if success == true{
                self.profileImageToEdit = nil
                Utill.printInTOConsole(printData:"uploaded url : \(imageUrl)")
                self.dicEditedUserProfile[Text.DictKeys.profileUserImageUrl] = imageUrl
                self.callWS_EditUserProfile(completionHandler: { (sucess) in
                    if success == true{
                        completion(success)
                        cell?.buttonDone.isSelected = true
                    }else {
                        cell?.buttonDone.isSelected = false
                    }
                })
            }else{
                cell?.buttonDone.isSelected = false
                Utill.showAlertView(viewController: self, message: Text.Message.imageUploadError)
            }
        }
    }
    
    func manageThankScreenFlowFromProfile()
    {
        if UserDefault.bool(forKey: Text.UDKeys.isThankyouProfileViewed) == false {
            UserDefault.set(true, forKey: Text.UDKeys.isThankyouProfileViewed)
            UserDefault.synchronize()
            self.performSegue(withIdentifier: Text.Segue.profileToThankyouVC, sender: nil)
        }else{
            Utill.showAlertView(viewController: self, message: Text.Message.profileUpdatedSuccessfully)
        }
    }
    
    func checkValidation() -> Bool {
        
        if self.dicEditedUserProfile[Text.DictKeys.profileEmail] == "" &&
            self.dicEditedUserProfile[Text.DictKeys.profileMobile] == "" {
            return false
        } else if self.dicEditedUserProfile[Text.DictKeys.profileEmail] != "" && !(self.dicEditedUserProfile[Text.DictKeys.profileEmail]?.isValidEmail)! {
            return false
        } else if self.dicEditedUserProfile[Text.DictKeys.profileMobile] != "" && (self.dicEditedUserProfile[Text.DictKeys.profileMobile]!.count) < 10  {//|| (self.dicEditedUserProfile[Text.DictKeys.profileMobile]!.count) > 15)
            return false
        } else if self.dicEditedUserProfile[Text.DictKeys.profileUsername]?.lowercased() == self.dicEditedUserProfile[Text.DictKeys.profileEmail]?.lowercased(){
            return false
        } else if self.dicEditedUserProfile[Text.DictKeys.profileUsername] == "" {
            return false
        }
        return true
    }
}
//MARK: - PickerController
extension WUProfileViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.profileImageToEdit = pickedImage
            self.imageUserProfile.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableView
extension WUProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let profileDataModel = self.arrUserProfile[indexPath.row]
        
        if profileDataModel.profileCellType == .cellTypeOnlyLabel {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUProfileLabelTableCell()), for: indexPath)as! WUProfileLabelTableCell
            cell.backgroundColor = .DarkGrayColor
            return cell
            
        } else if profileDataModel.profileCellType == .cellTypeEditDone {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUProfileEditDoneTableCell()),
                                                     for: indexPath)as! WUProfileEditDoneTableCell
            
            cell.backgroundColor = .DarkGrayColor
            cell.delegate = self
            if self.isEditingEnable == false {
                cell.buttonDone.isSelected = false
                cell.buttonDone.isHidden = true
                cell.buttonEdit.isSelected = false
            }
            cell.viewSeperatorNormalEditDoneCell.isHidden = false
            return cell
            
        } else if profileDataModel.profileCellType == .cellTypeTitleSubTitle {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUProfileTitleSubTitleTableViewCell()),
                                                     for: indexPath)as! WUProfileTitleSubTitleTableViewCell
            
            print("///profileDataModel.profilePlaceHoder --\( profileDataModel.profilePlaceHoder)")
            cell.backgroundColor = .DarkGrayColor
            cell.labelTitle.text = profileDataModel.profilePlaceHoder
            cell.textFldSubtitle.text = profileDataModel.profilePlaceHoderValue
            cell.textFldSubtitle.isEnabled = false
            
            cell.textFldSubtitle.delegate = self
            cell.textFldSubtitle.tag = indexPath.row
            cell.textFldSubtitle.keyboardType = .default
            cell.textFldSubtitle.returnKeyType = .next
            
            cell.viewSeperatorActiveTop.isHidden = true
            cell.viewSeperatorActiveBottom.isHidden = true
            cell.viewSeperatorNormalTitleSubTitleCell.isHidden = false
            
            // if profileDataModel.profileCellDataType != .cellDataTypeCity {
            cell.textFldSubtitle.isEnabled = self.isEditingEnable
            cell.textFldSubtitle.resignFirstResponder()
            //                if profileDataModel.profileCellDataType == .cellDataTypeBirthday{
            //                    self.pickUpDate(cell.textFldSubtitle)
            //                }
            
            if self.user.FacebookID != ""  &&  profileDataModel.profileCellDataType == .cellDataTypeUserName {
                cell.textFldSubtitle.isEnabled = false
            }
            
            if profileDataModel.profileCellDataType == .cellDataTypeEmail{
                cell.textFldSubtitle.keyboardType = .emailAddress
                cell.textFldSubtitle.returnKeyType = .next
                
            } else if profileDataModel.profileCellDataType == .cellDataTypeMobile{
                cell.textFldSubtitle.text = profileDataModel.profilePlaceHoderValue//Utill.arrangeUSFormat(strPhone: profileDataModel.profilePlaceHoderValue)
                cell.textFldSubtitle.keyboardType = .phonePad
                cell.textFldSubtitle.returnKeyType = .next
            }
            //  }
            return cell
            
        } else if profileDataModel.profileCellType == .cellTypeLabelButton {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUProfileLableButtonTableCell()), for: indexPath)as! WUProfileLableButtonTableCell
            cell.backgroundColor = .DarkGrayColor
            cell.delegate = self
            cell.labelTitle.text = profileDataModel.profilePlaceHoder
            
            cell.viewSeperatorNormalLableButtonCell.isHidden = false
            
            cell.buttonSelect.setAttributedTitle(Utill.getUnderlinedAttributedText(text: profileDataModel.profilePlaceHoderValue), for: .normal)
            if profileDataModel.profileCellDataType != .cellDataTypeLogout{
                cell.buttonSelect.isEnabled = self.isEditingEnable
            }else{
                cell.buttonSelect.isEnabled = true
            }
            return cell
            
        } else if profileDataModel.profileCellType == .cellFavoriteSwitch {
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUProfileFavoriteSwitchTableCell()), for: indexPath)as! WUProfileFavoriteSwitchTableCell
            cell.backgroundColor = .DarkGrayColor
            cell.delegate = self
            cell.labelTitle.text = profileDataModel.profilePlaceHoder
            cell.switchNotification.isOn = (dicEditedUserProfile[Text.DictKeys.profileFavNotification]?.toBool())!//self.venueDetail.UserFavoriteVenueNotificationSettings.IsSendPromotionalAlert.toBool()!
            //            if self.isEditingEnable == false {
            //                cell.switchNotification.isUserInteractionEnabled = self.isEditingEnable
            //            }else {
            //                cell.switchNotification.isUserInteractionEnabled = true
            //            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUProfileImageLabelTableCell()), for: indexPath)as! WUProfileImageLabelTableCell
            cell.backgroundColor = .DarkGrayColor
            cell.labelTitle.text = profileDataModel.profilePlaceHoderValue
            
            cell.imageViewCategory.sd_setShowActivityIndicatorView(true)
            cell.imageViewCategory.sd_setIndicatorStyle(.white)
            cell.imageViewCategory.sd_setImage(with: URL(string:profileDataModel.profilePlaceHoder), placeholderImage:#imageLiteral(resourceName: "placeholder") , options: [SDWebImageOptions.cacheMemoryOnly])
            return cell
        }
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let profileDataModel = self.arrUserProfile[indexPath.row]
//        if profileDataModel.profilePlaceHoderValue == .
//    }
}

//MARK: - EditDone Action
extension WUProfileViewController : WUProfileEditDoneTableCellDelegate {
    
    func profileEditDoneTableCell(cell: WUProfileEditDoneTableCell, didSelectDoneButton button: UIButton) {
        print("Done Button Pressed")
        self.view.endEditing(true)
        
        let profileEmail = self.dicEditedUserProfile[Text.DictKeys.profileEmail]
        let profileMobile = self.dicEditedUserProfile[Text.DictKeys.profileMobile]
        
        if profileEmail == "" && profileMobile == "" {
            self.currentEditingtextField.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Message.pleaseEnterEmailORMobile)
            
        } else if profileEmail != "" && !(profileEmail?.isValidEmail)! {
            self.currentEditingtextField.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Message.pleaseEnterValidEmail)
            
        } else if profileMobile != "" && profileMobile!.count < 10  {
            //|| (self.dicEditedUserProfile[Text.DictKeys.profileMobile]!.count) > 15)
            self.currentEditingtextField.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Label.text_validPhoneNumberDigit)
            
        } else  if self.dicEditedUserProfile[Text.DictKeys.profileUsername]?.lowercased() == profileEmail?.lowercased() {
            self.currentEditingtextField.becomeFirstResponder()
            Utill.showAlertView(viewController: self, message: Text.Label.text_UserNameEmail)
            
//        }
//        else if self.dicEditedUserProfile[Text.DictKeys.profileCity] == self.dicEditedUserProfile[Text.DictKeys.profileEmail]?.lowercased() {
//            self.currentEditingtextField.becomeFirstResponder()
//            Utill.showAlertView(viewController: self, message: Text.Label.text_UserNameEmail)
            
        } else {
            cell.buttonEdit.isSelected = false
            self.isEditingEnable = false
            button.isSelected = true
            if self.profileImageToEdit != nil {
                self.uploadImageToAWSAndUpdateProfile(image: self.profileImageToEdit!) { (sucess) in
                    if sucess == true {
                        button.isHidden = true
                    }else {
                        button.isSelected = false
                    }
                }
            } else {
                self.callWS_EditUserProfile { (sucess) in
                    if sucess == true {
                        button.isHidden = true
                        self.manageThankScreenFlowFromProfile()
                    } else {
                        button.isSelected = false
                    }
                }
            }
        }
    }
    
    func profileEditDoneTableCell(cell: WUProfileEditDoneTableCell, didSelectEditButton button: UIButton) {
        Utill.printInTOConsole(printData:"Edit!")
        if self.isEditingEnable == false{
            cell.buttonDone.isHidden = false
            cell.buttonDone.isSelected = false
            self.isEditingEnable = true
            if self.user.FacebookID == "" {
                if let userCell = self.tableViewProfile.cellForRow(at: IndexPath(row: 2, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        userCell.textFldSubtitle.becomeFirstResponder()
                    }
                }
            }else {
                if let userCell = self.tableViewProfile.cellForRow(at: IndexPath(row: 4, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        userCell.textFldSubtitle.becomeFirstResponder()
                    }
                }
            }
            self.tableViewProfile.reloadData()
        }
        cell.buttonEdit.isSelected = true
    }
}
//MARK: - LogOut / Select Interest Action
extension WUProfileViewController : WUProfileLableButtonTableCellDelegate {
    
    func profileLableButtonTableCell(cell: WUProfileLableButtonTableCell, didSelectButton button: UIButton) {

        let indexpath = self.tableViewProfile.indexPath(for: cell)
        let cellModel = self.arrUserProfile[(indexpath?.row)!]
        
        if cellModel.profileCellDataType == .cellDataTypeInterest {
            self.view.endEditing(true)
            Utill.printInTOConsole(printData:"interest")
            let interestVc = UIStoryboard.loginSignUp.get(WUInterestsViewController.self)
            interestVc?.isFromProfileVC = true
            interestVc?.userSelectedCategory = self.dicEditedUserProfile[Text.DictKeys.profileCategory]!
            self.navigationController?.pushViewController(interestVc!, animated: true)
        }
            
            //        else if cellModel.profileCellDataType == .cellDataTypeNotification {
            //            Utill.printInTOConsole(printData:"notification")
            //            (self.tabBarController as! WUTabbarViewController).selectIndexForTabbar(selectedIndex: .Favorite)
            //            if (self.tabBarController?.selectedViewController as! UINavigationController).viewControllers.last is WUFavoriteHomeViewController{
            //                ((self.tabBarController?.selectedViewController as! UINavigationController).viewControllers.last as! WUFavoriteHomeViewController).isFromProfile = true
            //            }else{
            //                (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
            //                ((self.tabBarController?.selectedViewController as! UINavigationController).viewControllers.last as! WUFavoriteHomeViewController).isFromProfile = true
            //            }
            //
            //            //            NotificationCenter.default.post(name: .interestToProfile, object: strSlectedCatId)
            //        }
        else if cellModel.profileCellDataType == .cellDataTypeLogout {
            
            Utill.printInTOConsole(printData:"logout")
            if (self.profileImageToEdit != nil || self.isProfileEdited() == true) && self.checkValidation() == true {
                Utill.showAlert_YESNO_View(viewController: self, message:(self.profileImageToEdit != nil || self.isProfileEdited() == true) ? Text.Message.logOutWithProfileEdit : Text.Message.logOut) { (action) in
                    if action == true {
                        if self.profileImageToEdit != nil
                        {
                            self.uploadImageToAWSAndUpdateProfileWithTabChangeOrLogOut(image: self.profileImageToEdit!, completionHandler: { (success) in
                                if success == true {
                                    self.callWS_LogoutUser()
                                }
                            })
                        } else {
                            self.callWS_EditUserProfile(completionHandler: { (success) in
                                Utill.printInTOConsole(printData:"In Completion part ")
                                if success == true {
                                    self.callWS_LogoutUser()
                                }
                            })
                        }
                    } else {
                        self.callWS_LogoutUser()
                    }
                }
            } else {
                Utill.showAlert_YESNO_View(viewController: self, message:Text.Message.logOut) { (action) in
                    if action == true{
                        self.callWS_LogoutUser()
                    }
                }
            }
        }
    }
}

//MARK: - Swicth Action
extension WUProfileViewController : WUProfileFavoriteSwitchTableCellDelegate {
    
    func profileFavoriteSwitchTableCell(cell: WUProfileFavoriteSwitchTableCell, valueChange switchToggle: UISwitch)
    {
        let indexpath = self.tableViewProfile.indexPath(for: cell)
        let cellModel = self.arrUserProfile[(indexpath?.row)!]
        if cellModel.profileCellDataType == .cellDataTypeNotification {
            Utill.printInTOConsole(printData:"notification")
            //            cell.switchNotification.isOn = !cell.switchNotification.isOn
            dicEditedUserProfile[Text.DictKeys.profileFavNotification] = switchToggle.isOn ? "True" : "False"
            //            if self.isProfileEdited() && self.checkValidation() == true {
            //                if self.profileImageToEdit != nil
            //                {
            //                    self.uploadImageToAWSAndUpdateProfileWithTabChangeOrLogOut(image: self.profileImageToEdit!, completionHandler: { (success) in
            //                        if success == true {
            //                            self.manageThankScreenFlowFromProfile()
            //                        }
            //                    })
            //                }
            //                else {
            //                    self.callWS_EditUserProfile(completionHandler: { (success) in
            //                        Utill.printInTOConsole(printData:"In Completion part ")
            //                        if success == true {
            //                            self.manageThankScreenFlowFromProfile()
            //                        }
            //                    })
            //                }
            //            }else { //dicEditedUserProfile[Text.DictKeys.profileCategory]!
            
            let strIDSepratedByCommas = self.user.CategoriesPreference.map { $0.ID }.joined(separator: ",")
            
            WEB_API.call_api_EditUserProfile(username: self.user.UserName,
                                             imageUrl: self.user.ImageURL,
                                             email: self.user.Email,
                                             mobile: self.user.Mobile,
                                             birthDate: self.user.Birthdate,
                                             city: self.user.City,
                                             allowNotification:dicEditedUserProfile[Text.DictKeys.profileFavNotification]!,
                                             postalCode: "",
                                             categoriesPreference:  GlobalShared.arrayCategories.clone().map { $0.ID }.joined(separator: ","))
            { (response, success, message) in
                if success {
                    let data = try! JSONSerialization.data(withJSONObject: response?["UserProfile"].dictionaryObject ?? [:], options: [])
                    let user = try! JSONDecoder().decode(WUUser.self, from: data)
                    user.Token = self.user.Token
                    Utill.saveUserModel(user)
                    //                        self.user = GlobalShared.user
                    //                        self.reloadDataForProfile()
                    Utill.printInTOConsole(printData:"response: \(response ?? "")")
                    //                        self.manageThankScreenFlowFromProfile()
                } else {
                    Utill.showAlertView(viewController: self, message: message)
                }
            }
            //            }
        }
    }
}

//MARK: - TextField
extension WUProfileViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let profileDataModel = self.arrUserProfile[textField.tag]
        
        if profileDataModel.profileCellDataType == .cellDataTypeUserName {
            if let cellEditDone = self.tableViewProfile.cellForRow(at: IndexPath(row: 1, section: 0)) as? WUProfileEditDoneTableCell
            {
                cellEditDone.viewSeperatorNormalEditDoneCell.isHidden = true

            }
            if let cellTitleUserName = self.tableViewProfile.cellForRow(at: IndexPath(row: 2, section: 0)) as? WUProfileTitleSubTitleTableViewCell
            {
                cellTitleUserName.viewSeperatorActiveTop.isHidden               = false
                cellTitleUserName.viewSeperatorActiveBottom.isHidden            = false
                cellTitleUserName.viewSeperatorNormalTitleSubTitleCell.isHidden = true
            }
        }else if profileDataModel.profileCellDataType == .cellDataTypeEmail{
            if let cellTitleCity = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleCity.viewSeperatorActiveTop.isHidden               = true
                cellTitleCity.viewSeperatorActiveBottom.isHidden            = true
                cellTitleCity.viewSeperatorNormalTitleSubTitleCell.isHidden = true
            }
            
            if let cellTitleEmail = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleEmail.viewSeperatorActiveTop.isHidden                  = false
                cellTitleEmail.viewSeperatorActiveBottom.isHidden               = false
                cellTitleEmail.viewSeperatorNormalTitleSubTitleCell.isHidden    = true
            }
           
        }else if profileDataModel.profileCellDataType == .cellDataTypeMobile{
            if let cellTitleEmail = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleEmail.viewSeperatorActiveTop.isHidden                  = true
                cellTitleEmail.viewSeperatorActiveBottom.isHidden               = true
                cellTitleEmail.viewSeperatorNormalTitleSubTitleCell.isHidden    = true
            }
            if let cellTitleMobile = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleMobile.viewSeperatorActiveTop.isHidden                 = false
                cellTitleMobile.viewSeperatorActiveBottom.isHidden              = false
                cellTitleMobile.viewSeperatorNormalTitleSubTitleCell.isHidden   = true
            }
            
        }else if profileDataModel.profileCellDataType == .cellDataTypeBirthday{
            self.pickUpDate(textField)
            if let cellTitleMobile = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleMobile.viewSeperatorActiveTop.isHidden                 = true
                cellTitleMobile.viewSeperatorActiveBottom.isHidden              = true
                cellTitleMobile.viewSeperatorNormalTitleSubTitleCell.isHidden   = true
            }
            if let cellTitleBirthDate = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleBirthDate.viewSeperatorActiveTop.isHidden              = false
                cellTitleBirthDate.viewSeperatorActiveBottom.isHidden           = false
                cellTitleBirthDate.viewSeperatorNormalTitleSubTitleCell.isHidden = true
            }
        }
        
        self.currentEditingtextField = textField
        if let cell = self.tableViewProfile.cellForRow(at: IndexPath(row: (textField.tag), section: 0)) as? WUProfileTitleSubTitleTableViewCell
        {
            cell.backgroundColor = .ProfileCellSelectedColor
        }
    }
    // edit name
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textRange = Range(range, in: textField.text!) {
            let finalText = textField.text!.replacingCharacters(in: textRange,with: string)
            let cellModel = self.arrUserProfile[(textField.tag)]
            
            if cellModel.profileCellDataType == .cellDataTypeUserName {
                if (string == " ") {
                    return false
                }
                self.dicEditedUserProfile[Text.DictKeys.profileUsername] = finalText//textField.text
                
            } else if cellModel.profileCellDataType == .cellDataTypeEmail {
                if (textField.text?.count)! >= 50 {
                    if range.length == 0 {
                        return false
                    }
                }
                self.dicEditedUserProfile[Text.DictKeys.profileEmail] = finalText//textField.text
                
            } else if cellModel.profileCellDataType == .cellDataTypeCity {
                if (string == " ") {
                    return false
                }
                self.dicEditedUserProfile[Text.DictKeys.profileCity] = finalText//textField.text
                
            } else if cellModel.profileCellDataType == .cellDataTypeMobile {
                
                //mask (###) ### - ####
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
                self.dicEditedUserProfile[Text.DictKeys.profileMobile] = finalText
                
                
                //OLD mask # (###) ### - ####

//                if length >= 11 {
//                    if range.length == 0 {
//                        return false
//                    }
//                }
//                if length == 4 {
//                    var num = Utill.formatLogin(textField.text)
//                    let first = num?.first
//                    num?.removeFirst()
//
//                    textField.text = String(first!) + " (\(num ?? "")) "
//
//                    if range.length > 0 {
//                        textField.text = String(first!) + "\((num as NSString?)?.substring(to: 3) ?? "")"
//                    }
//                } else if length == 7 {
//                    var num = Utill.formatLogin(textField.text)
//                    let first = num?.first
//                    num?.removeFirst()
//
//                    textField.text = String(first!) + " (\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "") - "
//
//                    if range.length > 0 {
//                        textField.text = String(first!) + " (\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "")"
//                    }
//                }mvnbn
//
//                self.dicEditedUserProfile[Text.DictKeys.profileMobile] = finalText

                
                
                // OLD
                
//                let length = Int(Utill.getLength(textField.text))
//
//                if length >= 10 {
//                    if range.length == 0 {
//                        return false
//                    }
//                }
//
//                if length == 3 {
//                    let num = Utill.formatNumber(textField.text)
//                    textField.text = "(\(num ?? "")) "
//
//                    if range.length > 0 {
//                        textField.text = "\((num as NSString?)?.substring(to: 3) ?? "")"
//                    }
//                }else if length == 6 {
//                    let num = Utill.formatNumber(textField.text)
//                    textField.text = "(\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "") - "
//
//                    if range.length > 0 {
//                        textField.text = "(\((num as NSString?)?.substring(to: 3) ?? "")) \((num as NSString?)?.substring(from: 3) ?? "")"
//                    }
//                }
//                self.dicEditedUserProfile[Text.DictKeys.profileMobile] = Utill.formatNumber(finalText)
                
            } else if cellModel.profileCellDataType == .cellDataTypeBirthday {
                self.dicEditedUserProfile[Text.DictKeys.profileBirthday] = finalText//textField.text
            }
            cellModel.profilePlaceHoderValue = finalText
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let profileDataModel = self.arrUserProfile[textField.tag]
        print("///11textField.tag - \(textField.tag)")

        if profileDataModel.profileCellDataType == .cellDataTypeUserName {
            if let cellEditDone = self.tableViewProfile.cellForRow(at: IndexPath(row: 1, section: 0)) as? WUProfileEditDoneTableCell
            {
                cellEditDone.viewSeperatorNormalEditDoneCell.isHidden = false
            }
            if let cellTitleSubTitle = self.tableViewProfile.cellForRow(at: IndexPath(row: 2, section: 0)) as? WUProfileTitleSubTitleTableViewCell
            {
                cellTitleSubTitle.viewSeperatorActiveTop.isHidden               = true
                cellTitleSubTitle.viewSeperatorActiveBottom.isHidden            = true
                cellTitleSubTitle.viewSeperatorNormalTitleSubTitleCell.isHidden = false
            }

        } else if profileDataModel.profileCellDataType == .cellDataTypeCity {
            if let cellEditDone = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileEditDoneTableCell
            {
                cellEditDone.viewSeperatorNormalEditDoneCell.isHidden = false
            }
            if let cellTitleSubTitle = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell
            {
                cellTitleSubTitle.viewSeperatorActiveTop.isHidden               = true
                cellTitleSubTitle.viewSeperatorActiveBottom.isHidden            = true
                cellTitleSubTitle.viewSeperatorNormalTitleSubTitleCell.isHidden = false
            }
            
        }  else if profileDataModel.profileCellDataType == .cellDataTypeEmail{

            if let cellTitleCity = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleCity.viewSeperatorActiveTop.isHidden                   = true
                cellTitleCity.viewSeperatorActiveBottom.isHidden                = true
                cellTitleCity.viewSeperatorNormalTitleSubTitleCell.isHidden     = false
            }
            if let cellTitleEmail = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleEmail.viewSeperatorActiveTop.isHidden                  = true
                cellTitleEmail.viewSeperatorActiveBottom.isHidden               = true
                cellTitleEmail.viewSeperatorNormalTitleSubTitleCell.isHidden    = false
            }
            
        } else if profileDataModel.profileCellDataType == .cellDataTypeMobile{
            if let cellTitleEmail = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleEmail.viewSeperatorActiveTop.isHidden                  = true
                cellTitleEmail.viewSeperatorActiveBottom.isHidden               = true
                cellTitleEmail.viewSeperatorNormalTitleSubTitleCell.isHidden    = false
                
            }
            if let cellTitleMobile = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleMobile.viewSeperatorActiveTop.isHidden                 = true
                cellTitleMobile.viewSeperatorActiveBottom.isHidden              = true
                cellTitleMobile.viewSeperatorNormalTitleSubTitleCell.isHidden   = false
            }
            
        } else if profileDataModel.profileCellDataType == .cellDataTypeBirthday{
            
            if let cellTitleMobile = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag-1, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleMobile.viewSeperatorActiveTop.isHidden                 = true
                cellTitleMobile.viewSeperatorActiveBottom.isHidden              = true
                cellTitleMobile.viewSeperatorNormalTitleSubTitleCell.isHidden   = false
                
            }
            if let cellTitleBirthDate = self.tableViewProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? WUProfileTitleSubTitleTableViewCell{
                cellTitleBirthDate.viewSeperatorActiveTop.isHidden                  = true
                cellTitleBirthDate.viewSeperatorActiveBottom.isHidden               = true
                cellTitleBirthDate.viewSeperatorNormalTitleSubTitleCell.isHidden    = false
            }
        }
        print("///22textField.tag - \(textField.tag)")
        if let cell = self.tableViewProfile.cellForRow(at: IndexPath(row: (textField.tag), section: 0)) as? WUProfileTitleSubTitleTableViewCell {
            cell.backgroundColor = .DarkGrayColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag < self.arrUserProfile.count - 1 {
            textField.resignFirstResponder()
            if self.arrUserProfile[(textField.tag)].profileCellDataType == .cellDataTypeUserName {
                self.tableViewProfile.viewWithTag(textField.tag + 2)?.becomeFirstResponder()
            }else {
                self.tableViewProfile.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
            }
        }else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}

