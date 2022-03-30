 //
//  WUCategorisedVenues.swift
//  demo
//
//  Created by MAC215 on 5/2/18.
//  Copyright © 2018 MAC215. All rights reserved.
//

import UIKit

/*
 "CategorisedVenues":[
 {
 "CategoryID": 1,
 "CategoryName": "Arts & Entertainment",
 "CategoryImage": "http://web1.anasource.com/Wussup_UAT/images/API/ArtAndTheatreIcon.png",
 "CategoryFourSquareID": "4d4b7104d754a06370d81259",
 "Venues":[
 {"IsSponseredVenues": false, "SponsoredVenuID": "0", "VenueName": "Greater Nevada Field", "FourSquareVenueID": "4bc3655f4cdfc9b621499721",…},
 {"IsSponseredVenues": false, "SponsoredVenuID": "0", "VenueName": "National Automobile Museum", "FourSquareVenueID": "4b7c82b8f964a520d1972fe3",…},
 {"IsSponseredVenues": false, "SponsoredVenuID": "0", "VenueName": "The Nevada Museum of Art", "FourSquareVenueID": "4b4fc059f964a520ff1327e3",…}
 ]
 */


class WUCategorisedVenues: NSObject, Decodable {
    var CategoryID: String                        = "0"
    var CategoryName: String                      = ""
    var CategoryImage: String                     = ""
    var CategoryFourSquareID: String              = ""
    var Venues: [WUVenue]                         = []
    var Events: [WUEventDetail]                   = []
    
    private enum CodingKeys: String, CodingKey {
        case CategoryID
        case CategoryName
        case CategoryImage
        case CategoryFourSquareID
        case Venues
        case Events
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n CategoryID        : \(CategoryID)"
        printString += "\n CategoryName       : \(CategoryName)"
        printString += "\n CategoryImage       : \(CategoryImage)"
        printString += "\n CategoryFourSquareID   : \(CategoryFourSquareID)"
        printString += "\n Venues   : \(Venues)"
        printString += "\n Events   : \(Events)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let categoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID) {
                self.CategoryID = categoryID
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                // Can check for "parent" specifically if you want.
                self.CategoryID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUCategorisedVenues for categoryID ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUCategorisedVenues for categoryName ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUCategorisedVenues for categoryImage ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUCategorisedVenues for categoryFourSquareID ")
        }
        
        do {
            if let venues = try values.decodeIfPresent(Array<WUVenue>.self, forKey: .Venues){
                self.Venues = venues
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUCategorisedVenues for venues ")
        }
        
        do {
            if let Events = try values.decodeIfPresent([WUEventDetail].self, forKey: .Events){
                self.Events = Events
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUCategorisedVenues for Events ")
        }
    }
}

extension WUCategorisedVenues: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CategoryID, forKey: .CategoryID)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encodeIfPresent(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(Venues, forKey: .Venues)
    }
}
