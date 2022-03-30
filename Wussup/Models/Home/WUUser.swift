//
//  WUUser.swift
//  Wussup
//
//  Created by MAC26 on 01/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit


/*{
 "Email" : "wussup@wu.com",
 "UserName" : "wussup@wu.com",
 "FacebookID" : null,
 "Birthdate" : null,
 "Longitude" : "",
 "ImageURL" : null,
 "FavoriteCategories" : [
 {
 "ID" : "4",
 "WussupName" : "Event",
 "Name" : "Event",
 "CategoryTypeID" : "1",
 "SelectedImageURL" : null,
 "ImageURL" : "https:\/\/s3.amazonaws.com\/wussup-sandbox\/App_Images\/EventsIcon%403x.png",
 "FourSquareCategoryID" : "4d4b7105d754a06373d81259",
 "RootCategoryID" : "",
 "UnSelectedImageURL" : null
 }
 ],
 "DateCreated" : "06\/22\/2018 10:31:23",
 "ID" : "26",
 "DeviceToken" : "",
 "Token" : null,
 "City" : null,
 "Latitude" : "",
 "DateModified" : "07\/04\/2018 01:46:41"
 }
 */

class WUUser: NSObject, Decodable {
    
    var Email               : String    = ""
    var UserName            : String    = ""
    var FacebookID          : String    = ""
    var Birthdate           : String    = ""
    var ImageURL            : String    = ""
    var ID                  : String    = "0"
    var DateCreated         : String    = ""
    var DateModified        : String    = ""
    var DeviceToken         : String    = ""
    var Token               : String    = ""
    var Latitude            : String    = ""
    var Longitude           : String    = ""
    var City               : String    = ""
    var FavoriteCategories  : [WUCategory] = []
    var IsAllowedNotification : String = "false"
    var Mobile : String = ""
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case DateCreated
        case DateModified
        case Email
        case UserName
        case FacebookID
        case ImageURL
        case DeviceToken
        case Token
        case Latitude
        case Longitude
        case FavoriteCategories
        case Birthdate
        case City
        case IsAllowedNotification
        case Mobile
    }
    
    override var description: String {
        var printString = ""
        
        printString += "\n*********************************"
        printString += "\n ID               : \(ID)"
        printString += "\n DateCreated      : \(DateCreated)"
        printString += "\n DateModified     : \(DateModified)"
        printString += "\n Email            : \(Email)"
        printString += "\n UserName         : \(UserName)"
        printString += "\n FacebookID       : \(FacebookID)"
        printString += "\n ImageURL         : \(ImageURL)"
        printString += "\n DeviceToken      : \(DeviceToken)"
        printString += "\n Token            : \(Token)"
        printString += "\n Latitude         : \(Latitude)"
        printString += "\n Longitude        : \(Longitude)"
        printString += "\n FavoriteCategories        : \(FavoriteCategories)"
        printString += "\n Birthdate        : \(Birthdate)"
        printString += "\n City             : \(City)"
        printString += "\n IsAllowedNotification             : \(IsAllowedNotification)"
        printString += "\n Mobile             : \(Mobile)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID) {
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUUser for ID ")
        }
        
        do {
            if let DateCreated = try values.decodeIfPresent(String.self, forKey: .DateCreated){
                self.DateCreated = DateCreated
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for DateCreated ")
        }
        
        do {
            if let DateModified = try values.decodeIfPresent(String.self, forKey: .DateModified){
                self.DateModified = DateModified
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for DateModified ")
        }
        
        do {
            if let Email = try values.decodeIfPresent(String.self, forKey: .Email){
                self.Email = Email
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for Email ")
        }
        
        do {
            if let UserName = try values.decodeIfPresent(String.self, forKey: .UserName){
                self.UserName = UserName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for UserName ")
        }
        
        do {
            if let FacebookID = try values.decodeIfPresent(String.self, forKey: .FacebookID) {
                self.FacebookID = FacebookID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solved type mismatched in WUUser for FacebookID ")
        }
        do {
            if let ImageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL){
                if URL(string: ImageURL) != nil {
                    self.ImageURL = ImageURL
                }
                else {
                    self.ImageURL = ImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for ImageURL ")
        }
        do {
            if let DeviceToken = try values.decodeIfPresent(String.self, forKey: .DeviceToken){
                self.DeviceToken = DeviceToken
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for DeviceToken ")
        }
        do {
            if let Token = try values.decodeIfPresent(String.self, forKey: .Token){
                self.Token = Token
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for Token ")
        }
        do {
            if let Latitude = try values.decodeIfPresent(String.self, forKey: .Latitude){
                self.Latitude = Latitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for Latitude ")
        }
        do {
            if let Longitude = try values.decodeIfPresent(String.self, forKey: .Longitude){
                self.Longitude = Longitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for Longitude ")
        }
        
        do {
            if let favoriteCategories = try values.decodeIfPresent(Array<WUCategory>.self, forKey: .FavoriteCategories){
                self.FavoriteCategories = favoriteCategories
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            Utill.printInTOConsole(printData:"type mismatched in WUUser for FavoriteCategories ")
        }
        
        do {
            if let birthdate = try values.decodeIfPresent(String.self, forKey: .Birthdate){
                self.Birthdate = birthdate
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for birthdate ")
        }
        
        do {
            if let city = try values.decodeIfPresent(String.self, forKey: .City){
                self.City = city
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for City ")
        }
        
        do {
            if let IsAllowedNotification = try values.decodeIfPresent(String.self, forKey: .IsAllowedNotification){
                self.IsAllowedNotification = IsAllowedNotification
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsAllowedNotification) {
                self.IsAllowedNotification = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUUser for IsAllowedNotification ")
        }
        
        do {
            if let Mobile = try values.decodeIfPresent(String.self, forKey: .Mobile){
                self.Mobile = Mobile
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUUser for Mobile ")
        }
    }
}

extension WUUser: Encodable{
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(DateCreated, forKey: .DateCreated)
        try container.encode(DateModified, forKey: .DateModified)
        try container.encode(Email, forKey: .Email)
        try container.encode(UserName, forKey: .UserName)
        try container.encodeIfPresent(FacebookID, forKey: .FacebookID)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(DeviceToken, forKey: .DeviceToken)
        try container.encode(Token, forKey: .Token)
        try container.encodeIfPresent(Latitude, forKey: .Latitude)
        try container.encode(Longitude, forKey: .Longitude)
        try container.encode(FavoriteCategories, forKey: .FavoriteCategories)
        try container.encode(City, forKey: .City)
        try container.encode(Birthdate, forKey: .Birthdate)
        try container.encode(IsAllowedNotification, forKey: .IsAllowedNotification)
         try container.encode(Mobile, forKey: .Mobile)
    }
}
