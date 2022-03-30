//
//  AppDelegate.swift
//  Wussup
//
//  Created by MAC26 on 16/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics
import UserNotifications
import CoreLocation
import Firebase
import FirebaseMessaging
import EventKitUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window                          : UIWindow?
    let locationManager                 = CLLocationManager()
    var tabbar                          : WUTabbarViewController?
    var mainNavVC                       : UINavigationController?
    var performActionOnNotificationTap  : Bool!                     = false
    var NotificationUserInfo            : [AnyHashable : Any]?
    var notificationV                   : AFDropdownNotification?
    var redirectUrl : URL!
    
    //MARK: - AppDelegate Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        self.callWS_APIVersionCheck()
        TWTRTwitter.sharedInstance().start(withConsumerKey: TwitterConsumerKey, consumerSecret: TwitterConsumerSecret)
        self.initialSetup()
        Utill.initialApplicationSetup()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        notificationV = AFDropdownNotification.init()
        notificationV?.notificationDelegate = self
                
        UIApplication.shared.applicationIconBadgeNumber = 0
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        self.registerForPushNotifications()
        Utill.setupAmazonImageUploding()
        

        
        if launchOptions != nil
        {
            //From Push Notification
            if let dic = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification]
            {
                //                let mainQueue = DispatchQueue.main
                //                let deadline = DispatchTime.now() + .seconds(2)
                //                mainQueue.asyncAfter(deadline: deadline) {
                self.NotificationUserInfo = dic as? [AnyHashable : Any]
                               
                //     self.checkFavoriteNotification()
                //  }
            }
        }
        
        // Open Deep Link
        if launchOptions != nil {
            if let activityDictionary = launchOptions![.userActivityDictionary] as? [String:Any]{
                if let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity{
                    let webpageURL = activity.webpageURL!
                    let deepLink = webpageURL.absoluteString.convertUniversalUrlToDeepLink
                    let url = URL(string: deepLink)!
                    
                    openDeepLink(with: url)
                }
            }

            if let url = launchOptions![.userActivityDictionary] as? URL
            {
                

                           // Utill.showAlertViewOnWindow(message: "URL :\(launchOptions.debugDescription)")
                self.redirectUrl = url
            }
        }
        
        // Set Light InterfaceStyle Mode
        if #available(iOS 13.0, *) {
                  window?.overrideUserInterfaceStyle = .light
              }
              
        
                //self.redirectUrl = URL(string: "arvz://venue/100/FourSquareID/4c45-ca1636d6a59325556ca8")
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        if ApplicationDelegate.shared.application(app, open: url, options: options){
            return true
        }
        
        openDeepLink(with: url)
        
        return false
    }
    
    func openDeepLink(with url: URL){
        
        if "arvzapp".containsIgnoringCase(find: url.scheme!){
            if url.host == "venue"{
                self.reDirectToVenueProfile(redirectUrl : url)
            }else if url.host == "event"{
                self.reDirectToEventProfile(redirectUrl : url)
            }else if url.host == "livecam"{
                self.reDirectToLiveCamProfile(redirectUrl: url)
            }
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let webpageURL = userActivity.webpageURL!
            let deepLink = webpageURL.absoluteString.convertUniversalUrlToDeepLink
            let url = URL(string: deepLink)!
            
            openDeepLink(with: url)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if self.tabbar != nil {
            self.managePlayer(isPlay: false)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if self.tabbar != nil {
            self.managePlayer(isPlay: false)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.callWS_APIVersionCheck()
        if self.tabbar != nil && Utill.getUserModel() != nil {
            self.callWS_GetTotalUnreadNotification()
            self.managePlayer(isPlay: true)
            Utill.removeExpireEventFromCalendar()
        }
        
       Utill.hideAllowLocationView()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        if self.tabbar != nil {
            self.managePlayer(isPlay: true)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        //print("ReceiveRemoteNotificationuserInfo: \(userInfo)")
        self.receivedPushNotification(userInfo)
        
        // Open Venue with Push Notification
        guard  UIApplication.shared.applicationState != .active else {return}
        guard let venueID = (userInfo["VenueID"] as? String) else {return}
        self.reDirectToVenueProfile(venueID: (venueID as! String))
    }
    
    
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken

           let   deviceToken = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
           // kDeviceToken=tokenString
           //GlobalShared.deviceToken = deviceToken
           Utill.printInTOConsole(printData:"deviceToken: \(deviceToken)")
    }
    
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            Utill.printInTOConsole(printData:"Failed to register:  \(error.localizedDescription)")
        }
    
    // MARK: - Webservice Methods
    private func callWS_APIVersionCheck(){
        WEB_API.call_api_APIVersionCheck { (response, sucess, message) in
            if sucess{
                if response!["IsNewVersionAvailable"].boolValue == true {
                    if response!["IsNeedToUpdate"].boolValue == false{
                        Utill.printInTOConsole(printData:"needed")
                        if let saveDate = UserDefault.object(forKey: Text.UDKeys.saveCurrentDate) as? Date {
                            if Utill.compareTwoDateForVesionUpdate(date: saveDate) == true {
                                self.showAlertForVersionUpdate()
                            }
                        }else{
                            self.showAlertForVersionUpdate()
                        }
                    }else {
                        Utill.showAlert_UpadteOnWindow(message:Text.Message.msg_ForVersionUpdate , completion: { (sucess) in
                            UIApplication.shared.open(URL(string:APPSTORE_URL)!, options:[:], completionHandler: nil)
                        })
                    }
                }
            }else{
                
            }
        }
    }
    
    private func showAlertForVersionUpdate(){
        Utill.showAlert_UpadteORCancle_ViewOnWindow(message: Text.Message.msg_ForVersionUpdate, completion: { (isSucess) in
            if isSucess == true {
                UserDefault.set(Date(), forKey:Text.UDKeys.saveCurrentDate)
                UserDefault.synchronize()
            }else{
                UIApplication.shared.open(URL(string:APPSTORE_URL)!, options:[:], completionHandler: nil)
            }
        })
    }
    
     func callWS_GetTotalUnreadNotification(){
        guard Utill.getUserModel() != nil else {return}
        
        WEB_API.call_api_GetTotalUnreadNotification(user:Utill.getUserModel()!) { (response, sucess, message) in
            print(response ?? "")
            let tabbarController = GlobalShared.appTabbarController
            tabbarController?.buttonNotificationCount.isHidden = true
            if sucess {
                print("Sucess")
                if response!["TotalUnreadCount"].intValue > 0 {
                    GlobalShared.notifciationCount = Int(response!["TotalUnreadCount"].intValue)
                    //                    UIApplication.shared.applicationIconBadgeNumber = GlobalShared.notifciationCount
                    tabbarController?.buttonNotificationCount.isHidden = false
                    tabbarController?.buttonNotificationCount.setTitle("\(GlobalShared.notifciationCount)", for: .normal)
                }
            }else{
                print("Not Sucess")
            }
        }
    }
    
    //MARK: - Manage Player
    private func managePlayer(isPlay : Bool ){
        if isPlay == true {
            if let tabbarController = GlobalShared.appTabbarController {
                let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last
                if vc is WUHomeViewController{
                    (vc as! WUHomeViewController).player?.play()
                }
                if vc is WULiveCamProfileViewController{
                    (vc as! WULiveCamProfileViewController).player?.play()
                }
            }
        }else{
            if let tabbarController = GlobalShared.appTabbarController {
                let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last
                if vc is WUHomeViewController{
                    (vc as! WUHomeViewController).player?.pause()
                }
                if vc is WULiveCamProfileViewController{
                    (vc as! WULiveCamProfileViewController).player?.pause()
                }
            }
        }
        
        if let tabbarController = GlobalShared.appTabbarController{
            let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last
            if vc is WUVenueProfileViewController{
                (vc as! WUVenueProfileViewController).collectionCategory.reloadData()
            }
        }
        
        if let tabbarController = GlobalShared.appTabbarController{
            let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last
            if vc is WUEventProfileViewController{
                (vc as! WUEventProfileViewController).collectionViewShareOptions.reloadData()
            }
        }
    }
    
    // MARK: - Usermanagement
    private func initialSetup(){
        UIApplication.shared.statusBarStyle = .lightContent
        self.moveToSplash()
    }
    
    private func tempUserModelSetting() {
        let dic = ["UserID" : "1"]
        let data = try! JSONSerialization.data(withJSONObject: dic, options: [])
        let userModel = try! JSONDecoder().decode(User.self, from: data) as User
        Utill.saveUserModel(userModel)
    }
    
    private func moveToSplash(){
        if UserDefault.bool(forKey: Text.UDKeys.isLaunchedOnce) == true {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            if let vc = UIStoryboard.splash.get(WUSplashViewController.self){
                let navVC = UINavigationController(rootViewController: vc)
                navVC.isNavigationBarHidden = true
                self.window?.rootViewController = navVC
                self.mainNavVC = navVC
                self.window?.makeKeyAndVisible()
            }
        }
        else {
            self.mainNavVC = self.window?.rootViewController as? UINavigationController
        }
    }
    
    // MARK: - UIInterfaceOrientationMask
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        if let tabbarController = GlobalShared.appTabbarController {
            if  let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last{
                if vc is WULiveCamProfileViewController{
                    let profile = vc as! WULiveCamProfileViewController
                    if profile.isFullScreen == true{
                        return .allButUpsideDown
                    }
                    return .portrait
                }
                return .portrait
            }
            return .portrait
        }
        else {
            return .portrait
        }
    }
}

