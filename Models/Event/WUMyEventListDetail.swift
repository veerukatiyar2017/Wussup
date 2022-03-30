//
//  WUMyEventListDetail.swift
//  Wussup
//
//  Created by MAC219 on 9/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUMyEventListDetail: NSObject, Decodable {
    
    var Name            : String                = ""
    var ImageURL        : String                = ""
    var eventList       :[WUMyEventList]        = []
    var isExpanded      : Bool                  = false
    
    private enum CodingKeys: String, CodingKey {
        
        case Name
        case ImageURL
        case eventList
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
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventListDetail for Name ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventListDetail for ImageURL ")
        }
        
        do {
            if let eventList = try values.decodeIfPresent([WUMyEventList].self, forKey: .eventList){
                self.eventList = eventList
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventListDetail for eventList ")
        }
    }
}

extension WUMyEventListDetail: Encodable{
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(eventList, forKey: .eventList)
    }
}
