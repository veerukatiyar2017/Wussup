//
//  WUGeolocationFilter.swift
//  Wussup
//
//  Created by Alexandr on 06.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import Foundation

//MARK: - WUGeolocationFilter

class WUGeolocationFilterData: NSObject, Decodable {
    var Longitude             : String!
    var Latitude              : String!
    var Radius                : Int       = 2
    var IsNearBy              : Bool      = true
    var CityData              : WUCityData!
    
    var FullName              :String {
        if CityData.State.ShortName.count > 0 {
            return "\(CityData.City), \(CityData.State.ShortName)"
        }else{
            return "\(CityData.City)"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case Longitude
        case Latitude
        case Radius
        case IsNearBy
        case CityData
    }
    
    override init() {
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let Longitude = try values.decodeIfPresent(String.self, forKey: .Longitude) {
                self.Longitude = Longitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUGeolocationFilter for Longitude")
        }
   
        
        do {
            if let Latitude = try values.decodeIfPresent(String.self, forKey: .Latitude) {
                self.Latitude = Latitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUGeolocationFilter for Latitude")
        }
        
        do {
            if let Radius = try values.decodeIfPresent(Int.self, forKey: .Radius) {
                self.Radius = Radius
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUGeolocationFilter for Radius")
        }
        
        do {
            if let IsNearBy = try values.decodeIfPresent(Bool.self, forKey: .IsNearBy) {
                self.IsNearBy = IsNearBy
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUGeolocationFilter for IsNearBy")
        }
        
        do {
            if let CityData = try values.decodeIfPresent(WUCityData.self, forKey: .CityData) {
                self.CityData = CityData
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUGeolocationFilter for CityData")
        }
        
    }
}

extension WUGeolocationFilterData: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Longitude, forKey: .Longitude)
        try container.encode(Latitude, forKey: .Latitude)
        try container.encode(Radius, forKey: .Radius)
        try container.encode(IsNearBy, forKey: .IsNearBy)
        try container.encode(CityData, forKey: .CityData)

    }
}
