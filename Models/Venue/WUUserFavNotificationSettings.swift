//
//  WUUserFavNotificationSettings.swift
//  Wussup
//
//  Created by MAC219 on 7/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
/*
 {
 "UserFavoriteVenueID": "10018",
 "IsSendPromotionalAlert": "True",
 "IsSendCustomNotification": "False",
 "PerDay": "0",
 "PerWeek": "0",
 "PerMonth": "0",
 "IsWeekEndNotification": "False",
 "IsSpecialEventNotification": "False"
 }
 */
class WUUserFavNotificationSettings : NSObject, Decodable {
   
    var UserFavoriteVenueID         : String    = "0"
    var IsSendPromotionalAlert      : String    = "false"
    var IsSendCustomNotification    : String    = "false"
    var PerDay                      : String    = ""
    var PerWeek                     : String    = ""
    var PerMonth                    : String    = ""
    var IsWeekEndNotification       : String    = "false"
    var IsSpecialEventNotification  : String    = "false"
    
    private enum CodingKeys: String, CodingKey {
        
        case UserFavoriteVenueID
        case IsSendPromotionalAlert
        case IsSendCustomNotification
        case PerDay
        case PerWeek
        case PerMonth
        case IsWeekEndNotification
        case IsSpecialEventNotification
    }
    
    override init() {
        
    }
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let UserFavoriteVenueID = try values.decodeIfPresent(String.self, forKey: .UserFavoriteVenueID){
                self.UserFavoriteVenueID = UserFavoriteVenueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .UserFavoriteVenueID) {
                self.UserFavoriteVenueID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in UserFavoriteVenueID for WUUserFavNotificationSettings ")
        }
        
        do {
            if let IsSendPromotionalAlert = try values.decodeIfPresent(String.self, forKey: .IsSendPromotionalAlert){
                self.IsSendPromotionalAlert = IsSendPromotionalAlert
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSendPromotionalAlert) {
                self.IsSendPromotionalAlert = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in IsSendPromotionalAlert for WUUserFavNotificationSettings ")
        }
        
        do {
            if let IsSendCustomNotification = try values.decodeIfPresent(String.self, forKey: .IsSendCustomNotification){
                self.IsSendCustomNotification = IsSendCustomNotification
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSendCustomNotification) {
                self.IsSendCustomNotification = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in IsSendCustomNotification for WUUserFavNotificationSettings ")
        }
        
        do {
            if let PerDay = try values.decodeIfPresent(String.self, forKey: .PerDay){
                self.PerDay = PerDay
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .PerDay) {
                self.PerDay = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in PerDay for WUUserFavNotificationSettings ")
        }
        
        do {
            if let PerWeek = try values.decodeIfPresent(String.self, forKey: .PerWeek){
                self.PerWeek = PerWeek
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .PerWeek) {
                self.PerWeek = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in PerWeek for WUUserFavNotificationSettings ")
        }
        
        do {
            if let PerMonth = try values.decodeIfPresent(String.self, forKey: .PerMonth){
                self.PerMonth = PerMonth
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .PerMonth) {
                self.PerMonth = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in PerMonth for WUUserFavNotificationSettings ")
        }
        
        do {
            if let IsWeekEndNotification = try values.decodeIfPresent(String.self, forKey: .IsWeekEndNotification){
                self.IsWeekEndNotification = IsWeekEndNotification
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsWeekEndNotification) {
                self.IsWeekEndNotification = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in IsWeekEndNotification for WUUserFavNotificationSettings ")
        }
        
        do {
            if let IsSpecialEventNotification = try values.decodeIfPresent(String.self, forKey: .IsSpecialEventNotification){
                self.IsSpecialEventNotification = IsSpecialEventNotification
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSpecialEventNotification) {
                self.IsSpecialEventNotification = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in IsSpecialEventNotification for WUUserFavNotificationSettings ")
        }
    }
}

extension WUUserFavNotificationSettings: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(UserFavoriteVenueID, forKey: .UserFavoriteVenueID)
        try container.encodeIfPresent(IsSendPromotionalAlert, forKey: .IsSendPromotionalAlert)
        try container.encodeIfPresent(IsSendCustomNotification, forKey: .IsSendCustomNotification)
        try container.encodeIfPresent(PerDay, forKey: .PerDay)
        try container.encodeIfPresent(PerWeek, forKey: .PerWeek)
        try container.encodeIfPresent(PerMonth, forKey: .PerMonth)
        try container.encodeIfPresent(IsWeekEndNotification, forKey: .IsWeekEndNotification)
        try container.encodeIfPresent(IsSpecialEventNotification, forKey: .IsSpecialEventNotification)
       
    }
}


