//
//  WUEventPromotor.swift
//  Wussup
//
//  Created by MAC219 on 6/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
/*
 "EventID": "6",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636638070270892728.png",
 "Name": "Promotor1",
 "Description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
 */

class WUEventPromotor: NSObject,Decodable {

    var EventID         : String    = "0"
    var ImageURL        : String    = ""
    var Name            : String    = ""
    var Description     : String    = ""
    var Height          : String    = ""
    var Width           : String    = ""
    var isExpanded      : Bool      = false
    var HeightFloat     : CGFloat   = 0.0
    var WidthFloat     : CGFloat    = 0.0
    
    private enum CodingKeys: String, CodingKey {

        case EventID
        case ImageURL
        case Name
        case Description
        case Height
        case Width
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let EventID = try values.decodeIfPresent(String.self, forKey: .EventID){
                self.EventID = EventID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .EventID) {
                self.EventID = String(val)
            }
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventPromotor for EventID ")
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
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromotor for ImageURL ")
        }
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromotor for Name ")
        }
        
        do {
            if let Description = try values.decodeIfPresent(String.self, forKey: .Description){
                self.Description = Description
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromotor for Description ")
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromotor for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromotor for Width ")
        }
    }
}

extension WUEventPromotor: Encodable {
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(EventID, forKey: .EventID)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(Name, forKey: .Name)
        try container.encode(Description, forKey: .Description)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
    }
}
