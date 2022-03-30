//
//  WUUserNotificationsViewController.swift
//  Wussup
//
//  Created by Alexandr on 21.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

struct UserNotifications: Codable {
    
    var Notifications         : [WUUserNotificationSettings] = []
    var Date                  : String = ""
}

struct UserNotificationsArray: Codable {
    var NotificationsList       : [UserNotifications] = []
}


class WUUserNotificationsViewController: UIViewController {
    
    // MARK: - Variables
    
    var userNotificationsArray  : [UserNotifications] = []
    var cellHeights: [IndexPath : CGFloat] = [:]

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.GetNotification()
        AppDel.callWS_GetTotalUnreadNotification()
    }
 
    
    
      // MARK: - Webservice Methods
    
    private  func GetNotification() {

        WEB_API.call_api_GetNotification(user: GlobalShared.user) { (response, success, message) in
            if success{
                let data = try! JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: [])
                self.userNotificationsArray = try! JSONDecoder().decode(UserNotificationsArray.self, from: data).NotificationsList
                
                self.tableView.reloadData()
            }
        }
      }
    
    private func removeNotification(_ notificationId: String) {

        WEB_API.call_api_RemoveNotification(notificationId: notificationId) { (response, success, message) in
            if success{
                
            }
        }
      }
}


extension WUUserNotificationsViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.userNotificationsArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        self.userNotificationsArray[section].Notifications.count
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)-> String? {

        self.userNotificationsArray[section].Date.capitalized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 10, y: 0, width: self.view.frame.width - 20, height: 40)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        titleLabel.textAlignment = .left
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)?.uppercased()
        
        let headerView = UIView()
        headerView.addSubview(titleLabel)

        return headerView
    }
 
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userNotificationCell", for: indexPath)  as! WUUserNotificationCell
        cell.setupCell(with: self.userNotificationsArray[indexPath.section].Notifications[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venueID = self.userNotificationsArray[indexPath.section].Notifications[indexPath.row].VenueID
        let notificationId = self.userNotificationsArray[indexPath.section].Notifications[indexPath.row].NotificationId
        
        if venueID.count > 0{
           if let vc : WUVenueProfileViewController = UIStoryboard.venue.get(WUVenueProfileViewController.self){
                vc.sponsoredVenuID = venueID
            if notificationId != "0" && (Int(notificationId) != nil){
                
                WEB_API.call_api_MarkOneNotificationAsRead(user: GlobalShared.user, notificationID: Int(notificationId)!) { (response, success, message) in
                    
                    if success == true {
                        print("Sucess callWS_MarkOneNotificationAsRead")
                        
                        if GlobalShared.notifciationCount > 0 {

                            if GlobalShared.notifciationCount > 0 {
                                GlobalShared.notifciationCount = response!["TotalUnreadCount"].intValue
                                UIApplication.shared.applicationIconBadgeNumber = GlobalShared.notifciationCount
                                
                                if GlobalShared.notifciationCount == 0 {
                                    GlobalShared.appTabbarController?.buttonNotificationCount.isHidden = true
                                } else {
                                    GlobalShared.appTabbarController?.buttonNotificationCount.isHidden = false
                                    GlobalShared.appTabbarController?.buttonNotificationCount.setTitle("\(GlobalShared.notifciationCount)", for: .normal)
                                }
                            }
                            
                        }
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                    } else {
                        print(" Not Sucess callWS_MarkOneNotificationAsRead")
                    }
                }
                }
            }

        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let leftAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
               self.tableView.beginUpdates()
               self.removeNotification(self.userNotificationsArray[indexPath.section].Notifications[indexPath.row].NotificationId)
               self.userNotificationsArray[indexPath.section].Notifications.remove(at: indexPath.row)
               self.tableView.deleteRows(at: [indexPath], with: .fade)
               self.tableView.endUpdates()
               

            success(true)
           })
        
            leftAction.image = UIImage(named: "")
            leftAction.backgroundColor = .red
        
           return UISwipeActionsConfiguration(actions: [leftAction])
       }

      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if (editingStyle == .delete){
            
            self.tableView.beginUpdates()
            self.removeNotification(self.userNotificationsArray[indexPath.section].Notifications[indexPath.row].NotificationId)
            self.userNotificationsArray[indexPath.section].Notifications.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
       

        }
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableViewAutomaticDimension
    }
    
}
