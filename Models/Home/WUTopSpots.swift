//
//  WUTopSpots.swift
//  Wussup
//
//  Created by MAC26 on 02/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUTopSpots: NSObject, Decodable{
    
    var CategoryID              : String        = "0"
    var CategoryName            : String        = ""
    var CategoryImage           : String        = ""
    var SelectedImageURL        : String        = ""
    var UnSelectedImageURL      : String        = ""
    var CategoryFourSquareID    : String        = ""
    var Venues                  : [WUVenue]     = []
    
    private enum CodingKeys: String, CodingKey {
        case CategoryID
        case CategoryName
        case CategoryImage
        case SelectedImageURL
        case UnSelectedImageURL
        case CategoryFourSquareID
        case Venues
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n CategoryID        : \(CategoryID)"
        printString += "\n CategoryName       : \(CategoryName)"
        printString += "\n CategoryImage       : \(CategoryImage)"
        printString += "\n SelectedImageURL       : \(SelectedImageURL)"
        printString += "\n UnSelectedImageURL       : \(UnSelectedImageURL)"
        printString += "\n CategoryFourSquareID   : \(CategoryFourSquareID)"
        printString += "\n Venues   : \(Venues)"
        
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
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUTopSpots for categoryID ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUTopSpots for categoryName ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUTopSpots for categoryImage ")
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
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            Utill.printInTOConsole(printData:"type mismatched in WUTopSpots for SelectedImageURL ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUTopSpots for UnSelectedImageURL ")
        }
        
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUTopSpots for categoryFourSquareID ")
        }
        
        do {
            if let venues = try values.decodeIfPresent([WUVenue].self, forKey: .Venues){
                self.Venues = venues
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUTopSpots for venues ")
        }
    }
}

extension WUTopSpots: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CategoryID, forKey: .CategoryID)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encode(SelectedImageURL, forKey: .SelectedImageURL)
        try container.encode(UnSelectedImageURL, forKey: .UnSelectedImageURL)
        try container.encodeIfPresent(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(Venues, forKey: .Venues)
    }
}
