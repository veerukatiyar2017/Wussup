//
//  WUVenueProfilePhotos.swift
//  Wussup
//
//  Created by MAC26 on 16/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "VenueImages":{
 "VenueImages":[{"SquareImage": "https://i1.wp.com/www.myowncity.in/wp-content/uploads/2016/06/maniar-wonderland-water-park-rides.jpg?resize=768%2C301",…],
 "CategoryID": "0",
 "CategoryName": "Photos",
 "CategoryImage": "https://s3.amazonaws.com/wussup-sandbox/App_Images/PhotoIcon%403x.png",
 "SelectedImageURL": "",
 "UnSelectedImageURL": "",
 "CategoryFourSquareID": ""
 },
 */
class WUVenueProfilePhotos: NSObject, Decodable {
    var CategoryID              : String                = "0"
    var CategoryName            : String                = ""
    var CategoryImage           : String                = ""
    var CategoryFourSquareID    : String                = ""
    var SelectedImageURL        : String                = ""
    var UnSelectedImageURL      : String                = ""
    var VenueImages             : [WUVenueImages]     = []
    var isExpanded              : Bool                  = false
    
    
    private enum CodingKeys: String, CodingKey {
        
        case CategoryID
        case CategoryName
        case CategoryImage
        case CategoryFourSquareID
        case SelectedImageURL
        case UnSelectedImageURL
        case VenueImages
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
            Utill.printInTOConsole(printData:"solved type mismatched in CategoryID for WULiveMusic ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WULiveMusic ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WULiveMusic ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryFourSquareID for WULiveMusic ")
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
            Utill.printInTOConsole(printData:"type mismatched in WULiveMusic for SelectedImageURL")
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
            Utill.printInTOConsole(printData:"type mismatched in WULiveMusic for UnSelectedImageURL")
        }
        
        do {
            if let venueImages = try values.decodeIfPresent([WUVenueImages].self, forKey: .VenueImages){
                self.VenueImages = venueImages
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WULiveMusic ")
        }
    }
}

extension WUVenueProfilePhotos: Encodable
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
        try container.encode(VenueImages, forKey: .VenueImages)
    }
}

