//
//  WUCityData.swift
//  Wussup
//
//  Created by Alexandr on 06.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import Foundation

//MARK: - WUCityData

class WUCityData: NSObject, Decodable {
    var City                  : String    = ""
    var State                 : WUCityState!
    
    private enum CodingKeys: String, CodingKey {
        case City
        case State
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let City = try values.decodeIfPresent(String.self, forKey: .City) {
                self.City = City
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityData for City")
        }
   
        
        do {
            if let State = try values.decodeIfPresent(WUCityState.self, forKey: .State) {
                self.State = State
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityData for State")
        }
    }
}

extension WUCityData: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(City, forKey: .City)
        try container.encode(State, forKey: .State)
    }
}


class WUCityState: NSObject, Decodable {
    var LongName                  : String    = ""
    var ShortName                 : String    = ""
    
    private enum CodingKeys: String, CodingKey {
        case LongName
        case ShortName
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let LongName = try values.decodeIfPresent(String.self, forKey: .LongName) {
                self.LongName = LongName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityState for LongName")
        }
   
        
        do {
            if let ShortName = try values.decodeIfPresent(String.self, forKey: .ShortName) {
                self.ShortName = ShortName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityState for ShortName")
        }
    }
}

extension WUCityState: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(LongName, forKey: .LongName)
        try container.encode(ShortName, forKey: .ShortName)
    }
}
