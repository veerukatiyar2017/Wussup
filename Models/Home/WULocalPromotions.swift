//
//  WULocalPromotions.swift
//  demo
//
//  Created by MAC215 on 5/2/18.
//  Copyright © 2018 MAC215. All rights reserved.
//

import UIKit

/*"LocalPromotions":{
 "CategoryID": 0,
 "CategoryName": "Venue Promotions",
 "CategoryImage": "http://web1.anasource.com/Wussup_UAT/images/API//LocalPromotions.png",
 "CategoryFourSquareID": "",
 "VenuePromotions":[
 {
 "ImageURL": "",
 "VenueID": 1,
 "Description": "Test"
 },
 {"ImageURL": "", "VenueID": 2, "Description": "Test"},
 {"ImageURL": "", "VenueID": 3, "Description": "Test"}
 ]
 },*/

class WULocalPromotions: NSObject, Decodable {
    
    var CategoryName            : String                    = ""
    var CategoryID              : String                    = "0"
    var CategoryImage           : String                    = ""
    var SelectedImageURL        : String                    = ""
    var UnSelectedImageURL      : String                    = ""
    var CategoryFourSquareID    : String                    = ""
    var VenuePromotions         : [WUVenueLocalPromotions]  = []
    var isExpanded              : Bool                      = false
    
    private enum CodingKeys: String, CodingKey {
        case CategoryName
        case CategoryID
        case CategoryImage
        case SelectedImageURL
        case UnSelectedImageURL
        case CategoryFourSquareID
        case VenuePromotions
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName) {
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocalPromotions for categoryName ")
        }
        
        do {
            if let categoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = categoryID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WULocalPromotions for categoryID ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage) {
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocalPromotions for categoryImage ")
        }
        
        do {
            if let selectedImageURL = try values.decodeIfPresent(String.self, forKey: .SelectedImageURL){
                if URL(string: selectedImageURL) != nil {
                    self.SelectedImageURL = selectedImageURL
                }
                else {
                    self.SelectedImageURL = selectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocalPromotions for SelectedImageURL ")
        }
        
        do {
            if let unSelectedImageURL = try values.decodeIfPresent(String.self, forKey: .UnSelectedImageURL){
                if URL(string: unSelectedImageURL) != nil {
                    self.UnSelectedImageURL = unSelectedImageURL
                }
                else {
                    self.UnSelectedImageURL = unSelectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocalPromotions for UnSelectedImageURL ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID) {
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocalPromotions for categoryFourSquareID ")
        }
        
        do {
            if let venuePromotions = try values.decodeIfPresent([WUVenueLocalPromotions].self, forKey: .VenuePromotions) {
                self.VenuePromotions = venuePromotions
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULocalPromotions for venuePromotions ")
        }
    }
}

extension WULocalPromotions: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(CategoryID, forKey: .CategoryID)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encode(SelectedImageURL, forKey: .SelectedImageURL)
        try container.encode(UnSelectedImageURL, forKey: .UnSelectedImageURL)
        try container.encode(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(VenuePromotions, forKey: .VenuePromotions)
    }
}



