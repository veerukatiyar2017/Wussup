//
//  WUVenueLiveMusic.swift
//  Wussup
//
//  Created by MAC26 on 16/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenueLiveMusic: NSObject, Decodable {
    var ID                  : String    = "0"
    var VenueID             : String    = "0"
    var ImageURL            : String    = ""
    var Height              : String    = ""
    var Width               : String    = ""
    var isAddedToCalendar   : Bool      = false
    var HeightFloat         : CGFloat   = 0.0
    var WidthFloat          : CGFloat   = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case VenueID
        case ImageURL
        case Height
        case Width
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID){
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in ID for WUVenueLiveMusic ")
        }
        
        do {
            if let VenueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = VenueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in VenueID for WUVenueLiveMusic ")
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
            Utill.printInTOConsole(printData:"solvedtype mismatched in ImageURL for WUVenueLiveMusic ")
        }
        
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveMusic for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveMusic for Width ")
        }
    }
}

extension WUVenueLiveMusic: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(VenueID, forKey: .VenueID)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
    }
}

