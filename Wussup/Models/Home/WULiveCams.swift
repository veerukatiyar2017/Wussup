//
//  WULiveCams.swift
//  demo
//
//  Created by MAC215 on 5/2/18.
//  Copyright © 2018 MAC215. All rights reserved.
//

import UIKit

/*"LocalLiveCams":{
 "CategoryID": 0,
 "CategoryName": "Live Cams",
 "CategoryImage": "http://web1.anasource.com/Wussup_UAT/images/API//LiveCamIcon.png",
 "CategoryFourSquareID": "",
 "LocalLiveCams":[
 {
 "LiveCamURL": "",
 "Name": "Wussup Reno Panoramic Cam",
 "Status": 1,
 "Description": "Test",
 "IsFeatured": true,
 "NoOfViews": 0,
 "VenueID": 1
 },
 {"LiveCamURL": "", "Name": "Kayak Kam", "Status": 1, "Description": "Test",…},
 {"LiveCamURL": "", "Name": "Sunset Truckee", "Status": 1, "Description": "Test",…}
 ]
 },*/

class WULiveCams: NSObject, Decodable {
    var CategoryID          : String            = "0"
    var CategoryName        : String            = ""
    var CategoryImage       : String            = ""
    var SelectedImageURL    : String            = ""
    var UnSelectedImageURL  : String            = ""
    var CategoryFourSquareID: String            = ""
    var LocalLiveCams       : [WUVenueLiveCams] = []
    var isExpanded              : Bool                  = false
    
    private enum CodingKeys: String, CodingKey {
        case CategoryName
        case CategoryImage
        case SelectedImageURL
        case UnSelectedImageURL
        case CategoryFourSquareID
        case LocalLiveCams
        case CategoryID
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
            Utill.printInTOConsole(printData:"type mismatched in WULiveCams for categoryName")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULiveCams for categoryImage")
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
            Utill.printInTOConsole(printData:"type mismatched in WULiveCams for SelectedImageURL ")
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
            Utill.printInTOConsole(printData:"type mismatched in WULiveCams for UnSelectedImageURL ")
        }
        
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULiveCams for categoryFourSquareID")
        }
        
        do {
            if let localLiveCams = try values.decodeIfPresent([WUVenueLiveCams].self, forKey: .LocalLiveCams) {
                self.LocalLiveCams = localLiveCams
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WULiveCams for localLiveCams")
        }
        
        do {
            if let categoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = categoryID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WULiveCams for categoryID")
        }
    }
}

extension WULiveCams: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encode(SelectedImageURL, forKey: .SelectedImageURL)
        try container.encode(UnSelectedImageURL, forKey: .UnSelectedImageURL)
        try container.encode(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(LocalLiveCams, forKey: .LocalLiveCams)
        try container.encode(CategoryID, forKey: .CategoryID)
    }
}