//MARK: - Location
extension AppDelegate : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            //locationManager.startUpdatingLocation()
            if let tabbarController = GlobalShared.appTabbarController {
                let vc = (tabbarController.selectedViewController as! UINavigationController).viewControllers.last
                if vc is WUHomeViewController{
                    (vc as! WUHomeViewController).getData()
                }
            }
            break
            
        case .denied, .notDetermined, .restricted :

            Utill.showAllowLocationView()
/*          
            Utill.showAlert_GoToSettingCancle_ViewOnWindow(message: Text.Label.text_AllowAccessToLocation, completion: { (bool) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            })
 */
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Utill.printInTOConsole(printData:"locations = \(locValue.latitude) \(locValue.longitude)")
        
        GlobalShared.currentLocationCoordinate = locValue
    }
    
    // MARK: - location managment//
    func setUpLocationManager(completion:(() -> Void)?) {
        
        // Ask for Authorisation from the User.
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined :
                locationManager.delegate = self
                break
            case .denied, .restricted :

                 Utill.showAllowLocationView()

/*               Utill.showAlert_GoToSettingCancle_ViewOnWindow(message: Text.Label.text_AllowAccessToLocation) { (bool) in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                //GlobalShared.currentLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
 */
                break
            case .authorizedAlways, .authorizedWhenInUse :
                locationManager.delegate = self
                //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                // locationManager.startUpdatingLocation()
                //locationManager.startMonitoringSignificantLocationChanges()
                
                //>>>>>>
                // Reno
                //let latitude = 39.444093
                //let longitude = -119.569579
                
                // Reno+
                //let latitude = 39.422095
                //let longitude = -119.571105
                
                // San Francisco
                //let latitude = 37.753920
                //let longitude = -122.448599
                
                // Las Vegas
                //let latitude = 36.183127
                //let longitude = -115.229875
                
                // Las Vegas+
                //let latitude = 36.057468
                //let longitude = -115.309040
                
                // Spanish Springs +
                //let latitude = 39.747262
                //let longitude = -119.687126
                
                // Spanish Springs
                //let latitude = 39.660071
                //let longitude = -119.697107
                
                let deadlineTime = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    
                    // Anaheim
                    //let latitude = 33.794137
                    //let longitude = -117.806426
                    
                    //Kremen
                    //let latitude = 49.094534
                    //let longitude = 33.445375
                    
                    //Costa Messa
                    //let latitude = 33.641132
                    //let longitude = -117.918671
                    
                    
                    guard let loc = self.locationManager.location?.coordinate else {
                        print ("ERROR: Location = nil")
                       
                        return
                    }
                    
                    let latitude = loc.latitude
                    let longitude = loc.longitude
                    
                    GlobalShared.currentLocationCoordinate.latitude = latitude
                    GlobalShared.currentLocationCoordinate.longitude = longitude
                    
                    Utill.printInTOConsole(printData:"/////locations = \(String(describing: GlobalShared.currentLocationCoordinate.latitude)) \(String(describing: GlobalShared.currentLocationCoordinate.longitude))")
                    completion?()
                    
                    //                    Utill.printInTOConsole(printData:"/////locations = \(String(describing: self.locationManager.location?.coordinate.latitude)) \(String(describing: self.locationManager.location?.coordinate.longitude))")
                    //
                    //                    if let coordinate = self.locationManager.location?.coordinate {
                    //                        GlobalShared.currentLocationCoordinate = coordinate
                    //                        completion?()
                    //                    }
                }
                break
            }
        } else {
            Utill.showAlertViewOnWindow(message: Text.Message.allowLocation)
            completion?()
        }
    }
}

