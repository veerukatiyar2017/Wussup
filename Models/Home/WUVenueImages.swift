//
//  WUVenueImages.swift
//  Wussup
//
//  Created by MAC26 on 02/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "RactangleImage" : "https:\/\/igx.4sqi.net\/img\/general\/1059x675\/10202453_gTQ3_5WhoTe-sD3qtEznULmKujPpye2pgHm57MCd84o.jpg",
 "IsConverPhoto" : false,
 "SquareImage" : "https:\/\/igx.4sqi.net\/img\/general\/720x513\/10202453_gTQ3_5WhoTe-sD3qtEznULmKujPpye2pgHm57MCd84o.jpg",
 "IsSponseredVenues" : false
 */
class WUVenueImages: NSObject, Decodable {
    var SquareImage             : String  = ""
    var RactangleImage          : String  = ""
    var Height                  : String  = ""
    var Width                   : String  = ""
    var IsSponseredVenues       : String  = "false"
    var IsConverPhoto           : String  = "false"
    var HeightFloat             : CGFloat = 0.0
    var WidthFloat              : CGFloat = 0.0
    var Description : String = ""
    
    private enum CodingKeys: String, CodingKey {

        case SquareImage
        case RactangleImage
        case Height
        case Width
        case IsSponseredVenues
        case IsConverPhoto
        case Description

    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let ractangleImage = try values.decodeIfPresent(String.self, forKey: .RactangleImage) {
                if URL(string: ractangleImage) != nil {
                    self.RactangleImage = ractangleImage
                }
                else {
                    self.RactangleImage = ractangleImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenueImages for ractangleImage ")
        }
        
        do {
            if let isConverPhoto = try values.decodeIfPresent(String.self, forKey: .IsConverPhoto){
                self.IsConverPhoto = isConverPhoto
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsConverPhoto) {
                // Can check for "parent" specifically if you want.
                self.IsConverPhoto = String(val)
            }
        }
        
        
        do {
            if let squareImage = try values.decodeIfPresent(String.self, forKey: .SquareImage){
                if URL(string: squareImage) != nil {
                    self.SquareImage = squareImage
                }
                else {
                    self.SquareImage = squareImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenueImages for squareImage ")
        }
        
        
        do {
            if let isSponseredVenues = try values.decodeIfPresent(String.self, forKey: .IsSponseredVenues){
                self.IsSponseredVenues = isSponseredVenues
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSponseredVenues) {
                self.IsSponseredVenues = String(val)
            }
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueImages for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueImages for Width ")
        }
        
        do {
            if let Description = try values.decodeIfPresent(String.self, forKey: .Description) {
                self.Description = Description
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueImages for Description ")
        }
        
    }
}

extension WUVenueImages: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(RactangleImage, forKey: .RactangleImage)
        try container.encode(IsConverPhoto, forKey: .IsConverPhoto)
        try container.encode(SquareImage, forKey: .SquareImage)
        try container.encode(IsSponseredVenues, forKey: .IsSponseredVenues)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
        try container.encode(Description, forKey: .Description)
    }
}
