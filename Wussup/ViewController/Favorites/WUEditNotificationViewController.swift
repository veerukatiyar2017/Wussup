//
//  WUEditNotificationViewController.swift
//  Wussup
//
//  Created by MAC219 on 6/26/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEditNotificationViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var toolbarHeight                : NSLayoutConstraint!
    @IBOutlet private weak var viewPickerHeight             : NSLayoutConstraint!
    @IBOutlet private weak var viewPicker                   : UIView!
    @IBOutlet private var pickerNumber                      : UIPickerView!
    @IBOutlet private weak var labelNavigationTitle         : UILabel!
    @IBOutlet private weak var tableViewEditNotification    : UITableView!
    
    //MARK: - Variable
    var isPickerDisplay : Bool = false
    var venueDetail : WUVenueDetail!
    var arrayNumber = Array(1...50)
    var selectedRowFromPicker : Int = 0
    var notificationButtons : NotificationButtonTag = .perDay
    
    //MARK: - Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInterfaceSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initial Setup
    private func initialInterfaceSetUp() {
        self.labelNavigationTitle.text = self.venueDetail.VenueName
        self.tableViewEditNotification.contentInset = UIEdgeInsetsMake(20, 0, 10, 0);
        self.toolbarHeight.constant = 0.0
        self.viewPickerHeight.constant = 0.0
    }
    
    // MARK: - Webservice calls
    private func callWS_UpdateUserFavoriteVenuesSetting(){
        
        WEB_API.call_api_UpdateUserFavoriteVenuesSetting(userNotification: self.venueDetail.UserFavoriteVenueNotificationSettings) { (response, success, message) in
           Utill.printInTOConsole(printData:"response: \(response ?? "")")
            if success == true{
                let data = try! JSONSerialization.data(withJSONObject: response?["UserFavoriteVenuesSetting"].dictionaryObject ?? [:], options: [])
                self.venueDetail.UserFavoriteVenueNotificationSettings = try! JSONDecoder().decode(WUUserFavNotificationSettings.self, from: data)
                WUUtill.showAlert_OK_ViewForTabManage(viewController: self, message: Text.Message.notficationUpdatedSuccessfully, completion: { (success) in
                    if success == true {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }else{
                 Utill.printInTOConsole(printData:"not call")
                Utill.showAlertView(viewController: self, message: message)
                self.tableViewEditNotification.reloadData()
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonCancelAction(_ sender: Any) {
        self.hideShowPickerView()
    }
    
    @IBAction func buttonDoneAction(_ sender: Any) {
         Utill.printInTOConsole(printData:"buttonDoneAction of ToolBAr")
        if let cell = self.tableViewEditNotification.cellForRow(at: IndexPath(row: 2, section: 0)) as? WUUserCustomNotificationTableCell{
            
            cell.buttonPerDay.isSelected    = false
            cell.buttonPerWeek.isSelected   = false
            cell.buttonPerMonth.isSelected  = false
            
            cell.buttonDayText.setTitle("", for: .normal)
            cell.buttonWeekText.setTitle("", for: .normal)
            cell.buttonMonthText.setTitle("", for: .normal)
            
            self.venueDetail.UserFavoriteVenueNotificationSettings.PerDay = "0"
            self.venueDetail.UserFavoriteVenueNotificationSettings.PerWeek = "0"
            self.venueDetail.UserFavoriteVenueNotificationSettings.PerMonth = "0"
            
            if self.notificationButtons == .perDay{
                cell.buttonPerDay.isSelected = true
                cell.buttonDayText.setTitle("\(self.arrayNumber[self.selectedRowFromPicker])", for: .normal)
                self.venueDetail.UserFavoriteVenueNotificationSettings.PerDay = "\(self.arrayNumber[self.selectedRowFromPicker])"
            }else if self.notificationButtons == .perWeek{
                cell.buttonPerWeek.isSelected = true
                cell.buttonWeekText.setTitle("\(self.arrayNumber[self.selectedRowFromPicker])", for: .normal)
                self.venueDetail.UserFavoriteVenueNotificationSettings.PerWeek = "\(self.arrayNumber[self.selectedRowFromPicker])"
            }else{
                cell.buttonPerMonth.isSelected = true
                cell.buttonMonthText.setTitle("\(self.arrayNumber[self.selectedRowFromPicker])", for: .normal)
                self.venueDetail.UserFavoriteVenueNotificationSettings.PerMonth = "\(self.arrayNumber[self.selectedRowFromPicker])"
            }
        }
        self.hideShowPickerView()
    }
    
    @IBAction func buttonSettingsAction(_ sender: UIButton) {
    }
}

//MARK: - TableView
extension WUEditNotificationViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            return 458.0
        }else{
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUUserCustomNotificationTableCell())) as! WUUserCustomNotificationTableCell
            cell.delegate = self
            cell.notificationDataSet = self.venueDetail.UserFavoriteVenueNotificationSettings
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Utill.getClassNameFor(classType: WUEditNotificationTableCell())) as! WUEditNotificationTableCell
            if indexPath.row == 0 {
                cell.labelNotificationTitle.text = Text.Label.text_PromotionNotification
                cell.labelName.text = Text.Label.text_OptIn
                cell.switchToggle.tag = NotificationButtonTag.promotionalSwitchTag.rawValue
                cell.switchToggle.isOn = self.venueDetail.UserFavoriteVenueNotificationSettings.IsSendPromotionalAlert.toBool()!
            }else{
                cell.labelNotificationTitle.text = Text.Label.text_NotificationFrequency
                cell.labelName.text = Text.Label.text_ReceiveAll
                cell.switchToggle.tag = NotificationButtonTag.notificationFrequency.rawValue
                cell.switchToggle.isOn = !self.venueDetail.UserFavoriteVenueNotificationSettings.IsSendCustomNotification.toBool()!
            }
            cell.delegate = self
            return cell
        }
    }
}
//MARK: - UIPickerViewDelegate
extension WUEditNotificationViewController :  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayNumber.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.arrayNumber[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRowFromPicker = row
    }
    
    func hideShowPickerView() {
        if !self.isPickerDisplay {
            UIView.animate(withDuration: 0.25, animations: {
                self.toolbarHeight.constant = 44.0
                self.viewPickerHeight.constant = 206.0
            }) { finished in
                 Utill.printInTOConsole(printData:"picker displayed")
                self.isPickerDisplay = true
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.toolbarHeight.constant = 0.0
                self.viewPickerHeight.constant = 0.0
            }) { finished in
                 Utill.printInTOConsole(printData:"picker hide")
                self.isPickerDisplay = false
            }
        }
    }
}
//MARK: - WUUserCustomNotificationTableCellDelegate
extension WUEditNotificationViewController : WUUserCustomNotificationTableCellDelegate{
    
