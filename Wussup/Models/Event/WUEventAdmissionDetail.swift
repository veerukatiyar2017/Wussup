//
//  WUEventAdmissionDetail.swift
//  Wussup
//
//  Created by MAC219 on 9/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
/*
 Name": "ADMISSION",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Admission@3x.png",
 "EventAdmission":[{"ImageURL": "https://wussup-sandbox.s3.amazonaws.com/App_Images/SpecialEvent2%402x.png",…],
 "Height": null,
 "Width": null
 */
class WUEventAdmissionDetail: NSObject ,Decodable{
    
    var Name            : String            = ""
    var ImageURL        : String            = ""
    var EventAdmission  :[WUMoreEvent]      = []
    var Height          : String            = ""
    var Width           : String            = ""
    var HeightFloat     : CGFloat           = 0.0
    var WidthFloat      : CGFloat           = 0.0
    var isExpanded      : Bool              = false
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case ImageURL
        case EventAdmission
        case Height
        case Width
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws{
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventAdmissionDetail for Name ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUEventAdmissionDetail for ImageURL ")
        }
        
        do {
            if let EventAdmission = try values.decodeIfPresent([WUMoreEvent].self, forKey: .EventAdmission){
                self.EventAdmission = EventAdmission
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventAdmissionDetail for EventAdmission ")
        }
        
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventAdmissionDetail for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventAdmissionDetail for Width ")
        }
    }
}

extension WUEventAdmissionDetail: Encodable{
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(EventAdmission, forKey: .EventAdmission)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
    }
}


