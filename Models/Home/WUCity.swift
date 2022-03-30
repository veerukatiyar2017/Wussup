//
//  WUCity.swift
//  demo
//
//  Created by MAC215 on 5/2/18.
//  Copyright © 2018 MAC215. All rights reserved.
//

import UIKit

//MARK: - WUCity
class WUCity: NSObject, Decodable {
    var place_id                 : String              = ""
    var place_description        : String              = ""
    var structured_formatting    : WUCityStructuredFormatting!
    var terms                    : [WUCityTerms]!
    var nameOfCityAndState       : String  {

        if terms.count == 1 {
            let cityName = terms[0].value
            
            return "\(cityName)"
        }else{
            let cityName = terms[0].value
            let stateName = terms[1].value
            
            return "\(cityName), \(stateName)"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case place_id
        case description
        case structured_formatting
        case terms

    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let place_id = try values.decodeIfPresent(String.self, forKey: .place_id) {
                self.place_id = place_id
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCity for place_id")
        }
        
        do {
            if let place_description = try values.decodeIfPresent(String.self, forKey: .description){
                self.place_description = place_description
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCity for place_description")
        }
        
        do {
            if let structured_formatting = try values.decodeIfPresent(WUCityStructuredFormatting.self, forKey: .structured_formatting){
                self.structured_formatting = structured_formatting
            }
        } catch DecodingError.typeMismatch {
                Utill.printInTOConsole(printData:"type mismatched in WUCity for structured_formatting")
        }
        
        do {
            if let terms = try values.decodeIfPresent([WUCityTerms].self, forKey: .terms){
                self.terms = terms
            }
        } catch DecodingError.typeMismatch {
                Utill.printInTOConsole(printData:"type mismatched in WUCity for terms")
        }
        
    }
}

extension WUCity: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(place_id, forKey: .place_id)
        try container.encode(place_description, forKey: .description)
        try container.encode(terms, forKey: .terms)

    }
}

//MARK: - WUCity Structured Formatting
class WUCityStructuredFormatting: NSObject, Decodable {
    var secondary_text                 : String              = ""
    var main_text                      : String              = ""
    
    private enum CodingKeys: String, CodingKey {
        case secondary_text
        case main_text
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let secondary_text = try values.decodeIfPresent(String.self, forKey: .secondary_text) {
                self.secondary_text = secondary_text
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCity for secondary text")
        }
        
        do {
            if let main_text = try values.decodeIfPresent(String.self, forKey: .main_text){
                self.main_text = main_text
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCity for main_text")
        }

    }
}

extension WUCityStructuredFormatting: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(secondary_text, forKey: .secondary_text)
        try container.encode(main_text, forKey: .main_text)
    }
}


//MARK: - WUCityList
class WUCityList: NSObject, Decodable {
    var predictions: [WUCity] = []

    
    private enum CodingKeys: String, CodingKey {
        case predictions
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let predictions = try values.decodeIfPresent([WUCity].self, forKey: .predictions) {
                self.predictions = predictions
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityList for place_id")
        }
   
        
    }
}

extension WUCityList: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(predictions, forKey: .predictions)
   
    }
}

//MARK: - WUCityTerms
class WUCityTerms: NSObject, Decodable {
    var value: String = ""
    var offset: Int = 0

    
    private enum CodingKeys: String, CodingKey {
        case value
        case offset
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let value = try values.decodeIfPresent(String.self, forKey: .value) {
                self.value = value
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityTerms for value")
        }
        
        let offset = try decoder.container(keyedBy: CodingKeys.self)
               
        do {
            if let offset = try values.decodeIfPresent(Int.self, forKey: .offset) {
                self.offset = offset
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCityTerms for offset")
        }
    }
}

extension WUCityTerms: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(value, forKey: .offset)
    }
}



