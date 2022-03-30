//
//  WUSpecialEvents.swift
//  Wussup
//
//  Created by MAC26 on 14/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "SpecialEvents":{
 "getEvents":[
 {
 "ID": "1",
 "Name": "Snow Park at Maniar's Wonderland\r\n",
 "Description": "Whimsical amusement park featuring an indoor area with artificial snow, rides & outdoor pools.",
 "Status": "1",
 "StartDate": "05/02/2018",
 "EndDate": "05/22/2018",
 "IsFeaturedEvent": "True",
 "NoOfViews": "50",
 "NoOfAccepted": "40",
 "NoOfDeclined": "10",
 "Promotor": "TTV",
 "Phone": "7048588392",
 "Address": "Sarkhej Sanand Highway,",
 "FullAddress": "Sarkhej Sanand Highway, Behind Kiran Motors , Sarkhej, Sarkhej, Ahmedabad, Gujarat 382210",
 "City": "Ahmedabad",
 "State": "Gujarat ",
 "Country": "India",
 "ZipCode": "382210",
 "CamURL": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
 "VenueID": "1",
 "CategoryID": "1",
 "eventPhotos":[{"EventID": "1", "ImageURL": "https://i1.wp.com/www.myowncity.in/wp-content/uploads/2016/06/maniar-wonderland-water-park-rides.jpg?resize=768%2C301",…]
 },
 {"ID": "6", "Name": "splash the fun world", "Description": "Water slides, rides & pools are the highlights at this family-friendly recreation park.",…}
 ],
 "CategoryID": "4",
 "CategoryName": "Event",
 "CategoryImage": "https://s3.amazonaws.com/wussup-sandbox/App_Images/EventsIcon%403x.png",
 "SelectedImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/FilterEventsActive%403x.png",
 "UnSelectedImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/FilterEventsNormal%403x.png",
 "CategoryFourSquareID": "4d4b7105d754a06373d81259"
 },
 */
class WUSpecialEvents: NSObject , Decodable {
    var CategoryID              : String                = "0"
    var CategoryName            : String                = ""
    var CategoryImage           : String                = ""
    var CategoryFourSquareID    : String                = ""
    var SelectedImageURL        : String                = ""
    var UnSelectedImageURL      : String                = ""
    var VenueSpecialEvents      : [WUEvent]             = []
    var isExpanded              : Bool                  = false
    
    
    private enum CodingKeys: String, CodingKey {
        
        case CategoryID
        case CategoryName
        case CategoryImage
        case CategoryFourSquareID
        case SelectedImageURL
        case UnSelectedImageURL
        case VenueSpecialEvents = "getEvents"
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
            Utill.printInTOConsole(printData:"solved type mismatched in CategoryID for WUSpecialEvents ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUSpecialEvents ")
        }
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUSpecialEvents ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryFourSquareID for WUSpecialEvents ")
        }
        
        do {
            if let selectedImageURL = try values.decodeIfPresent(String.self, forKey: .SelectedImageURL){
                self.SelectedImageURL = selectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                if URL(string: selectedImageURL) != nil {
                    self.SelectedImageURL = selectedImageURL
                }
                else {
                    self.SelectedImageURL = selectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUSpecialEvents for SelectedImageURL")
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
            Utill.printInTOConsole(printData:"type mismatched in WUSpecialEvents for UnSelectedImageURL")
        }
        
        do {
            if let getSpecialEvents = try values.decodeIfPresent([WUEvent].self, forKey: .VenueSpecialEvents){
                self.VenueSpecialEvents = getSpecialEvents
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in CategoryName for WUSpecialEvents ")
        }
    }
}

extension WUSpecialEvents: Encodable
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
        try container.encode(VenueSpecialEvents, forKey: .VenueSpecialEvents)
    }
}

