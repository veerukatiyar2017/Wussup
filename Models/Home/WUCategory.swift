//
//  WUCategory.swift
//  Wussup
//
//  Created by MAC26 on 02/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "ID" : 1,
 "WussupName" : "Arts & Entertainment",
 "Name" : "Arts & Entertainment",
 "CategoryTypeID" : 1,
 "ImageURL" : "https:\/\/ss3.4sqi.net\/img\/categories_v2\/arts_entertainment\/default_64.png",
 "FourSquareCategoryID" : "4d4b7104d754a06370d81259",
 "RootCategoryID" : null
 */

class WUCategory: NSObject, Decodable, Copying {
   
    
    var ID                      : String    = "0"
    var WussupName              : String    = ""
    var Name                    : String    = ""
    var CategoryTypeID          : String    = "0"
    var ImageURL                : String    = ""
    var SelectedImageURL        : String    = ""
    var UnSelectedImageURL      : String    = ""
    var FourSquareCategoryID    : String    = ""
    var RootCategoryID          : String    = ""
    var isSelected              : Bool      = false

    required init(original: WUCategory) {
        self.ID                     = original.ID
        self.WussupName             = original.WussupName
        self.Name                   = original.Name
        self.CategoryTypeID         = original.CategoryTypeID
        self.ImageURL               = original.ImageURL
        self.SelectedImageURL       = original.SelectedImageURL
        self.UnSelectedImageURL     = original.UnSelectedImageURL
        self.FourSquareCategoryID   = original.FourSquareCategoryID
        self.RootCategoryID         = original.RootCategoryID
        self.isSelected             = original.isSelected
    }
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case WussupName
        case Name
        case CategoryTypeID
        case ImageURL
        case SelectedImageURL
        case UnSelectedImageURL
        case FourSquareCategoryID
        case RootCategoryID
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n ID        : \(ID)"
        printString += "\n WussupName       : \(WussupName)"
        printString += "\n Name       : \(Name)"
        printString += "\n CategoryTypeID   : \(CategoryTypeID)"
        printString += "\n ImageURL       : \(ImageURL)"
        printString += "\n SelectedImageURL       : \(SelectedImageURL)"
        printString += "\n UnSelectedImageURL       : \(UnSelectedImageURL)"
        printString += "\n FourSquareCategoryID       : \(FourSquareCategoryID)"
        printString += "\n RootCategoryID   : \(RootCategoryID)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let id = try values.decodeIfPresent(String.self, forKey: .ID) {
                self.ID = id
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUCategory for id")
        }
       
        do {
            if let wussupName = try values.decodeIfPresent(String.self, forKey: .WussupName){
                self.WussupName = wussupName
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for wussupName")
        }
        
        do {
            if let name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = name
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for name")
        }
        
        do {
            if let categoryTypeID = try values.decodeIfPresent(String.self, forKey: .CategoryTypeID){
                self.CategoryTypeID = categoryTypeID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryTypeID) {
                self.CategoryTypeID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUCategory for categoryTypeID")
        }
        
        do {
            if let imageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL){
                self.ImageURL = imageURL
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for imageURL")
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
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for SelectedImageURL")
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
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for UnSelectedImageURL")
        }
        
        do {
            if let fourSquareCategoryID = try values.decodeIfPresent(String.self, forKey: .FourSquareCategoryID){
                self.FourSquareCategoryID = fourSquareCategoryID
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for fourSquareCategoryID")
        }
        
        do {
            if let rootCategoryID = try values.decodeIfPresent(String.self, forKey: .RootCategoryID){
                self.RootCategoryID = rootCategoryID
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUCategory for rootCategoryID")
        }
    }
}

extension WUCategory: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(WussupName, forKey: .WussupName)
        try container.encode(Name, forKey: .Name)
        try container.encodeIfPresent(CategoryTypeID, forKey: .CategoryTypeID)
        try container.encode(SelectedImageURL, forKey: .SelectedImageURL)
        try container.encode(UnSelectedImageURL, forKey: .UnSelectedImageURL)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encodeIfPresent(FourSquareCategoryID, forKey: .FourSquareCategoryID)
        try container.encodeIfPresent(RootCategoryID, forKey: .RootCategoryID)

    }
}

