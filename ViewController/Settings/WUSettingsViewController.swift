//
//  ViewControllerooo.swift
//  Wussup
//
//  Created by Alexandr on 18.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class WUSettingsViewController: UIViewController {
    
    //MARK: - Variable
    private var user                    : User! = GlobalShared.user
    private var arrayAllCategories      : [WUCategory] = []

    
     //MARK: - Actions
    @IBAction func profileButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toProfileEditVC", sender: self)
    }
    
    @IBAction func interestsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toInterestsVC", sender: self)

    }
    
    @IBAction func notificationsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toNotificationsVC", sender: self)

    }
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.callWS_getCategoryList()
        self.callWS_GetUserProfile()
    }
    
    // MARK: - Webservice Methods
    func callWS_GetUserProfile() {

        WEB_API.call_api_GetUserProfile()
            { (response, success, message) in
                
                if success {
                    let data = try! JSONSerialization.data(withJSONObject: response?["UserProfile"].dictionaryObject ?? [:], options: [])
                    let user = try! JSONDecoder().decode(WUUser.self, from: data)
                    user.Token = self.user.Token
                    Utill.saveUserModel(user)
                    
                    self.call_api_GetLatLongDetails(with: user)
                    Utill.printInTOConsole(printData:"response: \(response ?? "")")
                }
        }
    }
    
     private func callWS_getCategoryList() {
        WEB_API.call_api_GetCategoryList { (response,status,message) in
            if status == true{

                let data = try! JSONSerialization.data(withJSONObject: (response!["Categories"]).arrayObject ?? [], options: [])
                let arrCategoris = try! JSONDecoder().decode([WUCategory].self, from: data)
                GlobalShared.arrayCategories = arrCategoris
            }else {
                 Utill.showAlertView(viewController: self, message: message)
             }
         }
     }
    
    private func call_api_GetLatLongDetails(with user: User){
           
           WEB_API.call_api_GetLatLongDetails(user: user) { (response, success, message) in
                                  
               let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
               GlobalShared.geolocationFilterData = try! JSONDecoder().decode(WUGeolocationFilterData.self, from: data)
           }
       }


}
