//
//  WUUtill.swift
//  Wussup
//
//  Created by MAC26 on 16/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import AVFoundation
import SDWebImage
import PhotosUI
import WebKit
import AWSCore
import EventKitUI
// import FBSDKLoginKit
// import FBSDKCoreKit

class WUUtill: NSObject {
    
    
    class func compareTwoDateForVesionUpdate(date : Date)-> Bool {
        let units  = Set<Calendar.Component>([.second, .minute, .hour, .day])
        let calendar = Calendar.current
        
        let components = calendar.dateComponents(units, from: date, to: Date())
        
       if (components.day! > 0) {
            return true
        }else {
            return false
        }
    }
    
    class func formatNumber(_ mobileNumber: String?) -> String? {
        var mobileNumber = mobileNumber
        mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
        
        print("Formate :: \(mobileNumber ?? "")")
        
        let length: Int = mobileNumber?.count ?? 0
//        if length > 10 {
//            mobileNumber = (mobileNumber as NSString?)?.substring(from: length - 10)
//            print("\(mobileNumber ?? "")")
//        }
        return mobileNumber
    }
//
//    class func displaymobileWithFormate(_ mobileNumber : String) -> String {
//        let length = Int(Utill.getLength(mobileNumber))
//        var mobileNumber = mobileNumber
//        mobileNumber.insert("(", at: 0)
//
//
//
//        return mobileNumber
//    }
    
    class func arrangeUSFormat(strPhone : String)-> String {
        var strUpdated = strPhone
        
