//
//  WUVenueLocalPromotions.swift
//  Wussup
//
//  Created by MAC26 on 03/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenueLocalPromotions: NSObject, Decodable {
    var ImageURL            : String    = ""
    var VenueID             : String    = "0"
    var Description         : String    = ""
    var Height              : String    = ""
    var Width               : String    = ""
    var VenueFourSquareID   : String    = ""
    var IsSponseredVenues   : String    = "false"
    var HasRead             : String    = "false"
    var HeightFloat         : CGFloat   = 0.0
    var WidthFloat          : CGFloat   = 0.0
    var VenueStatusID       : Int       =  0
    var VenueName           : String    = ""
    
    private enum CodingKeys: String, CodingKey {
        case ImageURL
        case VenueID
        case Description
        case Height
        case Width
        case VenueFourSquareID
        case IsSponseredVenues
        case HasRead
        case VenueStatusID
        case VenueName
    }
    
    override var description: String     {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n ImageURL        : \(ImageURL)"
        printString += "\n VenueID       : \(VenueID)"
        printString += "\n Description       : \(Description)"
        printString += "\n Height       : \(Height)"
        printString += "\n Width       : \(Width)"
        printString += "\n HasRead       : \(HasRead)"
        printString += "\n VenueStatusID       : \(VenueStatusID)"
        printString += "\n VenueName       : \(VenueName)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let imageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL) {
                if URL(string: imageURL) != nil {
                    self.ImageURL = imageURL
                }
                else {
                    self.ImageURL = imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueLocalPromotions for imageURL ")
        }
        
        do {
            if let venueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = venueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLocalPromotions for venueID ")
        }
        
        do {
            if let description = try values.decodeIfPresent(String.self, forKey: .Description) {
                self.Description = description
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueLocalPromotions for description ")
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueLocalPromotions for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueLocalPromotions for Width ")
        }
        
        do {
            if let venueFourSquareID = try values.decodeIfPresent(String.self, forKey: .VenueFourSquareID) {
                self.VenueFourSquareID = venueFourSquareID
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenueLocalPromotions for VenueFourSquareID ")
        }
        
        do {
            if let isSponseredVenues = try values.decodeIfPresent(String.self, forKey: .IsSponseredVenues){
                self.IsSponseredVenues = isSponseredVenues
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSponseredVenues) {
                self.IsSponseredVenues = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLocalPromotions for IsSponseredVenues ")
        }
        do {
            if let HasRead = try values.decodeIfPresent(String.self, forKey: .HasRead){
                self.HasRead = HasRead
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .HasRead) {
                self.HasRead = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLocalPromotions for HasRead ")
        }
        
        do {
            if let VenueStatusID = try values.decodeIfPresent(Int.self, forKey: .VenueStatusID){
                self.VenueStatusID = VenueStatusID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenueLocalPromotions for VenueStatusID ")
        }
        
        do {
            if let VenueName = try values.decodeIfPresent(String.self, forKey: .VenueName) {
                self.VenueName = VenueName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLocalPromotions for VenueName ")
        }
    }
}

extension WUVenueLocalPromotions: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(VenueID, forKey: .VenueID)
        try container.encode(Description, forKey: .Description)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
        try container.encode(VenueFourSquareID, forKey: .VenueFourSquareID)
        try container.encode(IsSponseredVenues, forKey: .IsSponseredVenues)
        try container.encode(HasRead, forKey: .HasRead)
        try container.encode(VenueStatusID, forKey: .VenueStatusID)
        try container.encode(VenueName, forKey: .VenueName)
    }
}

