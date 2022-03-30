//
//  WUUserInterestsViewController.swift
//  Wussup
//
//  Created by Alexandr on 19.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class WUUserInterestsViewController: UIViewController {
    
    //MARK: - Variable
    private var user                    : User! = GlobalShared.user
    var arrayAllCategories              : [WUCategory] = []
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func switchOnOfInterest(_ sender: UISwitch) {
        guard let indexPath =  tableView.indexPathForCellWithSubview(cellSubview: sender) else {return}
       
        self.arrayAllCategories[indexPath.row].isSelected = sender.isOn
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initialInterfaceSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.saveInterestsData()
    }

    
    // MARK: - Initial Setup
     func initialInterfaceSetup() {
        if GlobalShared.arrayCategories.count > 0{
            
            //Hide Live Cams and Local Promos
            self.arrayAllCategories = GlobalShared.arrayCategories.clone().filter({$0.ID != "14"}).filter({$0.ID != "13"})
            self.reoderArrayAllCategories()
            
            self.tableView.reloadData()
            self.callWS_GetUserProfile()
        }else{
            self.callWS_getCategoryList()
        }
     }
    
    private func setupTableView(){
        self.tableView.tableFooterView = UIView()
        self.tableView.semanticContentAttribute = .forceRightToLeft
        self.tableView.isEditing = true
    }
    
    private func reoderArrayAllCategories(){
        var reoderedArray = self.user.CategoriesPreference
        
        self.arrayAllCategories.forEach { (category) in
            if !reoderedArray.map({$0.ID}).contains(category.ID){
                reoderedArray.append(category)
            }
        }
       self.arrayAllCategories = reoderedArray
    }
    
    private func saveInterestsData(){
        self.callWS_EditUserProfile { (_) in}
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
                      
                self.user = GlobalShared.user
                
                self.reoderArrayAllCategories()
                self.tableView.reloadData()
            }
          }
      }
    
    
    private func callWS_getCategoryList() {
        WEB_API.call_api_GetCategoryList { (response,status,message) in
            if status == true{

                let data = try! JSONSerialization.data(withJSONObject: (response!["Categories"]).arrayObject ?? [], options: [])
                let arrCategoris = try! JSONDecoder().decode([WUCategory].self, from: data)
                GlobalShared.arrayCategories = arrCategoris
                
                // Hide Live Cams and Local Promos
                self.arrayAllCategories = GlobalShared.arrayCategories.clone().filter({$0.ID != "14"}).filter({$0.ID != "13"})
                self.reoderArrayAllCategories()

                self.callWS_GetUserProfile()
            }else {
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    private func callWS_EditUserProfile(completionHandler : @escaping (Bool) -> Void) {
        GlobalShared.arrayCategories = self.arrayAllCategories
        GlobalShared.user.CategoriesPreference = self.arrayAllCategories.filter({$0.isSelected})

        WEB_API.call_api_EditUserProfile(username             : self.user.UserName,
                                         imageUrl             : self.user.ImageURL,
                                         email                : self.user.Email,
                                         mobile               : self.user.Mobile,
                                         birthDate            : self.user.Birthdate,
                                         city                 : self.user.City,
                                         allowNotification    : self.user.IsAllowedNotification,
                                         postalCode           : self.user.PostalCode,
                                         categoriesPreference : self.arrayAllCategories.filter({$0.isSelected}).map { $0.ID }.joined(separator: ","))
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
}

extension WUUserInterestsViewController: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrayAllCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInterestCell")  as! UserInterestCell
        cell.setupCell(with: self.arrayAllCategories[indexPath.row], user: self.user)
        self.arrayAllCategories[indexPath.row].isSelected = cell.interestSwitch.isOn
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.arrayAllCategories[sourceIndexPath.row]
        arrayAllCategories.remove(at: sourceIndexPath.row)
        arrayAllCategories.insert(movedObject, at: destinationIndexPath.row)
    }
    
    // Change default icon (hamburger) for moving cells in UITableView
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imageView = cell.subviews.first(where: { $0.description.contains("Reorder") })?.subviews.first(where: { $0 is UIImageView }) as? UIImageView

        imageView?.image = #imageLiteral(resourceName: "Reorder")
        imageView?.contentMode = .scaleAspectFit

        imageView?.frame.size.width = cell.bounds.height*0.5
        imageView?.frame.size.height = cell.bounds.height*0.5
    }
    
}


