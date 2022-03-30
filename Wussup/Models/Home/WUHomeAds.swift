//
//  WUHomeAds.swift
//  Wussup
//
//  Created by MAC26 on 25/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 {
 "ID": "1",
 "EventID": "2",
 "VideoURL": "https://wussup-sandbox.s3.amazonaws.com/App_Videos/exportloop123.mp4",
 "Banners":["https://wussup-sandbox.s3.amazonaws.com/App_Images/promoter.png", "https://wussup-sandbox.s3.amazonaws.com/App_Images/Child-Girl-with-Sunflowers-Images.jpg",…]
"BannerList":[{"ImageURL": "https://wussup-sandbox.s3.amazonaws.com/App_Images/promoter.png", "Width": "262",…]
 }
 
 }*/
class WUHomeAds:NSObject, Decodable {
    var ID                      : String                = "0"
    var BannerList              : [WUHomeBannerList]    = []
    var VideoList               : [WUHomeVideoList]     = []
    var PlaceholderVideoAds     : WUPlaceholder!
    var PlaceholderBannerAds    : WUPlaceholder!
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case BannerList
        case VideoList
        case PlaceholderVideoAds
        case PlaceholderBannerAds
    }
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n ID           : \(ID)"
        printString += "\n BannerList   : \(BannerList)"
        printString += "\n VideoList    : \(VideoList)"
        printString += "\n VideosPlaceholder : \(String(describing: PlaceholderVideoAds))"
        printString += "\n BannerAdsPlaceholder : \(String(describing: PlaceholderBannerAds))"

        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let iD = try values.decodeIfPresent(String.self, forKey: .ID) {
                self.ID = iD
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUHomeAds for ID ")
        }
     
        do {
            if let videoList = try values.decodeIfPresent([WUHomeVideoList].self, forKey: .VideoList){
                self.VideoList = videoList //>>> video general
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUHomeAds for VideoList")
        }
        
        
        do {
            if let BannerList = try values.decodeIfPresent([WUHomeBannerList].self, forKey: .BannerList){
                self.BannerList = BannerList
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeAds for BannerList")
        }
        
        do {
            if let VideosPlaceholder = try values.decodeIfPresent(WUPlaceholder.self, forKey: .PlaceholderVideoAds){
                self.PlaceholderVideoAds = VideosPlaceholder
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeAds for PlaceholderVideoAds")
        }
        
        do {
            if let BannerAdsPlaceholder = try values.decodeIfPresent(WUPlaceholder.self, forKey: .PlaceholderBannerAds){
                self.PlaceholderBannerAds = BannerAdsPlaceholder
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUHomeAds for PlaceholderBannerAds")
        }
    }
}

extension WUHomeAds: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(BannerList, forKey: .BannerList)
        try container.encode(VideoList, forKey: .VideoList)
        try container.encode(PlaceholderVideoAds, forKey: .PlaceholderVideoAds)
        try container.encode(PlaceholderBannerAds, forKey: .PlaceholderBannerAds)
    }
}
