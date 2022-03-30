//
//  WUUserFavNotificationSettings.swift
//  Wussup
//
//  Created by MAC219 on 7/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUUserNotificationSettings : NSObject, Decodable {
   
    var NotificationId              : String    = ""
    var CategoryImage               : String    = ""
    var `Type`                      : String    = ""
    var HasRead                     : Bool      = false
    var CategoryId                  : String    = ""
    var ImageURL                    : String    = ""
    var Date                        : String    = ""
    var VenueName                   : String    = ""
    var VenueID                     : String    = ""
    var VenueFourSquareID           : String    = ""
    var City                        : String    = ""
    var State                       : String    = ""
    var NotificationType            : String    = ""
    
    private enum CodingKeys: String, CodingKey {

        case NotificationId
        case CategoryImage
        case `Type`
        case HasRead
        case ImageURL
        case Date
        case VenueName
        case VenueID
        case VenueFourSquareID
        case City
        case State
        case NotificationType
    }
    
    override init() {
        
    }
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
      
        do {
            if let NotificationId = try values.decodeIfPresent(String.self, forKey: .NotificationId){
                self.NotificationId = NotificationId
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .NotificationId) {
                self.NotificationId = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for NotificationId ")
        }
        
        
        do {
            if let CategoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = CategoryImage
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for CategoryImage ")
        }
        
        do {
            if let `Type` = try values.decodeIfPresent(String.self, forKey: .Type){
                self.`Type` = `Type`
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for `Type` ")
        }
        
        do {
            if let HasRead = try values.decodeIfPresent(Bool.self, forKey: .HasRead){
                self.HasRead = HasRead
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for HasRead ")
        }
        
        do {
            if let ImageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL){
                self.ImageURL = ImageURL
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for ImageURL ")
        }
        
        do {
            if let Date = try values.decodeIfPresent(String.self, forKey: .Date){
                self.Date = Date
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for Date ")
        }
        
        do {
            if let VenueName = try values.decodeIfPresent(String.self, forKey: .VenueName){
                self.VenueName = VenueName
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for VenueName ")
        }
        
        do {
            if let VenueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = VenueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for VenueID ")
        }
        
        do {
            if let VenueFourSquareID = try values.decodeIfPresent(String.self, forKey: .VenueFourSquareID){
                self.VenueFourSquareID = VenueFourSquareID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueFourSquareID) {
                self.VenueFourSquareID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for VenueFourSquareID ")
        }
        
        do {
            if let City = try values.decodeIfPresent(String.self, forKey: .City){
                self.City = City
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for City ")
        }
        
        do {
            if let State = try values.decodeIfPresent(String.self, forKey: .State){
                self.State = State
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for State ")
        }
        
        
        do {
            if let NotificationType = try values.decodeIfPresent(String.self, forKey: .NotificationType){
                self.NotificationType = NotificationType
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUUserNotificationSettings for NotificationType ")
        }
    }
}

extension WUUserNotificationSettings: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(NotificationId, forKey: .NotificationId)
        try container.encodeIfPresent(CategoryImage, forKey: .CategoryImage)
        try container.encodeIfPresent(`Type`, forKey: .`Type`)
        try container.encodeIfPresent(HasRead, forKey: .HasRead)
        try container.encodeIfPresent(ImageURL, forKey: .ImageURL)
        try container.encodeIfPresent(Date, forKey: .Date)
        try container.encodeIfPresent(VenueName, forKey: .VenueName)
        try container.encodeIfPresent(VenueID, forKey: .VenueID)
        try container.encodeIfPresent(VenueFourSquareID, forKey: .VenueFourSquareID)
        try container.encodeIfPresent(City, forKey: .City)
        try container.encodeIfPresent(State, forKey: .State)
        try container.encodeIfPresent(NotificationType, forKey: .NotificationType)
    }
}
