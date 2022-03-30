//
//  WUUserCustomNotificationTableCell.swift
//  Wussup
//
//  Created by MAC219 on 7/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

@objc enum NotificationButtonTag : Int{
    case perDay =  5010
    case perWeek
    case perMonth
    case weekends
    case specialEvents
    case done
    case promotionalSwitchTag
    case notificationFrequency
    case customNotification
}

// MARK: - Delegate
protocol WUUserCustomNotificationTableCellDelegate : class {
    func buttonActions(buttonType : NotificationButtonTag , cell : WUUserCustomNotificationTableCell , button : UIButton)
    func buttonToggleSwitchActions(buttonType : NotificationButtonTag , cell : UITableViewCell )
}
extension WUUserCustomNotificationTableCellDelegate {
    func buttonActions(buttonType : NotificationButtonTag , cell : WUUserCustomNotificationTableCell , button : UIButton){
        
    }
    func buttonToggleSwitchActions(buttonType : NotificationButtonTag , cell : UITableViewCell ){
        
    }
}


class WUUserCustomNotificationTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var viewNotificationNameTitle    : UIView!
    @IBOutlet private weak var labelNotificationTitle       : UILabel!
    @IBOutlet private weak var labelCustomNotification      : UILabel!
    @IBOutlet weak var switchToggle                         : UISwitch!
    @IBOutlet private weak var viewDone                     : UIView!
    @IBOutlet weak var buttonPerDay                         : UIButton!
    @IBOutlet weak var buttonPerWeek                        : UIButton!
    @IBOutlet weak var buttonPerMonth                       : UIButton!
    @IBOutlet weak var buttonWeekends                       : UIButton!
    @IBOutlet weak var buttonSpecialEvents                  : UIButton!
    @IBOutlet weak var buttonDone                           : UIButton!
    @IBOutlet weak var buttonDayText                        : UIButton!
    @IBOutlet weak var buttonWeekText                       : UIButton!
    @IBOutlet weak var buttonMonthText                      : UIButton!
    // MARK: - Variables
    weak var delegate : WUUserCustomNotificationTableCellDelegate?
    
    var notificationDataSet : WUUserFavNotificationSettings! {
        didSet{
            self.setDetail()
        }
    }
    
    //MARK: - Load Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialInterfaceSetUp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Initial Interface SetUp
    
    private func initialInterfaceSetUp() {
        self.buttonDone.isSelected = false
        self.buttonDone.backgroundColor = .white
        
        self.buttonPerDay.tag           = NotificationButtonTag.perDay.rawValue
        self.buttonPerWeek.tag          = NotificationButtonTag.perWeek.rawValue
        self.buttonPerMonth.tag         = NotificationButtonTag.perMonth.rawValue
        self.buttonWeekends.tag         = NotificationButtonTag.weekends.rawValue
        self.buttonSpecialEvents.tag    = NotificationButtonTag.specialEvents.rawValue
        self.buttonDone.tag             = NotificationButtonTag.done.rawValue
        self.switchToggle.tag           = NotificationButtonTag.customNotification.rawValue
       
        if #available(iOS 11.0, *){
            self.viewNotificationNameTitle.layer.cornerRadius = 10
            self.viewNotificationNameTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewNotificationNameTitle.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            self.viewNotificationNameTitle.layer.mask = rectShape
        }
        if #available(iOS 11.0, *){
            self.viewDone.layer.cornerRadius = 10
            self.viewDone.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.viewDone.bounds,    byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            self.viewDone.layer.mask = rectShape
        }
        self.setAttributedStringForButtons()
    }
    
    private func setDetail(){
        self.buttonDayText.setTitle(self.notificationDataSet.PerDay == "0" ? "" : self.notificationDataSet.PerDay, for: .normal)
        self.buttonWeekText.setTitle(self.notificationDataSet.PerWeek == "0" ? "" : self.notificationDataSet.PerWeek, for: .normal)
        self.buttonMonthText.setTitle(self.notificationDataSet.PerMonth == "0" ? "" : self.notificationDataSet.PerMonth, for: .normal)
       
        if self.notificationDataSet.IsSendCustomNotification != ""{
          self.switchToggle.isOn = self.notificationDataSet.IsSendCustomNotification.toBool()!
        }
        if self.notificationDataSet.IsWeekEndNotification != ""{
            self.buttonWeekends.isSelected =  self.notificationDataSet.IsWeekEndNotification.toBool()!
        }
        
        if self.notificationDataSet.IsSpecialEventNotification != ""{
           self.buttonSpecialEvents.isSelected = self.notificationDataSet.IsSpecialEventNotification.toBool()!
        }
    }
    
    private func setAttributedStringForButtons(){
        
        self.buttonPerDay.setAttributedTitle(Utill.setAttributedStringForNotificationButton(str1: Text.Label.text_X, str2: Text.Label.text_PerDay, str1Color: .LightGrayColor), for: .normal)
        self.buttonPerDay.setAttributedTitle(Utill.setAttributedStringForNotificationButton(str1: Text.Label.text_X, str2: Text.Label.text_PerDay, str1Color: .BlueColor), for: .selected)
        
        self.buttonPerWeek.setAttributedTitle(Utill.setAttributedStringForNotificationButton(str1: Text.Label.text_X, str2: Text.Label.text_PerWeek, str1Color: .LightGrayColor), for: .normal)
        self.buttonPerWeek.setAttributedTitle(Utill.setAttributedStringForNotificationButton(str1: Text.Label.text_X, str2: Text.Label.text_PerWeek, str1Color: .BlueColor), for: .selected)
        
        self.buttonPerMonth.setAttributedTitle(Utill.setAttributedStringForNotificationButton(str1: Text.Label.text_X, str2: Text.Label.text_PerMonth, str1Color: .LightGrayColor), for: .normal)
        self.buttonPerMonth.setAttributedTitle(Utill.setAttributedStringForNotificationButton(str1: Text.Label.text_X, str2: Text.Label.text_PerMonth, str1Color: .BlueColor), for: .selected)
    
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.buttonActions(buttonType:NotificationButtonTag(rawValue: sender.tag)!, cell: self, button: self.buttonDone)
//            switch sender.tag {
//            case NotificationButtonTag.perDay.rawValue :
//                delegate.buttonActions!(buttonType: .perDay, cell: self)
//                break
//            case NotificationButtonTag.perWeek.rawValue :
//                delegate.buttonActions!(buttonType: .perWeek, cell: self)
//                break
//            case NotificationButtonTag.perMonth.rawValue :
//                delegate.buttonActions!(buttonType: .perMonth, cell: self)
//                break
//            case NotificationButtonTag.weekends.rawValue :
//                delegate.buttonActions!(buttonType: .weekends, cell: self)
//                break
//            case NotificationButtonTag.specialEvents.rawValue :
//                delegate.buttonActions!(buttonType: .specialEvents, cell: self)
//                break
//            case NotificationButtonTag.done.rawValue :
//                delegate.buttonActions!(buttonType: .done, cell: self)
//                break
//            default:
//                break
//            }
        }
    }
    
    @IBAction func switchToggleAction(_ sender: UISwitch) {
        if let delegate = self.delegate{
            delegate.buttonToggleSwitchActions(buttonType: NotificationButtonTag(rawValue: sender.tag)!, cell: self)
        }
    }
}
