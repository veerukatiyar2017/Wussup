//
//  WUVenueMenus.swift
//  Wussup
//
//  Created by MAC26 on 17/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//
/*MenuImageURL": "https://foursquare.com/v/4c112ddece640f472e253b52/device_menu",
"Name": null,
"GetSubMenuTypes":[]*/

import UIKit

class WUVenueMenus: NSObject, Decodable {
    
    var isAddedToCalendar   : Bool      = false
    var MenuImageURL        : String    = ""
    var Name                : String    = ""
    var GetSubMenuTypes     : [String]  = []
    var Height              : String        = ""
    var Width               : String        = ""
    var HeightFloat         : CGFloat       = 0.0
    var WidthFloat          : CGFloat       = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case MenuImageURL
        case Name
        case GetSubMenuTypes
        case Height
        case Width
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let MenuImageURL = try values.decodeIfPresent(String.self, forKey: .MenuImageURL){
                if URL(string: MenuImageURL) != nil {
                    self.MenuImageURL = MenuImageURL
                }
                else {
                    self.MenuImageURL = MenuImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solved type mismatched in WUVenueMenus for MenuImageURL ")
        }
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueMenus for Name ")
        }
        
        do {
            if let GetSubMenuTypes = try values.decodeIfPresent([String].self, forKey: .GetSubMenuTypes){
                self.GetSubMenuTypes = GetSubMenuTypes
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueMenus for GetSubMenuTypes ")
        }
        
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueMenus for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueMenus for Width ")
        }
    }
}

extension WUVenueMenus: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(MenuImageURL, forKey: .MenuImageURL)
        try container.encode(Name, forKey: .Name)
        try container.encode(GetSubMenuTypes, forKey: .GetSubMenuTypes)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
    }
}


    
    

