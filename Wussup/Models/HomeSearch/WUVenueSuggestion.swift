//
//  WUVenueSuggestion.swift
//  Wussup
//
//  Created by MAC26 on 03/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*0
 {
 "Name": "Cinemark Reno Summit Sierra",
 "VenueFourSquareID": "4b451336f964a5209a0326e3"
 },*/
class WUVenueSuggestion: NSObject, Decodable {
    var Name: String                  = ""
    var VenueFourSquareID: String     = ""
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case VenueFourSquareID
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let name = try values.decodeIfPresent(String.self, forKey: .Name) {
                self.Name = name
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueSuggestion for name ")
        }
        
        do {
            if let venueFourSquareID = try values.decodeIfPresent(String.self, forKey: .VenueFourSquareID){
                self.VenueFourSquareID = venueFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueSuggestion for venueFourSquareID ")
        }
    }
}

extension WUVenueSuggestion: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(Name, forKey: .Name)
        
    }
}


