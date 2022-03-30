//
//  WUPlaceholder.swift
//  Wussup
//
//  Created by Serik on 5/16/19.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class WUPlaceholder: NSObject, Decodable {
    
    // TypePlaceholder.Cafes.stringValue
    enum TypePlaceholder: String {
        case LiveCams             = "PlaceholderLiveCams"               // WUHomeViewAndCollectionTableCell
        case Other                = "PlaceholderOther"                  // WUHomeViewAndCollectionTableCell
        case ArtsandEntertainment = "PlaceholderArtsandEntertainment"   // WUHomeViewAndCollectionTableCell
        case LocalPromotion       = "PlaceholderLocalPromotionAds"      // WULocalPromotionTableCell
        case Outdoors             = "PlaceholderOutdoors"               // WUHomeTableCell
        case Cafes                = "PlaceholderCafes"                  // WUHomeTableCell
        case Colleges             = "PlaceholderColleges"               // WUHomeTableCell
        case Event                = "PlaceholderEventAds"               // WUHomeTableCell
        case Music                = "PlaceholderMusic"                  // WUHomeTableCell
        case Shop                 = "PlaceholderShop"                   // WUHomeTableCell
        case Travel               = "PlaceholderTravel"                 // WUHomeTableCell
        case Nightlife            = "PlaceholderNightlife"              // WUHomeTableCell
        case TopSpotAds           = "PlaceholderTopSpotAds"             // WUHomeTableCell
        case Food                 = "PlaceholderFood"                   // WUHomeTableCell
        
        case CardAds              = "PlaceholderCardAds"                // PlaceholderTableCell
        
        //case PlaceholderVideoAds
        //case PlaceholderBannerAds
        
        var stringValue: String {
            return rawValue
        }
    }
    
    var Url              : String = ""
    var FileType         : String = ""
    
    private enum CodingKeys: String, CodingKey {
        case Url
        case FileType
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n Url               : \(Url)"
        printString += "\n FileType          : \(FileType)"
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let Url = try values.decodeIfPresent(String.self, forKey: .Url){
                if URL(string: Url) != nil {
                    self.Url = Url
                } else {
                    self.Url = Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUPlaceholder for Url ")
        }

        do {
            if let FileType = try values.decodeIfPresent(String.self, forKey: .FileType){
                self.FileType = FileType
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUPlaceholder for FileType ")
        }
    }
}

extension WUPlaceholder: Encodable {
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Url, forKey: .Url)
        try container.encode(FileType, forKey: .FileType)
    }
}
