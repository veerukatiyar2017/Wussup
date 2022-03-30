//
//  WUHomeBannerList.swift
//  Wussup
//
//  Created by MAC219 on 7/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "ID": "270",
 "Title": "Hardware",
 "VenuePromotionID": "30",
 "GUID": "30",
 "VenueID": "49",
 "VenueFourSquareID": "4fa31ca5e4b0e9668154d634",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636706302422436669.png",
 "Width": "512",
 "Height": "512
 */
class WUHomeBannerList:NSObject, Decodable {
    var ID                  : String    = "0"
    var Title               : String    = ""
    var VenuePromotionID    : String    = "0"
    var GUID                : String    = ""
    var VenueID             : String    = "0"
    var VenueFourSquareID   : String    = ""
    var ImageURL            : String    = ""
    var Width               : String    = "0"
    var Height              : String    = "0"
    var HeightFloat         : CGFloat   = 0.0
    var WidthFloat          : CGFloat   = 0.0
    var VenueStatusID       : Int       = 0
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case Title
        case VenuePromotionID
        case GUID
        case VenueID
        case VenueFourSquareID
        case ImageURL
        case Width
        case Height
        case VenueStatusID
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n ID                  : \(ID)"
        printString += "\n Title               : \(Title)"
        printString += "\n VenuePromotionID    : \(VenuePromotionID)"
        printString += "\n GUID                : \(GUID)"
        printString += "\n VenueID             : \(VenueID)"
        printString += "\n VenueFourSquareID   : \(VenueFourSquareID)"
        printString += "\n ImageURL            : \(ImageURL)"
        printString += "\n Width               : \(Width)"
        printString += "\n Height              : \(Height)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID){
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for ID ")
        }
        
        do {
            if let Title = try values.decodeIfPresent(String.self, forKey: .Title){
                self.Title = Title
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for Title ")
        }
        
        do {
            if let VenuePromotionID = try values.decodeIfPresent(String.self, forKey: .VenuePromotionID){
                self.VenuePromotionID = VenuePromotionID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenuePromotionID) {
                self.VenuePromotionID = String(val)
            }
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for VenuePromotionID ")
        }
        
        do {
            if let GUID = try values.decodeIfPresent(String.self, forKey: .GUID){
                self.GUID = GUID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for GUID ")
        }
        
        do {
            if let VenueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = VenueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for VenueID ")
        }
        
        do {
            if let VenueFourSquareID = try values.decodeIfPresent(String.self, forKey: .VenueFourSquareID){
                self.VenueFourSquareID = VenueFourSquareID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueFourSquareID) {
                self.VenueFourSquareID = String(val)
            }
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for VenueFourSquareID ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for ImageURL ")
        }
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for Width ")
        }
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeBannerList for Height ")
        }
        do {
            if let VenueStatusID = try values.decodeIfPresent(Int.self, forKey: .VenueStatusID){
                self.VenueStatusID = VenueStatusID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUHomeBannerList for VenueStatusID ")
        }
    }
}

extension WUHomeBannerList: Encodable {
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(Title, forKey: .Title)
        try container.encode(VenuePromotionID, forKey: .VenuePromotionID)
        try container.encode(GUID, forKey: .GUID)
        try container.encode(VenueID, forKey: .VenueID)
        try container.encode(VenueFourSquareID, forKey: .VenueFourSquareID)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(Width, forKey: .Width)
        try container.encode(Height, forKey: .Height)
        try container.encode(VenueStatusID, forKey: .VenueStatusID)
    }
}