//MARK: - Simple Notiification
extension AppDelegate {
    
    private func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                Utill.printInTOConsole(printData:"Permission granted: \(granted)")
                
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                Utill.printInTOConsole(printData:"Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}


//MARK: - DeepLinking VenueProfile
extension AppDelegate {
    
    func reDirectToVenueProfile(redirectUrl : URL){
        for subView in (AppDel.window?.subviews)! {
            if (subView is WUVenueRateView) {
                subView.removeFromSuperview()
                break;
            }
            if (subView is WUTimeSheetView) {
                subView.removeFromSuperview()
                break;
            }
        }
        
        if (self.mainNavVC?.visibleViewController is WUTabbarViewController) {
            var arrNav = self.tabbar?.viewControllers as! [UINavigationController]
            var nvc : UINavigationController = arrNav[(self.tabbar?.selectedIndex)!]
            
            if redirectUrl.pathComponents.count > 0 {
                let venueID = redirectUrl.pathComponents[1]
                let fourceSquareID = redirectUrl.pathComponents[3]
                
                if self.tabbar?.selectedIndex == TabbarOptions.Home.rawValue {
                    
                    if (nvc.viewControllers.last as? WUHomeViewController) != nil{
                        if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                            vc.sponsoredVenuID = venueID
                            vc.fourSquareVenueId = fourceSquareID
                            nvc.pushViewController(vc, animated: false)
                        }
                    }else {
                        
                        if let vc = nvc.viewControllers.last as? WULiveCamProfileViewController {
                            vc.player?.pause()
                            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                        nvc.popToRootViewController(animated: false)
                        
                        if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                            vc.sponsoredVenuID = venueID
                            vc.fourSquareVenueId = fourceSquareID
                            nvc.pushViewController(vc, animated: false)
                        }
                    }
                }else {
                    self.tabbar?.selectIndexForTabbar(selectedIndex: TabbarOptions.Home)
                    nvc = arrNav[(self.tabbar?.selectedIndex)!]
                    if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                        vc.sponsoredVenuID = venueID
                        vc.fourSquareVenueId = fourceSquareID
                        nvc.pushViewController(vc, animated: false)
                    }
                }
            }
        }else if ((self.dissmissIfNavigationControllerPresented()) != nil){
            let vc : UIViewController = self.dissmissIfNavigationControllerPresented()!;
            vc.dismiss(animated: false, completion: {
                self.reDirectToVenueProfile(redirectUrl: redirectUrl)
            })
        }else  if (self.mainNavVC?.visibleViewController is WUSplashViewController){
            self.redirectUrl = redirectUrl
        }else {
            Utill.showAlertViewOnWindow(message: "Please login to the app")
        }
    }
    