        if strPhone.count > 11 {
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 10))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 11))
        } else if strPhone.count >= 6 && strPhone.count <= 11{
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 10))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 11))
        }else if strPhone.count >= 4 && strPhone.count <= 5{
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
//            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
        }else if strPhone.count >= 1 && strPhone.count == 3{
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
//            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
            //            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
        }
        return strUpdated
    }
    

    class func getLength(_ mobileNumber: String?) -> Int {
        var mobileNumber = mobileNumber
        mobileNumber = mobileNumber?.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "+", with: "")
        
        let length: Int = mobileNumber?.count ?? 0
        
        return length
    }

    
    //MARK: - Alerts
    
    class func showAlert_GoToSettingCancle_ViewOnWindow(title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_GoToSetting, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        let alertNOAction = UIAlertAction.init(title: Text.Label.text_Cancel, style: .default, handler: { (action : UIAlertAction) in
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertNOAction)
        alertMessage.addAction(alertYESAction)
        
        
        DispatchQueue.main.async {
             AppDel.window?.rootViewController?.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    
    class func showAlert_GoToSettingCancle_View(viewController: UIViewController,title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_GoToSetting, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        let alertNOAction = UIAlertAction.init(title: Text.Label.text_Cancel, style: .default, handler: { (action : UIAlertAction) in
            
//            completion(false)
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertNOAction)
        alertMessage.addAction(alertYESAction)
        
        
        DispatchQueue.main.async {
            viewController.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    class func showAlert_UpadteORCancle_ViewOnWindow(title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertUpdateLaterAction = UIAlertAction.init(title: Text.Label.text_UpdateLater, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        let alertUpdateNowAction = UIAlertAction.init(title: Text.Label.text_UpdateNow, style: .default, handler: { (action : UIAlertAction) in
            completion(false)
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertUpdateNowAction)
        alertMessage.addAction(alertUpdateLaterAction)
        
        
        DispatchQueue.main.async {
            AppDel.window?.rootViewController?.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    class func showAlert_UpadteOnWindow(title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertUpdateNowAction = UIAlertAction.init(title: Text.Label.text_UpdateNow, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertUpdateNowAction)
        DispatchQueue.main.async {
            AppDel.window?.rootViewController?.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    
    class func showAlert_YESNO_View(viewController: UIViewController,title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_Yes, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        let alertNOAction = UIAlertAction.init(title: Text.Label.text_No, style: .default, handler: { (action : UIAlertAction) in
            
            completion(false)
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertNOAction)
        alertMessage.addAction(alertYESAction)
        
        
        DispatchQueue.main.async {
            viewController.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    class func showAlert_OKCancle_View(viewController: UIViewController,title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_Ok, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        let alertNOAction = UIAlertAction.init(title: Text.Label.text_Cancel, style: .default, handler: { (action : UIAlertAction) in
            
//            completion(false)
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertNOAction)
        alertMessage.addAction(alertYESAction)
        
        
        DispatchQueue.main.async {
            viewController.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    class func showAlert_OKCancle_ViewForTabManage(viewController: UIViewController,title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_Ok, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        let alertNOAction = UIAlertAction.init(title: Text.Label.text_Cancel, style: .default, handler: { (action : UIAlertAction) in
                        completion(false)
            alertMessage.dismiss(animated: true, completion: nil)
        })
        
        alertMessage.addAction(alertNOAction)
        alertMessage.addAction(alertYESAction)
        
        
        DispatchQueue.main.async {
            viewController.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    
    
    class func showAlert_OK_ViewForTabManage(viewController: UIViewController,title : String = AppName,message : String, completion: @escaping (_ result: Bool) -> Void){
        
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_Ok, style: .default, handler: { (action : UIAlertAction) in
            completion(true)
            alertMessage.dismiss(animated: true, completion:nil)
        })
        alertMessage.addAction(alertYESAction)
        
        DispatchQueue.main.async {
            viewController.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    class func showAlert(withMessage message:String, withActions actions: UIAlertAction...) {
        let alert = UIAlertController(title: AppName, message: message, preferredStyle: .alert)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: Text.Label.text_Ok, style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        AppDel.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }

    class func showAlert(viewController: UIViewController,title : String = AppName,withMessage message:String, withActions actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: Text.Label.text_Ok, style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }

        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertView(viewController: UIViewController,title : String = AppName,message : String){
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_Ok, style: .default, handler: { (action : UIAlertAction) in
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        alertMessage.addAction(alertYESAction)
        viewController.present(alertMessage, animated: true, completion: nil)
    }
    
    class func showAlertViewOnWindow(title : String = AppName,message : String){
        let alertMessage = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let alertYESAction = UIAlertAction.init(title: Text.Label.text_Ok, style: .default, handler: { (action : UIAlertAction) in
            alertMessage.dismiss(animated: true, completion:nil)
        })
        
        alertMessage.addAction(alertYESAction)
        AppDel.window?.rootViewController?.present(alertMessage, animated: true, completion: nil)
    }
    
    //MARK: - IQKeyboard manager
    class func enableKeyboardManagement() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().preventShowingBottomBlankSpace = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = CGFloat(0.0)
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = false

    }
    class func removeKeyBoardManagement(){
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
//        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().preventShowingBottomBlankSpace = false
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = CGFloat(0.0)
        IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = false
    }

    //MARK: - TextField methods
    class func setPlaceHolderTextAndColor(textfield : UITextField ,placeHolderString : String , placeHolderTextColor : UIColor = .red){
        textfield.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes: [NSAttributedStringKey.foregroundColor : placeHolderTextColor])
    }
    
    class func getUnderlinedAttributedText(text : String, textColor : UIColor = .GreenColor) -> NSAttributedString{
        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor : textColor, NSAttributedStringKey.underlineStyle : 1, NSAttributedStringKey.font :UIFont.ProximaNovaRegular(16.0.propotional) ])
    }
    
    
  
    
    //MARK: -Progress HUD
    class func showProgressHud(){
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    class func hideProgressHud(){
        SVProgressHUD.hide()
    }
    
    
    //MARK: - Utillity
    
    class func initialApplicationSetup(){
        GlobalShared.user = self.getUserModel()
        Utill.enableKeyboardManagement()
    }
    
    class func getClassNameFor(classType : Any) -> String {
        let typeOfClass = type(of: classType)
        return String(describing: typeOfClass)
    }
    
    
    //HomeAds model
    
    
    class func getHomeBannerModel() -> HomeBanner?{
        let decoded  = UserDefaults.standard.object(forKey: Text.UDKeys.HomeBanner) as? Data
        if decoded != nil {
            let decode = JSONDecoder()
            do {
                let banner = try decode.decode(HomeBanner.self, from: decoded!) as HomeBanner
                return banner
            }catch{
                Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    class func saveHomeBannerModel(_ value : HomeBanner){
        let encode = JSONEncoder()
        do {
            let en = try encode.encode(value)
            UserDefaults.standard.set(en, forKey: Text.UDKeys.HomeBanner)
            UserDefaults.standard.synchronize()
            GlobalShared.homeBanner = value
        }catch{
            Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
        }
    }
    
    class func removeHomeBannerModel(){
        UserDefaults.standard.removeObject(forKey: Text.UDKeys.HomeBanner)
        UserDefaults.standard.synchronize()
        GlobalShared.homeBanner = []
    }
    
    //User model
 
    
    class func getUserModel() -> User?{
        let decoded  = UserDefaults.standard.object(forKey: Text.UDKeys.User) as? Data
        if decoded != nil {
            let decode = JSONDecoder()
            do {
                let user = try decode.decode(User.self, from: decoded!) as User
                return user
            }catch{
                Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    class func saveUserModel(_ value : User){
        let encode = JSONEncoder()
        do {
            let en = try encode.encode(value)
            UserDefaults.standard.set(en, forKey: Text.UDKeys.User)
            UserDefaults.standard.synchronize()
            GlobalShared.user = value
        }catch{
            Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
        }
    }
    
    class func removeUserModel(){
        UserDefaults.standard.removeObject(forKey: Text.UDKeys.User)
        UserDefaults.standard.synchronize()
        GlobalShared.user = nil
    }
    
    class func logOutAndClearData()
    {
//        let loginManager = FBSDKLoginManager()
//        loginManager.logOut()
        Utill.removeUserModel()
        Utill.removeHomeBannerModel()
        if UserDefault.bool(forKey: Text.UDKeys.isFromSignUp) == true {
            UserDefault.set(false, forKey: Text.UDKeys.isFromSignUp)
            UserDefault.set(false, forKey: Text.UDKeys.isCreateProfileViewed)
            UserDefault.set(false, forKey: Text.UDKeys.isThankyouProfileViewed)
            UserDefault.synchronize()
        }
        if AppDel.tabbar != nil
        {
            self.goToWelComeScreen(viewController: AppDel.tabbar!)
        }
    }
    
    class func goToWelComeScreen(viewController : UIViewController){
        if viewController.navigationController != nil
        {
            for controller in viewController.navigationController!.viewControllers as Array {
                if controller.isKind(of: WUWelComeViewController.self) {
                    viewController.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }

    class func goToLivecamProfile(viewController : UIViewController,withLivecamM livecamM : WUVenueLiveCams)
    {
        if let vc : WULiveCamProfileViewController = UIStoryboard.liveCam.get(WULiveCamProfileViewController.self){
            vc.hidesBottomBarWhenPushed = true
            vc.liveCamVenue = livecamM
            if (Utill.getHomeBannerModel()?.count)! > 1{
                vc.arrayBannerList = (Utill.getHomeBannerModel()?.repeated(count: sliderRepeatCount))!
            }else {
                vc.arrayBannerList = Utill.getHomeBannerModel()!
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    class func goToClaimBussinessScreenWithVenue(viewController : UIViewController , venue : Any) {
//        self.verticalContentOffset  = self.tableViewHome.contentOffset.y
        if let vc = UIStoryboard.home.get(WUClaimABusinessDetailViewController.self){//get(WUClaimABusinessPromptViewController.self){
            vc.venue = venue
            vc.hidesBottomBarWhenPushed = true
           viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    class func getMapUrl(pinImageUrl : String, latitute : String, longtitude : String, size : CGSize = CGSize(width: 192, height: 195)) -> String{
        var pinUrl = ""
        if URL(string: pinImageUrl) != nil {
            pinUrl = pinImageUrl
        }
        else {
            pinUrl = pinImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
//        return "http://maps.googleapis.com/maps/api/staticmap?zoom=17&size=\(Int(size.width))x\(Int(size.height))&markers=icon:\(pinUrl ?? "")|\(latitute),\(longtitude)"
        
        return "http://maps.googleapis.com/maps/api/staticmap?zoom=17&size=\(Int(size.width))x\(Int(size.height))&markers=icon:\(pinUrl)|\(latitute),\(longtitude)&key=\(GOOGLE_MAP_API_KEY)"
    }
    
    
    //get bolded text
    class func filterAndModifyTextAttributes(searchStringCharacters: String, completeStringWithAttributedText: String) -> NSMutableAttributedString {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: completeStringWithAttributedText)
        let pattern = searchStringCharacters.lowercased()
        let range: NSRange = NSMakeRange(0, completeStringWithAttributedText.count)
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            regex.enumerateMatches(in: completeStringWithAttributedText.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) {
                (textCheckingResult, matchingFlags, stop) in
                let subRange = textCheckingResult?.range
                let attributes : [NSAttributedStringKey : Any] = [.font : UIFont.boldSystemFont(ofSize: 20),.foregroundColor: UIColor.black ]
                attributedString.addAttributes(attributes, range: subRange!)
            }
        }catch{
            Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
        }
        return attributedString
    }
    
    
    class func findHeightForText(text : String,havingWidth widthValue:CGFloat ,andFont font:UIFont) -> CGFloat
    {
        let strText : NSString = text as NSString
        var size : CGSize = CGSize.zero
        if strText.length > 0{
            let frame : CGRect = strText.boundingRect(with: CGSize(width: widthValue, height: CGFloat.greatestFiniteMagnitude) ,options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
            size = frame.size
        }
        return size.height + 5.0
    }
    //Get Current Visible Controller
  class  func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }

    
    class func getThumbnailFrom(path: URL?, withCompletionHandler completion:@escaping ((UIImage)-> Void)){
        var thumbnail = #imageLiteral(resourceName: "placeholder")

        if let url = path{
            DispatchQueue.global(qos: .background).async {
                do{
                     Utill.printInTOConsole(printData:"This is run on the background queue")
                    let asset = AVURLAsset(url: url , options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(1,30), actualTime: nil)
                    thumbnail = UIImage(cgImage: cgImage)
                    completion(thumbnail)
                }catch let error{
                     Utill.printInTOConsole(printData:"Error : \(error)")
                }
            }
        }
        completion(thumbnail)

    }
    
    class func getImageFrom(path: String, withCompletionHandler completion:@escaping ((UIImage)-> Void)){
//        DispatchQueue.global(qos: .background).async {
//            do{
//                let data = try? Data(contentsOf: URL(string:path)!)
//                let image = UIImage(data: data!)
//                completion(image!)
//            }catch{
//            }
//        }
        
        let image = SDImageCache.shared.imageFromDiskCache(forKey: path)
        if (image == nil) {
            let manager : SDWebImageManager = SDWebImageManager.shared
//            manager.imageDownloader?.downloadImage(with: URL(string :path), options: SDWebImageDownloaderOptions(rawValue: 0), progress: nil, completed: { (imageV, Data, errorV, success, strURL) in
//                if success
//                {
//                    if (strURL != nil)
//                    {
//                        if let url = URL(string :strURL!)
//                        {
//                            manager.saveImage(toCache: imageV, for: url)
//                            completion(imageV!)
//                        }
//                    }
//                }
//            })
            
            
        }
        else
        {
            completion(image!)
        }
    }
    
    class func getPHObjectPlaceHolder(videoURL: URL?,objectImage:UIImage?,isMediaTypeImage:Bool,CompletionHandler:@escaping  (_ success:Bool,_ objectPlaceHolder:PHObjectPlaceholder?) -> Void){
        if isMediaTypeImage{ //Image
            guard objectImage != nil else{
                CompletionHandler(false,nil)
                return
            }
            let status : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined
            {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized
                    {
                        var imagePlaceHolderAsset:PHObjectPlaceholder?
                        var requestImageAsset:PHAssetChangeRequest?
                        PHPhotoLibrary.shared().performChanges({
                            requestImageAsset = PHAssetChangeRequest.creationRequestForAsset(from: objectImage!)
                            imagePlaceHolderAsset = requestImageAsset?.placeholderForCreatedAsset
                        }, completionHandler: { (success:Bool, error:Error?) in
                            if success{
                                CompletionHandler(true,imagePlaceHolderAsset)
                            }else{
                                CompletionHandler(false,nil)
                            }
                        })
                    }
                }
            }
            else if status == .authorized
            {
                var imagePlaceHolderAsset:PHObjectPlaceholder?
                var requestImageAsset:PHAssetChangeRequest?
                PHPhotoLibrary.shared().performChanges({
                    requestImageAsset = PHAssetChangeRequest.creationRequestForAsset(from: objectImage!)
                    imagePlaceHolderAsset = requestImageAsset?.placeholderForCreatedAsset
                }, completionHandler: { (success:Bool, error:Error?) in
                    if success{
                        CompletionHandler(true,imagePlaceHolderAsset)
                    }else{
                        CompletionHandler(false,nil)
                    }
                })
            }
            else {
                CompletionHandler(false,nil)
            }
          
        }else{ //Video
            guard videoURL != nil else{
                CompletionHandler(false,nil)
                return
            }
            var videoPlaceHolderAsset:PHObjectPlaceholder?
            var requestVideoAsset:PHAssetChangeRequest?
            PHPhotoLibrary.shared().performChanges({
                requestVideoAsset = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL!)
                videoPlaceHolderAsset = requestVideoAsset?.placeholderForCreatedAsset
            }, completionHandler: { (success:Bool, error:Error?) in
                if success{
                    CompletionHandler(true,videoPlaceHolderAsset)
                }else{
                    CompletionHandler(false,nil)
                }
            })
        }
    }
    
    //MARK:- Method for draw line
    class func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.5
        
        view.layer.addSublayer(shapeLayer)
    }
    
    // TimeZone in UTC
    class func getTimeZoneOffsetInMinutes() -> String {
        let seconds = TimeZone.current.secondsFromGMT()
        let minutes = (seconds/60)
        return String(format: "%+.2d",minutes)
    }
    
  //  MARK: manageGoToTopButton // UIScreen.main.bounds.height
    class func manageGoToTopButton(scrollView : UIScrollView , view : UIView , buttonGoToTop : UIButton ,scrollHeight : CGFloat = 0){
        if scrollView.contentOffset.y > scrollHeight{
            view.bringSubview(toFront: buttonGoToTop)
            buttonGoToTop.isHidden = false
            buttonGoToTop.alpha = 1.0
//            UIView.animate(withDuration: 0.3, animations: {
//                view.layoutIfNeeded()
//            })
        }else{
            UIView.animate(withDuration: 0.3, animations:{
                buttonGoToTop.alpha = 0.0
            }, completion: { (isBool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    buttonGoToTop.isHidden = true
                    view.sendSubview(toBack: buttonGoToTop)
                })
            })
        }
    }
    
    class func loadBeeGif(imageView : UIImageView){
        let gif = UIImage.gifImageWithName("BeeAnimation")
        imageView.image = gif
    }
    
    class func loadBeeAnimationForView(view : UIView){
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        var webView: WKWebView!
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.isOpaque = false
        webView.tag = beeAnimationWebViewTag
        webView.backgroundColor = UIColor.clear
        webView.isUserInteractionEnabled = false
        webView.load(URLRequest(url: URL(string: Bee_URL)!))
        view.addSubview(webView)
    }
    
    class func removeBeeAnimationForView(view : UIView){
        for vw in view.subviews{
            if vw is WKWebView{
                if vw.tag == beeAnimationWebViewTag{
                    vw.removeFromSuperview()
                    return
                }
            }
        }
    }
    
    class func hideBeeAnimation(isHide : Bool , inView view : UIView){
        var webView: WKWebView?

        for vw in view.subviews{
            if vw is WKWebView{
                if vw.tag == beeAnimationWebViewTag{
                    webView = vw as? WKWebView
                    break
                }
            }
        }
        if webView != nil {
            if isHide == true{
               webView?.isHidden = true
            }else{
                webView?.isHidden = false
                view.bringSubview(toFront: webView!)
            }
        }
    }
    
   class func setAttributedStringForAutopurchase(str1: String!,str2 : String! , color : UIColor , fontSize : Double) -> NSMutableAttributedString!{
        let attrRegular : [ NSAttributedStringKey : Any ]  = [.font : UIFont.ProximaNovaRegular(fontSize.propotional), .foregroundColor : color]
        let attrBold : [ NSAttributedStringKey : Any ] =  [.font : UIFont.ProximaNovaBold(fontSize.propotional) , .foregroundColor : color]
        
        let attrStringRegular : NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: attrRegular)
        let attrStringBold : NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: attrBold)
        attrStringRegular.append(attrStringBold)
        return attrStringRegular
    }
    
    
    class func setAttributedStringNormal(mainString : String!, str1: String! = "" ,str2 : String! , color : UIColor , fontSize : Double) -> NSMutableAttributedString!{
       
        let attrBold : [ NSAttributedStringKey : Any ] =  [.font : UIFont.ProximaNovaBold(fontSize.propotional) , .foregroundColor : color]
        
//        let attrStringBold : NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: attrBold)
       
        let strTitle = mainString
        let termTitle:NSMutableAttributedString = NSMutableAttributedString(string: strTitle!,attributes:[NSAttributedStringKey.font:UIFont.ProximaNovaRegular(fontSize.propotional),NSAttributedStringKey.foregroundColor: color])
//        let substringRange = strTitle?.range(of:str2)!
//        let nsRange = NSRange()
//        let rangeOfTerms = mainString.range(of: str2)
//        termTitle.addAttributes(attrBold, range: NSRangeFromString(rangeOfTerms))
        return termTitle
    }
    
    
    
    
    class func getAmazonUrlForImage(name : String) -> String{
        return "https://s3.amazonaws.com/\(AMAZON_S3_BUCKET_NAME)/\(name)"
    }
    
    class func setupAmazonImageUploding() {
        
        /*--- Amazon Key and Secret ---*/
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: AMAZON_S3_ACCESSKEY, secretKey: AMAZON_S3_ACCESS_SECRETKEY)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    class func setAttributedStringForNotificationButton(str1: String!,str2 : String! , str1Color : UIColor) -> NSMutableAttributedString!{
        let attrStr1Color : [ NSAttributedStringKey : Any ]  = [.font : UIFont.ProximaNovaMedium(17.0.propotional), .foregroundColor : str1Color]
        let attrStr2Color : [ NSAttributedStringKey : Any ] =  [.font : UIFont.ProximaNovaMedium(17.0.propotional), .foregroundColor : UIColor.black]
        
        let attrStringRegular : NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: attrStr1Color)
        let attrStringBold : NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: attrStr2Color)
        
        attrStringRegular.append(attrStringBold)
        
        return attrStringRegular
    }
    
    class func setAttributedStringWithUnderLine(str1: String! , color : UIColor , font : UIFont = UIFont.ProximaNovaRegular(16.0.propotional)! ) -> NSMutableAttributedString!{
        let attrStr1Under : [ NSAttributedStringKey : Any ]  = [.font : font, .foregroundColor : color, .underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        
        let attrStringRegular : NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: attrStr1Under)
        
        return attrStringRegular
    }
    
    class func saveEvent(inCalendar eventCalendarModel: WUMyEventList, isdelete isDelete: Bool, withViewController vc : UIViewController) {
        
        var arrCalenderEvent = self.getEventFromCalendar()
        if arrCalenderEvent == nil {
            arrCalenderEvent = [WUMyEventList]()
        }

        var arrCalenderEventName: [WUMyEventList] = []
        if arrCalenderEvent!.count > 0
        {
            arrCalenderEventName = arrCalenderEvent!.filter({$0.UserID_ResultKey == eventCalendarModel.UserID_ResultKey})
        }
        if arrCalenderEventName.count > 0 {
            var tag: Int? = nil
            if let anObject = arrCalenderEventName.first {
                tag = arrCalenderEvent!.index(of: anObject)
            }
            if isDelete {
                arrCalenderEvent!.remove(at: tag ?? 0)
            } else {
                arrCalenderEvent![tag ?? 0] = eventCalendarModel
            }
        } else {
                arrCalenderEvent!.append(eventCalendarModel)
        }
        let encode = JSONEncoder()
        do {
            let en = try encode.encode(arrCalenderEvent!)
            UserDefaults.standard.set(en, forKey: Text.DictKeys.calenderEvent)
            UserDefaults.standard.synchronize()
        }catch{
            Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
        }

       
        if isDelete {
            Utill.showAlertView(viewController: vc, title: Text.Label.text_Event_Title, message: Text.Message.msg_Calender_Event_Delete)
        }else {
            Utill.showAlertView(viewController: vc, title: Text.Label.text_Event_Title, message: Text.Message.msg_Calender_Event_Saved)
        }

    }
                
    class func findOrCreateEvent(with eventStore: EKEventStore?, withStepName stepName: String, withResultKey strResultKeyValue: String?, withStartDate strStartDate: String?, withEndDate strEndDate: String?) -> EKEvent? {
        let title = stepName

        // try to find an event
        var event: EKEvent?

        if let arrEvent = self.getEventFromCalendar()
        {
            let arrCalenderEvent = arrEvent.filter({$0.UserID_ResultKey == strResultKeyValue})
            if arrCalenderEvent.count > 0 {
                event = eventStore?.event(withIdentifier: arrCalenderEvent[0].EventIdentifier)
            }
        }

        if (event != nil) {
            return event
        }

        // if not, let's create new event

        if let aStore = eventStore {
            event = EKEvent(eventStore: aStore)
        }
        event?.title = title
        event?.calendar = eventStore?.defaultCalendarForNewEvents
        
        let calendar = Calendar.current
        var components = DateComponents()
        
        if let startDate = Date.dateObject(dateStr: strStartDate!)
        {
            event?.startDate = startDate
        }else {
            event?.startDate = Date()
        }
        

        let endDate = Date.dateObject(dateStr: strEndDate!)
        if endDate != nil {
            event?.endDate = endDate
        } else {
            components.hour = 1
            event?.endDate = calendar.date(byAdding: components, to: (event?.startDate)!)
        }
        return event
    }
//
    class func getEventFromCalendar() -> [WUMyEventList]? {
        let decoded  = UserDefaults.standard.object(forKey: Text.DictKeys.calenderEvent) as? Data
        if decoded != nil {
            let decode = JSONDecoder()
            do {
                let arr = try decode.decode([WUMyEventList].self, from: decoded!) as [WUMyEventList]
                return arr
            }catch{
                Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    class func removeExpireEventFromCalendar()
    {
        if let eventList = self.getEventFromCalendar()
        {
            var arrEventList = eventList
            let currentDate = Date()
            let arrFilter = eventList.filter({(Date.dateObjectForEventExpire(dateStr: $0.EndDate) == nil ? currentDate : Date.dateObjectForEventExpire(dateStr: $0.EndDate)!) < currentDate})
            if arrFilter.count > 0
            {
                for eventModel in arrFilter
                {
                    let eventStore : EKEventStore = EKEventStore()
                    let event : EKEvent = Utill.findOrCreateEvent(with: eventStore, withStepName: eventModel.Name, withResultKey: eventModel.UserID_ResultKey, withStartDate: eventModel.StartDate, withEndDate: eventModel.EndDate)!
                    if event.eventIdentifier != nil
                    {
                        if let eventRemove = eventStore.event(withIdentifier: event.eventIdentifier)
                        {
                            do {
                                try eventStore.remove(eventRemove, span: .thisEvent)
                            } catch let error as NSError {
                                Utill.printInTOConsole(printData:"failed to save event with error : \(error)")
                            }
                            
                        }
                        let tag: Int? = arrEventList.index(of: eventModel)
                        
                        if tag != nil {
                            arrEventList.remove(at: tag ?? 0)
                        }
                    }
                }
                let encode = JSONEncoder()
                do {
                    let en = try encode.encode(arrEventList)
                    UserDefaults.standard.set(en, forKey: Text.DictKeys.calenderEvent)
                    UserDefaults.standard.synchronize()
                }catch{
                    Utill.printInTOConsole(printData:"error: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    class func printInTOConsole(printData : Any){
       // #if SANDBOX
        print("\(printData)")
//        #else
//         print("\(printData)")
//        #endif
    }
}


