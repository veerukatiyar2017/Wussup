//
//  WUMoreEventDetail.swift
//  Wussup
//
//  Created by MAC219 on 6/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 {
 "Name": "More Events",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/MoreEventIcon@3x.png",
 "MoreEvents":[{"ID": "10", "Name": "Event5", "Description": "Same Test ",…]
 }
 */

class WUMoreEventDetail: NSObject ,Decodable{
    
    var Name            : String            = ""
    var ImageURL        : String            = ""
    var MoreEvents      :[WUMoreEvent]          = []
    var isExpanded      : Bool              = false
    
    private enum CodingKeys: String, CodingKey {
        
        case Name
        case ImageURL
        case MoreEvents
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
             Utill.printInTOConsole(printData:"type mismatched in WUMoreEventDetail for Name ")
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
             Utill.printInTOConsole(printData:"type mismatched in WUMoreEventDetail for ImageURL ")
        }
        
        do {
            if let MoreEvents = try values.decodeIfPresent([WUMoreEvent].self, forKey: .MoreEvents){
                self.MoreEvents = MoreEvents
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUMoreEventDetail for MoreEvents ")
        }
    }
}

extension WUMoreEventDetail: Encodable{
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(MoreEvents, forKey: .MoreEvents)
    }
}

