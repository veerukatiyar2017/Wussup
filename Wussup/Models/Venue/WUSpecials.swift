//
//  WUSpecials.swift
//  Wussup
//
//  Created by MAC26 on 14/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "Specials":{
 "getSpecials":[
 {"ID": "1", "VenueID": "1"},
 {"ID": "2", "VenueID": "1"},
 {"ID": "3", "VenueID": "1"}
 ],
 "CategoryID": null,
 "CategoryName": null,
 "CategoryImage": null,
 "SelectedImageURL": null,
 "UnSelectedImageURL": null,
 "CategoryFourSquareID": null
 },*/

class WUSpecials: NSObject, Decodable {
    var CategoryID              : String                = "0"
    var CategoryName            : String                = ""
    var CategoryImage           : String                = ""
    var CategoryFourSquareID    : String                = ""
    var SelectedImageURL        : String                = ""
    var UnSelectedImageURL      : String                = ""
    var VenueSpecials           : [WUVenueSpecials]     = []
    var isExpanded              : Bool                  = false
    
    
    private enum CodingKeys: String, CodingKey {
        
        case CategoryID
        case CategoryName
        case CategoryImage
        case CategoryFourSquareID
        case SelectedImageURL
        case UnSelectedImageURL
        case VenueSpecials = "getSpecials"
    }
    
    override init() {
        
    }
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let categoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = categoryID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in CategoryID for WUSpecials ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUSpecials ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUSpecials ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryFourSquareID for WUSpecials ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUSpecials for SelectedImageURL")
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
            Utill.printInTOConsole(printData:"type mismatched in WUSpecials for UnSelectedImageURL")
        }
        
        do {
            if let getSpecials = try values.decodeIfPresent([WUVenueSpecials].self, forKey: .VenueSpecials){
                self.VenueSpecials = getSpecials
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUSpecials ")
        }
    }
}

extension WUSpecials: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CategoryID, forKey: .CategoryID)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encode(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(SelectedImageURL, forKey: .SelectedImageURL)
        try container.encode(UnSelectedImageURL, forKey: .UnSelectedImageURL)
        try container.encode(VenueSpecials, forKey: .VenueSpecials)
    }
}
