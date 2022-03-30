//
//  WUMyEventList.swift
//  Wussup
//
//  Created by MAC219 on 9/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUMyEventList: NSObject , Decodable{
    
    var UserID_ResultKey    : String    = ""
    var EventIdentifier     : String    = ""
    var ID                  : String    = ""
    var Name                : String    = ""
    var StartDate           : String    = ""
    var EndDate             : String    = ""
//    var isExpanded          : Bool      = false
    
    private enum CodingKeys: String, CodingKey {
        case UserID_ResultKey
        case EventIdentifier
        case ID
        case Name
        case StartDate
        case EndDate
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws{
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let UserID_ResultKey = try values.decodeIfPresent(String.self, forKey: .UserID_ResultKey){
                self.UserID_ResultKey = UserID_ResultKey
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventCalendar for UserID_ResultKey ")
        }
        
        do {
            if let EventIdentifier = try values.decodeIfPresent(String.self, forKey: .EventIdentifier){
                self.EventIdentifier = EventIdentifier
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventCalendar for EventIdentifier ")
        }
        
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID){
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventList for ID ")
        }
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventList for Name ")
        }
        
        do {
            if let StartDate = try values.decodeIfPresent(String.self, forKey: .StartDate){
                self.StartDate = StartDate
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventList for StartDate ")
        }
        
        do {
            if let EndDate = try values.decodeIfPresent(String.self, forKey: .EndDate){
                self.EndDate = EndDate
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMyEventList for EndDate ")
        }
    }
}

extension WUMyEventList: Encodable{
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(UserID_ResultKey, forKey: .UserID_ResultKey)
        try container.encode(EventIdentifier, forKey: .EventIdentifier)
        try container.encode(ID, forKey: .ID)
        try container.encode(Name, forKey: .Name)
        try container.encode(StartDate, forKey: .StartDate)
        try container.encode(EndDate, forKey: .EndDate)
    }
}