     func reDirectToVenueProfile(venueID: String){
         for subView in (AppDel.window?.subviews)! {
             if (subView is WUVenueRateView) {
                 subView.removeFromSuperview()
                 break;
             }
             if (subView is WUTimeSheetView) {
                 subView.removeFromSuperview()
                 break;
             }
         }
         
         if (self.mainNavVC?.visibleViewController is WUTabbarViewController) {
             var arrNav = self.tabbar?.viewControllers as! [UINavigationController]
             var nvc : UINavigationController = arrNav[(self.tabbar?.selectedIndex)!]
             
             if venueID.count > 0 {
                 
                 if self.tabbar?.selectedIndex == TabbarOptions.Home.rawValue {
                     
                     if (nvc.viewControllers.last as? WUHomeViewController) != nil{
                         if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                             vc.sponsoredVenuID = venueID
                             nvc.pushViewController(vc, animated: false)
                         }
                     }else {
                         
                         if let vc = nvc.viewControllers.last as? WULiveCamProfileViewController {
                             vc.player?.pause()
                             UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                             UIViewController.attemptRotationToDeviceOrientation()
                         }
                         nvc.popToRootViewController(animated: false)
                         
                         if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                             vc.sponsoredVenuID = venueID
                             nvc.pushViewController(vc, animated: false)
                         }
                     }
                 }else {
                     self.tabbar?.selectIndexForTabbar(selectedIndex: TabbarOptions.Home)
                     nvc = arrNav[(self.tabbar?.selectedIndex)!]
                     if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                         vc.sponsoredVenuID = venueID
                         nvc.pushViewController(vc, animated: false)
                     }
                 }
             }
         }else if ((self.dissmissIfNavigationControllerPresented()) != nil){
             let vc : UIViewController = self.dissmissIfNavigationControllerPresented()!;
             vc.dismiss(animated: false, completion: {
                 self.reDirectToVenueProfile(venueID: venueID)
             })
         }else  if (self.mainNavVC?.visibleViewController is WUSplashViewController){
             //self.redirectUrl = redirectUrl
         }else {
             Utill.showAlertViewOnWindow(message: "Please login to the app")
         }
     }
    
    //MARK: - DeepLinking EventProfile
    func reDirectToEventProfile(redirectUrl : URL){
        for subView in (AppDel.window?.subviews)! {
            if (subView is WUVenueRateView) {
                subView.removeFromSuperview()
                break;
            }
            if (subView is WUTimeSheetView) {
                subView.removeFromSuperview()
                break;
            }
        }
        
        if (self.mainNavVC?.visibleViewController is WUTabbarViewController) {
            var arrNav = self.tabbar?.viewControllers as! [UINavigationController]
            var nvc : UINavigationController = arrNav[(self.tabbar?.selectedIndex)!]
            
            if redirectUrl.pathComponents.count > 0 {
                let eventID = redirectUrl.pathComponents[1]
                
                if self.tabbar?.selectedIndex == TabbarOptions.Events.rawValue {
                    
                    if (nvc.viewControllers.last as? WUEventHomeViewController) != nil{
                        if let vc : WUEventProfileViewController = UIStoryboard.events.get(WUEventProfileViewController.self){
                            vc.selectedEventId = eventID
                            nvc.pushViewController(vc, animated: false)
                        }
                    }else {
                        if let vc = nvc.viewControllers.last as? WULiveCamProfileViewController {
                            vc.player?.pause()
                            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                        nvc.popToRootViewController(animated: false)
                        
                        if let vc : WUEventProfileViewController = UIStoryboard.events.get(WUEventProfileViewController.self){
                            vc.selectedEventId = eventID
                            nvc.pushViewController(vc, animated: false)
                        }
                    }
                }else {
                    self.tabbar?.selectIndexForTabbar(selectedIndex: TabbarOptions.Events)
                    nvc = arrNav[(self.tabbar?.selectedIndex)!]
                    if let vc : WUEventProfileViewController = UIStoryboard.events.get(WUEventProfileViewController.self){
                        vc.selectedEventId = eventID
                        nvc.pushViewController(vc, animated: false)
                    }
                }
            }
        }
        else if ((self.dissmissIfNavigationControllerPresented()) != nil){
            let vc : UIViewController = self.dissmissIfNavigationControllerPresented()!;
            vc.dismiss(animated: false, completion: {
                self.reDirectToEventProfile(redirectUrl: redirectUrl)
            })
        }else  if (self.mainNavVC?.visibleViewController is WUSplashViewController){
            self.redirectUrl = redirectUrl
        }else {
            Utill.showAlertViewOnWindow(message: "Please login to the app")
        }
    }
    
    //MARK: - DeepLinking LiveCamProfile
    func reDirectToLiveCamProfile(redirectUrl : URL){
        for subView in (AppDel.window?.subviews)! {
            if (subView is WUVenueRateView) {
                subView.removeFromSuperview()
                break;
            }
            if (subView is WUTimeSheetView) {
                subView.removeFromSuperview()
                break;
            }
        }
        
        if (self.mainNavVC?.visibleViewController is WUTabbarViewController) {
            var arrNav = self.tabbar?.viewControllers as! [UINavigationController]
            var nvc : UINavigationController = arrNav[(self.tabbar?.selectedIndex)!]
            
            if redirectUrl.pathComponents.count > 0 {

                let liveCamId = redirectUrl.pathComponents[1]
                
                if self.tabbar?.selectedIndex == TabbarOptions.LiveCam.rawValue {
                    
                    if (nvc.viewControllers.last as? WULiveCamHomeViewController) != nil{
                        
                        if let vc : WULiveCamProfileViewController = UIStoryboard.liveCam.get(WULiveCamProfileViewController.self){
                            vc.liveCamID = liveCamId
                            nvc.pushViewController(vc, animated: false)
                        }
                    }else {
                        if let vc = nvc.viewControllers.last as? WULiveCamProfileViewController {
                            vc.isPopToBack = true
                            vc.liveCamID = liveCamId
                            //                            if vc.player != nil {
                            //                                    vc.player.pause()
                            //                                    vc.playerController.removeObserver(self, forKeyPath: "videoBounds")
                            //                            }
                            //                            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                            //                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                        nvc.popToRootViewController(animated: false)
                        
                        if let vc : WULiveCamProfileViewController = UIStoryboard.liveCam.get(WULiveCamProfileViewController.self){
                            vc.liveCamID = liveCamId
                            nvc.pushViewController(vc, animated: false)
                        }
                    }
                }else {
                    self.tabbar?.selectIndexForTabbar(selectedIndex: TabbarOptions.LiveCam)
                    nvc = arrNav[(self.tabbar?.selectedIndex)!]
                    if let vc : WULiveCamProfileViewController = UIStoryboard.liveCam.get(WULiveCamProfileViewController.self){
                        vc.liveCamID = liveCamId
                        nvc.pushViewController(vc, animated: false)
                    }
                }
            }
        }
        else if ((self.dissmissIfNavigationControllerPresented()) != nil){
            let vc : UIViewController = self.dissmissIfNavigationControllerPresented()!;
            vc.dismiss(animated: false, completion: {
                self.reDirectToLiveCamProfile(redirectUrl: redirectUrl)
            })
        }else  if (self.mainNavVC?.visibleViewController is WUSplashViewController){
            self.redirectUrl = redirectUrl
        }else {
            Utill.showAlertViewOnWindow(message: "Please login to the app")
        }
    }
    
    
    func dissmissIfNavigationControllerPresented() -> UIViewController?{
        if (self.mainNavVC?.presentedViewController is UIActivityViewController){
            return self.mainNavVC?.presentedViewController
        }else if (self.mainNavVC?.presentedViewController is SLComposeViewController){
            return self.mainNavVC?.presentedViewController
        }else if (self.mainNavVC?.presentedViewController is EKEventEditViewController){
            return self.mainNavVC?.presentedViewController
        }else if (self.mainNavVC?.presentedViewController is UIImagePickerController){
            return self.mainNavVC?.presentedViewController
        }else if (self.mainNavVC?.presentedViewController is UIAlertController){
            return self.mainNavVC?.presentedViewController
        }
        return nil
    }
}


//extension Date{
//    /// Returns the amount of hours from another date
//    func hours(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
//    }
//    /// Returns the a custom time interval description from another date
//    func offset(from date: Date) -> String {
//        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
//        return ""
//    }
//}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        GlobalShared.deviceToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("userInfo \(remoteMessage.appData)")
        self.receivedPushNotification(remoteMessage.appData)
    }
}

