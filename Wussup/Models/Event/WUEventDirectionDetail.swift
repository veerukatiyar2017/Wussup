//
//  WUEventDirectionDetail.swift
//  Wussup
//
//  Created by MAC219 on 6/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 {
 "Name": "Directions",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/DirectionIcon@3x.png",
 "MapPinImageUrl": "https://s3.amazonaws.com/wussup-sandbox/App_Images/MapPinIcon@2x.png",
 "Address": null,
 "FullAddress": "TatvaSoft House, Opp. Kensville Golf Academy, Near Shivalik Business, Center, Sarkhej - Gandhinagar Highway, Off, Rajpath Rangoli Road, Ahmedabad, Gujarat 380054",
 "City": null,
 "State": "Event1",
 "Country": null,
 "ZipCode": null,
 "Latitude": "0.0000",
 "Longitude": "0.0000"
 }
 */
class WUEventDirectionDetail: NSObject , Decodable{
    
    var Name                : String    = ""
    var ImageURL            : String    = ""
    var MapPinImageUrl      : String    = ""
    var Address             : String    = ""
    var FullAddress         : String    = ""
    var City                : String    = ""
    var State               : String    = ""
    var Country             : String    = ""
    var ZipCode             : String    = ""
    var Latitude            : String    = ""
    var Longitude           : String    = ""
    var Distance            : String    = ""
    var isExpanded          : Bool      = false
    
    private enum CodingKeys: String, CodingKey {
        case Name
        case ImageURL
        case MapPinImageUrl
        case Address
        case FullAddress
        case City
        case State
        case Country
        case ZipCode
        case Latitude
        case Longitude
        case Distance
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
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for Name ")
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
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for ImageURL ")
        }
        
        do {
            if let MapPinImageUrl = try values.decodeIfPresent(String.self, forKey: .MapPinImageUrl){
                if URL(string: MapPinImageUrl) != nil {
                    self.MapPinImageUrl = MapPinImageUrl
                }
                else {
                    self.MapPinImageUrl = MapPinImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for MapPinImageUrl ")
        }
        
        do {
            if let Address = try values.decodeIfPresent(String.self, forKey: .Address){
                self.Address = Address
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for Address ")
        }
        
        do {
            if let FullAddress = try values.decodeIfPresent(String.self, forKey: .FullAddress){
                self.FullAddress = FullAddress
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for FullAddress ")
        }
        
        do {
            if let City = try values.decodeIfPresent(String.self, forKey: .City){
                self.City = City
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for City ")
        }

        do {
            if let State = try values.decodeIfPresent(String.self, forKey: .State){
                self.State = State
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for State ")
        }
        
        do {
            if let Country = try values.decodeIfPresent(String.self, forKey: .Country){
                self.Country = Country
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for Country ")
        }
        
        do {
            if let ZipCode = try values.decodeIfPresent(String.self, forKey: .ZipCode){
                self.ZipCode = ZipCode
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for ZipCode ")
        }
    
        do {
            if let Latitude = try values.decodeIfPresent(String.self, forKey: .Latitude){
                self.Latitude = Latitude
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for Latitude ")
        }
        
        do {
            if let Longitude = try values.decodeIfPresent(String.self, forKey: .Longitude){
                self.Longitude = Longitude
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for Longitude ")
        }
        do {
            if let Distance = try values.decodeIfPresent(String.self, forKey: .Distance){
                self.Distance = Distance
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventDirectionDetail for Distance ")
        }
    }
    
}

extension WUEventDirectionDetail: Encodable{
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(MapPinImageUrl, forKey: .MapPinImageUrl)
        try container.encode(Address, forKey: .Address)
        try container.encode(FullAddress, forKey: .FullAddress)
        try container.encode(City, forKey: .City)
        try container.encode(State, forKey: .State)
        try container.encode(Country, forKey: .Country)
        try container.encode(ZipCode, forKey: .ZipCode)
        try container.encode(Latitude, forKey: .Latitude)
        try container.encode(Longitude, forKey: .Longitude)
    }
}
