//
//  WUInterestsViewController.swift
//  Wussup
//
//  Created by MAC105 on 19/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class WUInterestsViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet private weak var collectionInterests      : UICollectionView!
    @IBOutlet private weak var labelNoResults           : UILabel!
    @IBOutlet private weak var viewLabels               : UIView!
    @IBOutlet private weak var labelWussupLike          : UILabel!
    @IBOutlet private weak var labelPleasetap           : UILabel!
    @IBOutlet private weak var viewCollection           : UIView!
    @IBOutlet private weak var viewBlackGap             : UIView!
    @IBOutlet private weak var viewYellowGap            : UIView!
    @IBOutlet private weak var buttonSkip               : UIButton!
    @IBOutlet private weak var buttonDone               : UIButton!
    @IBOutlet private weak var buttonBack               : UIButton!
    
    //MARK:- Variable
    var arrayAllCategories       : [WUCategory] = []
    var isFromProfileVC : Bool = false
    var userSelectedCategory : String = ""
    var db = Firestore.firestore()
    var interestCategoriesArray = [[String: Any]]()
    var selectedArray = [String]()
    
    //MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initial Interface SetUp
    func initialInterfaceSetUp() {
        self.setUpUIView()
        self.collectionInterests.isHidden = false
        self.collectionInterests.contentInset = UIEdgeInsetsMake(36, 38.0.propotional, 25, 38.0.propotional)
        self.labelNoResults.text = Text.Message.noDataFound
        self.buttonDone.isSelected = false
        // self.callWS_getCategoryList()
        callWS_getInterest()
        if self.isFromProfileVC == true{
            self.buttonSkip.isHidden = true
            self.buttonBack.isHidden = false
        }else{
            self.buttonSkip.isHidden = false
            self.buttonBack.isHidden = true
        }
    }
    
    private func setUpUIView() {
        
        self.viewLabels.layer.borderColor = UIColor.white.cgColor
        self.viewLabels.backgroundColor = .blackColor
        
        self.labelWussupLike.textColor = .white
        self.labelPleasetap.textColor = .SearchBarYellowColor
        
        self.viewCollection.backgroundColor = .DarkGrayColor
        
        self.buttonBack.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Back, color: .btnLightGrayColor ), for: .normal)
        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Done, color: .btnLightGrayColor ), for: .normal)
        
    }
    
    private func mangeLabelDuringNoData(isShow : Bool){
        if isShow == true{
            self.labelNoResults.isHidden = false
            self.collectionInterests.isHidden = true
            self.buttonDone.isEnabled = false
            self.buttonDone.alpha = 0.5
        }else{
            self.labelNoResults.isHidden = true
            self.collectionInterests.isHidden = false
            self.buttonDone.isEnabled = true
            self.buttonDone.alpha = 1.0
        }
    }
    
    //MARK:- API Methods
    private func callWS_getInterest() {
        Utill.showProgressHud()
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        let userID = Auth.auth().currentUser?.uid
     //   var ref: DocumentReference? = nil
        db.collection("intrestCategory").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                Utill.hideProgressHud()
            } else {
                for document in querySnapshot!.documents {
                    Utill.hideProgressHud()
                    print("\(document.documentID) => \(document.data())")
                        self.interestCategoriesArray.append(document.data())
                }
                self.collectionInterests.reloadData()
            }
        }
        
        
