//
//  WUEventCategories.swift
//  Wussup
//
//  Created by MAC219 on 6/8/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 [
 {
 "ID": "1",
 "Name": "Acrobatics"
 }
 ]
 */

class WUEventCategories: NSObject,Decodable {
    
    var ID         : String    = "0"
    var Name            : String    = ""
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case Name
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
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventCategories for EventID ")
        }
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventCategories for Name ")
        }
    }
}

extension WUEventCategories: Encodable {
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(Name, forKey: .Name)
    }
}

