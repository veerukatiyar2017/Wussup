//
//  TabbarViewController.swift
//  Wussup
//
//  Created by MAC26 on 17/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import Alamofire

enum TabbarOptions : Int {
    case LiveCam    = 0
    case Events     = 1
    case Home       = 2
    case Favorite   = 3
    case Profile    = 4
}

class WUTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet var wuTabbarView                  : UIView!
    @IBOutlet weak var buttonLiveCam            : UIButton!
    @IBOutlet weak var buttonEvents             : UIButton!
    @IBOutlet weak var buttonHome               : UIButton!
    @IBOutlet weak var buttonFavorite           : UIButton!
    @IBOutlet weak var buttonProfile            : UIButton!
    @IBOutlet weak var buttonNotificationCount  : UIButton!
    
    var previousController: UIViewController?
    let offset = CGPoint.init(x: 0, y:0)
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabbarView()
        self.initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    func initialInterfaceSetUp() {
        self.delegate = self
        UIApplication.shared.isStatusBarHidden = false
        self.selectedIndex = TabbarOptions.Home.rawValue
        self.buttonHome.isSelected = true
        self.buttonNotificationCount.isHidden = true
    }
    
    // MARK: - Action Methods
    @IBAction func tabbarButtonAction(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        self.buttonLiveCam.isSelected = false
        self.buttonEvents.isSelected = false
        self.buttonHome.isSelected = false
        self.buttonFavorite.isSelected = false
        self.buttonProfile.isSelected = false
        sender.isSelected = true
    }
    
    // MARK: - TabBar Initial Setup
    func setTabbarView() {
        GlobalShared.appTabbarController = self
        self.wuTabbarView.frame =  self.tabBar.bounds
        self.tabBar.addSubview(wuTabbarView)
        self.view.backgroundColor = UIColor.black
    }
    
    func selectIndexForTabbar(selectedIndex : TabbarOptions) {
        self.buttonLiveCam.isSelected = false
        self.buttonEvents.isSelected = false
        self.buttonHome.isSelected = false
        self.buttonFavorite.isSelected = false
        self.buttonProfile.isSelected = false
        
        switch selectedIndex {
        case .LiveCam:
            self.selectedIndex = TabbarOptions.LiveCam.rawValue
            self.buttonLiveCam.isSelected = true
        case .Events:
            self.selectedIndex = TabbarOptions.Events.rawValue
            self.buttonEvents.isSelected = true
        case .Home:
            self.selectedIndex = TabbarOptions.Home.rawValue
            self.buttonHome.isSelected = true
        case .Favorite:
            self.selectedIndex = TabbarOptions.Favorite.rawValue
            self.buttonFavorite.isSelected = true
        case .Profile:
            self.selectedIndex = TabbarOptions.Profile.rawValue
            self.buttonProfile.isSelected = true
        }
    }
    
    func showTabbar()  {
        self.view.bringSubview(toFront: self.wuTabbarView)
    }
    
    //On Double Click of tab set Contentoffset Top  // scroll to top
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if previousController == viewController {
            
            let navVC = viewController as! UINavigationController
            
            if let vc = navVC.viewControllers.first as? WULiveCamHomeViewController {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    if vc.buttonLiveCamExpand.isSelected == true{
                        vc.LiveCamExpandVC.tableViewLiveCamExpand.setContentOffset(offset, animated: true)
                    }else if vc.buttonLiveCamGrid.isSelected == true{
                        vc.LiveCamGridVC.tableViewLiveCamGrid.setContentOffset(offset, animated: true)
                    }else {
                        vc.LiveCamListVC.tableViewLiveCamList.setContentOffset(offset, animated: true)
                    }
                }
            }else if let vc = navVC.viewControllers.first as? WUEventHomeViewController {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    if vc.buttonEventExpnad.isSelected == true  {
                        vc.eventExpandVC.tableViewEvent.setContentOffset(offset, animated: true)
                    }else if vc.buttonEventList.isSelected == true{
                        vc.eventListVC.tableViewEventList.setContentOffset(offset, animated: true)
                    }else {
                        vc.eventCategoryVC.tableViewEventCategory.setContentOffset(offset, animated: true)
                    }
                }
            }else if let vc = navVC.viewControllers.first as? WUHomeViewController {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    vc.tableViewHome.setContentOffset(offset, animated: true)
                }
            }else if let vc = navVC.viewControllers.first as? WUFavoriteHomeViewController {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    if vc.buttonFavoriteDateRange.isSelected == true{
                        vc.favoriteDateRangeVC.tableViewFavoriterDateRange.setContentOffset(offset, animated: true)
                    }else if vc.buttonFavoriteOptIn.isSelected == true{
                        vc.favoriteOptInVC.tableViewFavoriterOptIn.setContentOffset(offset, animated: true)
                    }else {
                        vc.favoriteListVC.tableViewFavoriterList.setContentOffset(offset, animated: true)
                    }
                }
            }else if let vc = navVC.viewControllers.first as? WUProfileViewController {
                if vc.isViewLoaded && (vc.view.window != nil) {
                    vc.tableViewProfile.setContentOffset(offset, animated: true)
                }
            }
        }else{
            print("No same")
        }
        previousController = viewController
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items!.index(of: item)!
        self.buttonLiveCam.isSelected = false
        self.buttonEvents.isSelected = false
        self.buttonHome.isSelected = false
        self.buttonFavorite.isSelected = false
        self.buttonProfile.isSelected = false
        switch indexOfTab {
        case 0 :
            self.buttonLiveCam.isSelected = true
            break
        case 1 :
            self.buttonEvents.isSelected = true
            break
        case 2 :
            self.buttonHome.isSelected = true
            break
        case 3 :
            self.buttonFavorite.isSelected = true
            break
        case 4 :
            self.buttonProfile.isSelected = true
            break
        default:
            break
        }
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let tabbarClickIndex = tabBarController.viewControllers?.index(of: viewController)
        
        if (tabbarClickIndex != TabbarOptions.Profile.rawValue) && tabBarController.selectedIndex == TabbarOptions.Profile.rawValue{
            let nav = tabBarController.viewControllers![tabBarController.selectedIndex] as! UINavigationController
            if let vc = nav.viewControllers.last as? WUProfileViewController{
                isNetworkConnected = (NetworkReachabilityManager()?.isReachable)!
                if isNetworkConnected == true && (vc.isProfileEdited() == true || vc.profileImageToEdit != nil){
                    if vc.checkValidation() == true
                    {
                        Utill.showAlert_OKCancle_ViewForTabManage(viewController: self, message: "Do you want to save changes?") { (yes) in
                            vc.isEditingEnable = false
                            if yes == true {
                                if vc.profileImageToEdit != nil{
                                    vc.uploadImageToAWSAndUpdateProfileWithTabChangeOrLogOut(image: vc.profileImageToEdit!) { (success) in
                                        if success == true {
                                            self.manageProfileFlow(tabbarClickIndex!, withVC: vc)
                                        }
                                        else{
                                            self.selectedIndex = tabbarClickIndex!
                                        }
                                    }
                                }else {
                                    vc.callWS_EditUserProfile(completionHandler: { (sucess) in
                                        Utill.printInTOConsole(printData:"In Completion part ")
                                        if sucess == true {
                                            self.manageProfileFlow(tabbarClickIndex!, withVC: vc)
                                        }
                                        else{
                                            self.selectedIndex = tabbarClickIndex!
                                        }
                                    })
                                }
                            }else{
                                vc.reloadDataForProfile()
                                vc.tableViewProfile.reloadData()
                                self.selectedIndex = tabbarClickIndex!
                                Utill.printInTOConsole(printData:"else part from alert  ")
                            }
                        }
                        return false
                    }
                }
            }
        }
        
        //Live Cam
        if tabbarClickIndex == TabbarOptions.LiveCam.rawValue && tabBarController.selectedIndex != TabbarOptions.LiveCam.rawValue {
            let nav = tabBarController.viewControllers![tabbarClickIndex!] as! UINavigationController
            if let vc = nav.viewControllers.last as? WULiveCamHomeViewController , vc.isViewLoaded == true{
                if vc.buttonLiveCamExpand.isSelected == true{
                    vc.LiveCamExpandVC.tableViewLiveCamExpand.setContentOffset(offset, animated: false)
                }else if vc.buttonLiveCamGrid.isSelected == true{
                    vc.LiveCamGridVC.tableViewLiveCamGrid.setContentOffset(offset, animated: false)
                }else {
                    vc.LiveCamListVC.tableViewLiveCamList.setContentOffset(offset, animated: false)
                }
                vc.callWS_GetLiveCamList()
            }
        }
        
        //Events
        if tabbarClickIndex == TabbarOptions.Events.rawValue && tabBarController.selectedIndex != TabbarOptions.Events.rawValue {
            let nav = tabBarController.viewControllers![tabbarClickIndex!] as! UINavigationController
            if let vc = nav.viewControllers.last as? WUEventHomeViewController, vc.isViewLoaded == true{
                if vc.buttonEventExpnad.isSelected == true || vc.buttonEventList.isSelected == true {
                    vc.callWS_getEventList(forDate: Date())
                }else {
                    vc.callWS_getEventCategories()
                }
            }
        }
        
        //Home
        if tabbarClickIndex == TabbarOptions.Home.rawValue && tabBarController.selectedIndex != TabbarOptions.Home.rawValue {
            let nav = tabBarController.viewControllers![tabbarClickIndex!] as! UINavigationController
            if let vc = nav.viewControllers.last as? WUHomeViewController, vc.isViewLoaded == true {
                vc.tableViewHome.setContentOffset(offset, animated: false)
                vc.callWS_getHomeVenueList()
                vc.callWS_getHomeAds()
            }
        }
        
        //Favorite
        if tabbarClickIndex == TabbarOptions.Favorite.rawValue && tabBarController.selectedIndex != TabbarOptions.Favorite.rawValue {
            let nav = tabBarController.viewControllers![tabbarClickIndex!] as! UINavigationController
            if let vc = nav.viewControllers.last as? WUFavoriteHomeViewController, vc.isViewLoaded == true {
                if vc.buttonFavoriteDateRange.isSelected == true{
                    vc.favoriteDateRangeVC.tableViewFavoriterDateRange.setContentOffset(offset, animated: false)
                }else if vc.buttonFavoriteOptIn.isSelected == true{
                    vc.favoriteOptInVC.tableViewFavoriterOptIn.setContentOffset(offset, animated: false)
                }else {
                    vc.favoriteListVC.tableViewFavoriterList.setContentOffset(offset, animated: false)
                }
                vc.callWS_GetUserFavoriteVenues(forDate: Date())
            }
        }
        
        if tabbarClickIndex == TabbarOptions.Home.rawValue && tabBarController.selectedIndex == TabbarOptions.Favorite.rawValue{
            let nav = tabBarController.viewControllers![tabbarClickIndex!] as! UINavigationController
            if let vc = nav.viewControllers.last as? WUVenueProfileViewController{
                vc.callWS_getVenueProfileDetail(isFromFavorite: true)
            }else if let vc = nav.viewControllers.last as? WUHomeViewController, vc.isViewLoaded == true {
                vc.tableViewHome.setContentOffset(offset, animated: false)
            }
        }
        
        //Profile
        if tabbarClickIndex == TabbarOptions.Profile.rawValue && tabBarController.selectedIndex != TabbarOptions.Profile.rawValue {
            let nav = tabBarController.viewControllers![tabbarClickIndex!] as! UINavigationController
            if let vc = nav.viewControllers.last as? WUProfileViewController{
                vc.initialInterfaceSetup()
            }
        }
        return true
    }
    
    func manageProfileFlow(_ tabbarClickIndex : Int , withVC vc: UIViewController) {
        if UserDefault.bool(forKey: Text.UDKeys.isThankyouProfileViewed) == false {
            UserDefault.set(true, forKey: Text.UDKeys.isThankyouProfileViewed)
            UserDefault.synchronize()
            vc.performSegue(withIdentifier: Text.Segue.profileToThankyouVC, sender: nil)
            self.selectedIndex = tabbarClickIndex
        }else{
            Utill.showAlert_OK_ViewForTabManage(viewController: vc, message: Text.Message.profileUpdatedSuccessfully, completion: { (success) in
                if success == true {
                    self.selectedIndex = tabbarClickIndex
                }
            })
        }
    }
}
