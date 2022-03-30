//
//  WUMenus.swift
//  Wussup
//
//  Created by MAC26 on 14/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "Menus":{
 "Name": null,
 "GetMenus":[
 ],
 "CategoryID": "0",
 "CategoryName": "Menus",
 "CategoryImage": "https://s3.amazonaws.com/wussup-sandbox/App_Images/MenusIcon%403x.png",
 "SelectedImageURL": "",
 "UnSelectedImageURL": "",
 "CategoryFourSquareID": ""
 },
 */

class WUMenus: NSObject, Decodable {
    var CategoryID              : String                = "0"
    var CategoryName            : String                = ""
    var CategoryImage           : String                = ""
    var CategoryFourSquareID    : String                = ""
    var SelectedImageURL        : String                = ""
    var UnSelectedImageURL      : String                = ""
    var VenueMenus              : [WUVenueMenus]        = []
    var isExpanded              : Bool                  = false

    
    private enum CodingKeys: String, CodingKey {
        
        case CategoryID
        case CategoryName
        case CategoryImage
        case CategoryFourSquareID
        case SelectedImageURL
        case UnSelectedImageURL
        case VenueMenus  = "GetMenus"
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
             Utill.printInTOConsole(printData:"solved type mismatched in CategoryID for WUMenus ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUMenus ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUMenus ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryFourSquareID for WUMenus ")
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
             Utill.printInTOConsole(printData:"type mismatched in WUMenus for SelectedImageURL")
        }
        
        do {
            if let unSelectedImageURL = try values.decodeIfPresent(String.self, forKey: .UnSelectedImageURL){
                if URL(string: UnSelectedImageURL) != nil {
                    self.UnSelectedImageURL = unSelectedImageURL
                }
                else {
                    self.UnSelectedImageURL = unSelectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUMenus for UnSelectedImageURL")
        }
        
        do {
            if let getMenus = try values.decodeIfPresent([WUVenueMenus].self, forKey: .VenueMenus){
                self.VenueMenus = getMenus
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUMenus ")
        }
    }
}

extension WUMenus: Encodable
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
        try container.encode(VenueMenus, forKey: .VenueMenus)
    }
}