// MARK: - AFDropDown Notifination Delegate Methods
extension AppDelegate : AFDropdownNotificationDelegate {
    
    func receivedPushNotification(_ userInfo : [AnyHashable : Any]?) {
        self.NotificationUserInfo = userInfo
        if self.tabbar != nil {
            let isAppActive = UIApplication.shared.applicationState.rawValue == 0 ? true : false
            self.handalFavoriteVenueNotificationState(isAppActive)
        }
    }
    
    // MARK: - Handle Notification
    func handalFavoriteVenueNotificationState(_ isAppActive : Bool) {
        if (isAppActive) {
            performActionOnNotificationTap = true
            self.callWS_GetTotalUnreadNotification()
            self.showNotificationWithDetail()
            if (self.tabbar?.selectedIndex)! == TabbarOptions.Favorite.rawValue{
                self.checkFavoriteNotification()
            }
        }else{
            performActionOnNotificationTap = false
            DispatchQueue.main.async {
                Utill.hideProgressHud()
            }
            self.checkFavoriteNotification()
        }
    }
    
    func showNotificationWithDetail(){
        DispatchQueue.main.async {
            let dic : [String : Any] = self.NotificationUserInfo![AnyHashable("aps")] as! [String : Any]
            let dicAlert : [String : Any] = dic["alert"] as! [String : Any]
            self.notificationV?.subtitleText = dicAlert["body"] as! String
            self.notificationV?.titleText = dicAlert["title"] as! String
            self.notificationV?.dismissOnTap = true
            self.notificationV?.btnTap.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            self.notificationV?.present(in: self.mainNavVC?.visibleViewController?.view, withGravityAnimation: true)
            self.notificationV?.listenEvents({ (event : AFDropdownNotificationEvent) in
                switch(event) {
                case .topButton:
                    break
                case .bottomButton:
                    break
                case .tap:
                    break
                }
            })
            
            var duration : Float = Float((self.notificationV?.titleText.count)!/8)
            if duration > 15{
                duration = 15
            }else if(duration < 10){
                duration = 10
            }
            self.perform(#selector(self.removeNotificationView), with: nil, afterDelay: TimeInterval(duration))
            print ("show notification")
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        guard let userInfo = self.NotificationUserInfo else {return}
        guard let venueID = (userInfo["VenueID"] as? String) else {return}
        self.reDirectToVenueProfile(venueID: venueID)
    }

    
    @objc func removeNotificationView(){
        //        NSLog("removeNotificationView")
        if (notificationV?.isBeingShown == true) {
            notificationV?.dismiss(withGravityAnimation: true) ;
        }
    }
    // AFDropDown Notifination Delegate Methods
    func dropdownNotificationTopButtonTapped(){
        self.notificationV?.dismiss(withGravityAnimation: true) ;
    }
    
    func dropdownNotificationBottomButtonTapped(){
        self.notificationV?.dismiss(withGravityAnimation: true) ;
    }
    
    func dropdownNotificationViewTapped() {
        notificationV?.dismiss(withGravityAnimation: true) ;
        self.checkFavoriteNotification()
    }
    
    func checkFavoriteNotification(){
        if let strClickAction : String = NotificationUserInfo![AnyHashable("SourceTable")] as? String,strClickAction.replacingOccurrences(of: "", with: " ").lowercased() == "FavoriteVenue".lowercased(){
            if let _ = NotificationUserInfo![AnyHashable("VenueID")] {
                self.redirectToFavoriteVenue()
            }
        }
    }
    
    func redirectToFavoriteVenue()
    {
        for subView in (AppDel.window?.subviews)! {
            if (subView is WUVenueRateView) {
                subView.removeFromSuperview()
                break;
            }
            if (subView is WUTimeSheetView) {
                subView.removeFromSuperview()
                break;
            }
        }
        
        if (self.mainNavVC?.visibleViewController is WUTabbarViewController) {
            var arrNav = self.tabbar?.viewControllers as! [UINavigationController]
            let nvc : UINavigationController = arrNav[(self.tabbar?.selectedIndex)!]
            if (self.tabbar?.selectedIndex)! != TabbarOptions.Favorite.rawValue
            {
                self.tabbar?.selectIndexForTabbar(selectedIndex: .Favorite)
            }
            if (nvc.viewControllers.last as? WUFavoriteHomeViewController) != nil{
                nvc.popToRootViewController(animated: false)
            }
            let offset = CGPoint.init(x: 0, y:0)
            
            if let nav = self.tabbar?.viewControllers![(self.tabbar?.selectedIndex)!] as? UINavigationController
            {
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
        }
        else if ((self.dissmissIfNavigationControllerPresented()) != nil){
            let vc : UIViewController = self.dissmissIfNavigationControllerPresented()!;
            vc.dismiss(animated: false, completion: {
                self.redirectToFavoriteVenue()
            })
        }else {
            Utill.showAlertViewOnWindow(message: "Please login to the app")
        }
        
    }
}

//    userInfo [AnyHashable("SourceTable"): FavoriteVenue, AnyHashable("ID"): 16, AnyHashable("VenuePromotionID"): 10101, AnyHashable("google.c.a.e"): 1, AnyHashable("UserID"): 1123, AnyHashable("VenueID"): 5, AnyHashable("gcm.message_id"): 0:1537875841921888%bb6471e0bb6471e0, AnyHashable("aps"): {
//    alert =     {
//    body = "New promotion has been added for Napa Sonoma Grocery Company";
//    title = FavoriteVenue;
//    };
//    }, AnyHashable("VenueSpecialID"): ]
//





