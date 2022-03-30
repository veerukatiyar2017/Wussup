//
//  WUCityLocationData.swift
//  Wussup
//
//  Created by Alexandr on 06.11.2019.
//  Copyright © 2019 MAC26. All rights reserved.
//

import Foundation


//MARK: - WUCityLocationData

class WUCityLocationData: NSObject, Decodable {
    var name                  : String    = ""
    var geometry              : WUCityGeometry!
    
    private enum CodingKeys: String, CodingKey {
        case name
        case geometry
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let name = try values.decodeIfPresent(String.self, forKey: .name) {
                self.name = name
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityLocationData for name")
        }
   
        
        do {
            if let geometry = try values.decodeIfPresent(WUCityGeometry.self, forKey: .geometry) {
                self.geometry = geometry
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityLocationData for geometry")
        }
    }
}

extension WUCityLocationData: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(geometry, forKey: .geometry)
    }
}



//MARK: - WUCityGeometry

class WUCityGeometry: NSObject, Decodable {
    var location                  : WULocationCoordinate2D!
    var viewport                  : WULocationCoordinate2D!
    var southwest                 : WULocationCoordinate2D!
    
    private enum CodingKeys: String, CodingKey {
        case location
        case viewport
        case southwest
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let location = try values.decodeIfPresent(WULocationCoordinate2D.self, forKey: .location) {
                self.location = location
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityGeometry for location")
        }
   
        
        do {
            if let viewport = try values.decodeIfPresent(WULocationCoordinate2D.self, forKey: .viewport) {
                self.viewport = viewport
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityGeometry for viewport")
        }
        
        
              do {
                  if let southwest = try values.decodeIfPresent(WULocationCoordinate2D.self, forKey: .southwest) {
                      self.southwest = southwest
                  }
              } catch DecodingError.typeMismatch {
                  Utill.printInTOConsole(printData:"type mismatched in WUCityGeometry for southwest")
              }
    }
}

extension WUCityGeometry: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
        try container.encode(viewport, forKey: .viewport)
        try container.encode(southwest, forKey: .southwest)
    }
}


//MARK: - WULocationCoordinate2D

class WULocationCoordinate2D: NSObject, Decodable {
    var lng                  : Double!
    var lat                  : Double!
    
    private enum CodingKeys: String, CodingKey {
        case lng
        case lat
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let lng = try values.decodeIfPresent(Double  .self, forKey: .lng) {
                self.lng = lng
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocationCoordinate2D for lng")
        }
   
        
        do {
            if let lat = try values.decodeIfPresent(Double.self, forKey: .lat) {
                self.lat = lat
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocationCoordinate2D for lat")
        }
    }
}

extension WULocationCoordinate2D: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lng, forKey: .lng)
        try container.encode(lat, forKey: .lat)
    }
}