    func buttonActions(buttonType: NotificationButtonTag, cell: WUUserCustomNotificationTableCell, button: UIButton) {
        
        notificationButtons =  buttonType
        
        switch buttonType.rawValue {
        case NotificationButtonTag.perDay.rawValue , NotificationButtonTag.perWeek.rawValue , NotificationButtonTag.perMonth.rawValue:
            if cell.switchToggle.isOn == true{
                self.hideShowPickerView()
            }
            break
        case NotificationButtonTag.weekends.rawValue :
            if cell.switchToggle.isOn == true{
                cell.buttonWeekends.isSelected = !cell.buttonWeekends.isSelected
                self.venueDetail.UserFavoriteVenueNotificationSettings.IsWeekEndNotification = "\(cell.buttonWeekends.isSelected)"
            }
            break
        case NotificationButtonTag.specialEvents.rawValue :
            if cell.switchToggle.isOn == true{
                cell.buttonSpecialEvents.isSelected = !cell.buttonSpecialEvents.isSelected
                self.venueDetail.UserFavoriteVenueNotificationSettings.IsSpecialEventNotification = "\(cell.buttonSpecialEvents.isSelected)"
            }
            break
        case NotificationButtonTag.done.rawValue :
            button.isSelected = true
            button.backgroundColor = UIColor.blueBackgroundColor
            self.callWS_UpdateUserFavoriteVenuesSetting()
            break
        default:
            break
        }
    }
    
    func buttonToggleSwitchActions(buttonType: NotificationButtonTag, cell: UITableViewCell) {
        switch buttonType.rawValue {
            
        case NotificationButtonTag.promotionalSwitchTag.rawValue :
            //             Utill.printInTOConsole(printData:"promotionalSwitchTag")
            (cell as! WUEditNotificationTableCell).switchToggle.isOn = !(cell as! WUEditNotificationTableCell).switchToggle.isOn
            self.venueDetail.UserFavoriteVenueNotificationSettings.IsSendPromotionalAlert = "\((cell as! WUEditNotificationTableCell).switchToggle.isOn)"
            break
        case  NotificationButtonTag.notificationFrequency.rawValue :
            //             Utill.printInTOConsole(printData:"notificationFrequency")
            (cell as! WUEditNotificationTableCell).switchToggle.isOn = !((cell as! WUEditNotificationTableCell).switchToggle.isOn)
            self.venueDetail.UserFavoriteVenueNotificationSettings.IsSendCustomNotification = "\(!((cell as! WUEditNotificationTableCell).switchToggle.isOn))"
            if self.isPickerDisplay
            {
                self.hideShowPickerView()
            }
            self.tableViewEditNotification.reloadData()
            break
        case NotificationButtonTag.customNotification.rawValue :
            //             Utill.printInTOConsole(printData:"customNotification")
            (cell as! WUUserCustomNotificationTableCell).switchToggle.isOn = !(cell as! WUUserCustomNotificationTableCell).switchToggle.isOn
            self.venueDetail.UserFavoriteVenueNotificationSettings.IsSendCustomNotification = "\((cell as! WUUserCustomNotificationTableCell).switchToggle.isOn)"
            self.tableViewEditNotification.reloadData()
            break
        default:
            break
        }
    }
}