//        ref.child("intrestCategory").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
//          // Get user value
//          let value = snapshot.value as? NSDictionary
//          let username = value?["Name"] as? String ?? ""
//          print(username)
//          // ...
//        }) { error in
//          print(error.localizedDescription)
//        }
    }
    
    private func callWS_getCategoryList() {
        WEB_API.call_api_GetCategoryList { (response,status,message) in
            if status == true{
                self.mangeLabelDuringNoData(isShow: false)
                let data = try! JSONSerialization.data(withJSONObject: (response!["Categories"]).arrayObject ?? [], options: [])
                let arrCategoris = try! JSONDecoder().decode([WUCategory].self, from: data)
                GlobalShared.arrayCategories = arrCategoris
                self.arrayAllCategories = GlobalShared.arrayCategories.clone()
                
                if self.isFromProfileVC == true{
                    let arrCatIds = self.userSelectedCategory.components(separatedBy: ",")
                    if (arrCatIds.count) > 0{
                        for catId in arrCatIds{
                            let arrUserCatergories = self.arrayAllCategories.filter{$0.ID == catId}
                            if arrUserCatergories.count > 0{
                                let categoryObject = arrUserCatergories[0]
                                categoryObject.isSelected = !categoryObject.isSelected
                            }
                        }
                    }
                }
                
                self.collectionInterests.reloadData()
                Utill.printInTOConsole(printData:"\(arrCategoris)")
            }else {
                self.mangeLabelDuringNoData(isShow: true)
                Utill.showAlertView(viewController: self, message: message)
            }
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func skipButtonAction(_ sender: Any) {
        FirebaseManager.sharedInstance.onboard_skip_ios(parameter: nil)
        self.performSegue(withIdentifier: Text.Segue.interestVCToHomeVC, sender: nil)
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        FirebaseManager.sharedInstance.onboard_complete_ios(parameter: nil)
        self.buttonDone.isSelected = true
        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Done, color: UIColor.SearchBarYellowColor ), for: .normal)
        if self.isFromProfileVC == true {
            //            let arrCatergoriesID = self.arrayAllCategories.filter{$0.isSelected == true}.map({$0.ID})
            let arrSelectedCatergories = self.arrayAllCategories.filter{$0.isSelected == true}
            //            let strSlectedCatId = arrCatergoriesID.joined(separator: ",")
            NotificationCenter.default.post(name: .interestToProfile, object: arrSelectedCatergories)
            //            self.dicEditUserProfile![Text.DictKeys.profileCategory] = strSlectedCatId
            self.navigationController?.popViewController(animated: true)
        } else {
          //  let arrCatergoriesID = self.arrayAllCategories.filter{$0.isSelected == true}.map({$0.ID})
            var arrCatergoriesID = [Any]()
            let userInfo = Auth.auth().currentUser
              let uid = userInfo?.uid
            var dbb = Firestore.firestore()
            dbb.collection("users")
                .document(uid!)
                .getDocument { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        Utill.hideProgressHud()
                    } else {
//                        print(querySnapshot!.documentID)
//                        print(querySnapshot!.data()!["mobile"]!)
//                        print((querySnapshot!.data()!["favoriteCategories"]! as AnyObject))
                        arrCatergoriesID = querySnapshot!.data()!["favoriteCategories"]! as! [Any]
                    }
//                    print(arrCatergoriesID)
                    print(arrCatergoriesID.count)
                    if arrCatergoriesID.count > 0 {
        //                let strIDSepratedByCommas = arrCatergoriesID.joined(separator: ",")
        //                WEB_API.call_api_SaveUserCategories(user : GlobalShared.user, categories: strIDSepratedByCommas) { (response,status,message) in
        //                    if status == true{
        //                        let data = try! JSONSerialization.data(withJSONObject: (response!["Categories"]).arrayObject ?? [], options: [])
        //                        let arrCategoris = try! JSONDecoder().decode([WUCategory].self, from: data)
        //                        let user = GlobalShared.user
        //                        user?.FavoriteCategories = arrCategoris
        //                        Utill.saveUserModel(user!)
                                self.performSegue(withIdentifier: Text.Segue.interestToComplete, sender: nil)
        //                    }else {
        //                        Utill.showAlertView(viewController: self, message: message)
        //                    }
        //                }
                    } else {
                        self.buttonDone.isSelected = false
                        self.buttonDone.setAttributedTitle(Utill.setAttributedStringWithUnderLine(str1: Text.Label.text_Done, color: .btnLightGrayColor ), for: .normal)
                        Utill.showAlertView(viewController: self, message: Text.Message.SelectAtleastOneCategory)
                    }
                }
         
            }
        }
   // }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Text.Segue.interestVCToHomeVC{
            let tabbarvc = segue.destination as! WUTabbarViewController
            AppDel.tabbar = tabbarvc
        }
    }
}

// MARK: UICollectionView Delegate

extension WUInterestsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.interestCategoriesArray.count)
        if self.interestCategoriesArray.count != 0 {
            return self.interestCategoriesArray.count
        } else {
         return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utill.getClassNameFor(classType:WUCategoryCollectionCell()), for: indexPath)as! WUCategoryCollectionCell
        if self.interestCategoriesArray.count != 0 {
            cell.setInterestDetails(infoArray: self.interestCategoriesArray[indexPath.item])
        }
//       cell.setCategory = self.arrayAllCategories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryObject  = self.interestCategoriesArray[indexPath.item] as [String: Any]
        if let selectedName = categoryObject["Name"] as? String {
            selectedArray.append(selectedName)
        }
        let newUserInfo = Auth.auth().currentUser
        let userid = newUserInfo?.uid
        print(userid!)
        db.collection("users")
            .document(userid!)
            .updateData([
                "favoriteCategories": selectedArray
                
            ])
 //       if let selectedCategory = categoryObject["IsCategorySelected"] as? Int, selectedCategory == 0 {
        let cell = collectionView.cellForItem(at: indexPath) as! WUCategoryCollectionCell
        cell.labelCategory.textColor = UIColor.black
        cell.setInterestDetails(infoArray: self.interestCategoriesArray[indexPath.item])
    //    }
//        cell.setCategory = categoryObject
//        if categoryObject.isSelected == true
//        {
//            FirebaseManager.sharedInstance.InterestCategoryTap(category : categoryObject)
//        }
   //     self.collectionInterests.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        let widthHeight = ((UIScreen.main.bounds.size.width-(2*38.0.propotional))/3)
        return CGSize(width: widthHeight, height:widthHeight)
    }
}
