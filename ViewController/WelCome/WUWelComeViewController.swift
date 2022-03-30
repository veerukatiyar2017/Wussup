//
// WUWelComeViewController.swift
//  Demo_Wussup
//
//  Created by MAC219 on 13/04/18.
//  Copyright © 2018 MAC219. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON

class WUWelComeViewController: UIViewController{
    
    @IBOutlet private weak var viewWelcome      : UIView!
    @IBOutlet private weak var viewSeperator1   : UIView!
    @IBOutlet private weak var labelLogin       : UILabel!
    @IBOutlet private weak var buttonWussup     : UIButton!
    @IBOutlet private weak var viewSeperator2   : UIView!
    @IBOutlet private weak var labelOr1         : UILabel!
    @IBOutlet private weak var buttonJoinWussup : UIButton!
    @IBOutlet private weak var viewSeperator3   : UIView!
    @IBOutlet private weak var labelOr2         : UILabel!
    @IBOutlet private weak var buttonFacebook   : UIButton!
    @IBOutlet private weak var imageViewBeeGif  : UIImageView!
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialInterfaceSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Initial Interface SetUp
    func initialInterfaceSetUp() {
        self.setUpUIView()
//        Utill.loadBeeAnimationForView(view: self.view)
        Utill.loadBeeGif(imageView: self.imageViewBeeGif)
    }
    
   private func setUpUIView() {
        self.viewWelcome.layer.borderColor = UIColor.white.cgColor
        self.viewWelcome.backgroundColor = .blackColor
        
        self.viewSeperator1.backgroundColor = .white
        self.labelLogin.textColor = .SearchBarYellowColor
        self.buttonWussup.backgroundColor = .SearchBarYellowColor
        self.buttonWussup.setTitleColor(.blackColor, for: .normal)
        
        self.viewSeperator2.backgroundColor = .white
        self.labelOr1.textColor = .SearchBarYellowColor
        self.buttonJoinWussup.backgroundColor = .btnJoinWussupGreenColor
        self.buttonJoinWussup.setTitleColor(.white, for: .normal)
        
        self.viewSeperator3.backgroundColor = .white
        self.labelOr2.textColor = .SearchBarYellowColor
        self.buttonFacebook.backgroundColor = .btnFacebookBlueColor
        self.buttonFacebook.setTitleColor(.white, for: .normal)
        
    }
    
    // MARK: - Webservice Methods
    private func callWS_LoginWithFacebook(userName : String , facebookID : String){
        WEB_API.call_api_LoginWithFacebook(userName: userName,facebookID : facebookID) { (response, success, message) in
            if success{
                let data = try! JSONSerialization.data(withJSONObject: response?["UserDetail"].dictionaryObject ?? [:], options: [])
                let favCategorydata = try! JSONSerialization.data(withJSONObject: response?["FavoriteCategories"].arrayObject ?? [:], options: [])
                let user = try! JSONDecoder().decode(WUUser.self, from: data)
                user.FavoriteCategories = try! JSONDecoder().decode([WUCategory].self, from: favCategorydata)
                Utill.saveUserModel(user)
                Utill.printInTOConsole(printData:"response: \(response ?? "")")
                self.performSegue(withIdentifier: Text.Segue.welcomeToHome, sender: nil)
            }else {
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func wussUpButtonAction(_ sender: Any) {
        FirebaseManager.sharedInstance.login_ios(parameter: nil)
        self.performSegue(withIdentifier: Text.Segue.welcomeToLogin, sender: nil)
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        FirebaseManager.sharedInstance.signup_fb_ios(parameter: nil)
        let loginManager = LoginManager()
        loginManager.loginBehavior = .browser//.native
        loginManager.logIn(permissions: ["public_profile", "user_friends", "email"], from: self) { (result, error) in
            if ((error) != nil)
            {
               Utill.printInTOConsole(printData:"error")
            }
            else if (result?.isCancelled)! {
                // Handle cancellations
                Utill.printInTOConsole(printData:"cancel")
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                Utill.printInTOConsole(printData:"else")
                
                if (result?.grantedPermissions.contains("email"))!
                {
                    // Do work
                    self.getFBUserData(completionHandler: { (token, email, fbID, name, success) in
                        Utill.printInTOConsole(printData:"Token:\(token)")
                        Utill.printInTOConsole(printData:"success:\(success)")
                        self.callWS_LoginWithFacebook(userName: email, facebookID: fbID)
                    })
                }else{
                    Utill.printInTOConsole(printData:"We Do not have permissions to acess Email id ")
                }
            }
        }
        //        self.performSegue(withIdentifier: Text.Segue.welcomeToHome, sender: nil)
    }
    
    @IBAction func joinWussUpButtonAction(_ sender: Any) {
        FirebaseManager.sharedInstance.signup_email_ios(parameter: nil)
        self.performSegue(withIdentifier: Text.Segue.welComeToSignUp, sender: nil)
    }
    
    func getFBUserData(completionHandler:@escaping (_ token : String, _ email: String, _ fbID: String, _ name: String,_ success : Bool)->())
    {
        //Set required field in paramater in response
        let parameters = ["fields": "id, name, link, gender, picture.type(large), email, birthday, location, age_range,locale"]
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: parameters)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            //            AppExtraMethods.progressHUDStop()
            
            if ((error) != nil)
            {
                // Process error
                Utill.printInTOConsole(printData:"Error: \(String(describing: error))")
            }
            else
            {
                let json = JSON(result as Any)
                //Getting a string from a JSON Dictionary
                let email = json["email"].stringValue
                let id = json["id"].stringValue
                let name = json["name"].stringValue
                //                let picture = json["picture"].dictionary
                //                let picData = picture?["data"]?.dictionary
                Utill.printInTOConsole(printData:"fetched user: \(String(describing: result))")
                Utill.printInTOConsole(printData:"Token String \(AccessToken.current!.tokenString)")
                //                let accessToken = FBSDKAccessToken.current()
                completionHandler(AccessToken.current!.tokenString, email, id, name, true)
                
                /*let dictValues = NSMutableDictionary()
                 dictValues.setValue(name, forKey: "FullName")
                 dictValues.setValue(email, forKey: "Email")
                 dictValues.setValue(id, forKey: "FaceBookID")
                 dictValues.setValue("", forKey: "Phonenumber")
                 dictValues.setValue(picData?["url"]?.stringValue, forKey: "ProfileImageURL")
                 dictValues.setValue("", forKey: "LocationCity")
                 dictValues.setValue("", forKey: "LocationCountry")
                 dictValues.setValue("", forKey: "LocationAddress")
                 dictValues.setValue("", forKey: "LocationZipcode")*/
            }
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.welcomeToHome{
            let tabbarvc = segue.destination as! WUTabbarViewController
            AppDel.tabbar = tabbarvc
        }
    }
}


