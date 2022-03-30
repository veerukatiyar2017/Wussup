//
//  WUEventPhotoDetail.swift
//  Wussup
//
//  Created by MAC219 on 6/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 
 "EventPhotoDetail":{
 "Name": "Event Photos",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/PhotoIcon@3x.png",
 "eventPhotos":[
 ]
 }
 
 */
class WUEventPhotoDetail: NSObject ,Decodable{
    
    var Name            : String            = ""
    var ImageURL        : String            = ""
    var eventPhotos     :[WUEventPhotos]    = []
    var isExpanded      : Bool              = false
    
    private enum CodingKeys: String, CodingKey {
        
        case Name
        case ImageURL
        case eventPhotos
    }
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws{
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPhotoDetail for Name ")
        }
        
        do {
            if let ImageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL){
                if URL(string: ImageURL) != nil {
                    self.ImageURL = ImageURL
                }
                else {
                    self.ImageURL = ImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPhotoDetail for ImageURL ")
        }
        
        do {
            if let eventPhotos = try values.decodeIfPresent([WUEventPhotos].self, forKey: .eventPhotos){
                self.eventPhotos = eventPhotos
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPhotoDetail for eventPhotos ")
        }
    }
}

extension WUEventPhotoDetail: Encodable{
    
    func encode(to encoder: Encoder) throws{
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(eventPhotos, forKey: .eventPhotos)
    }
}

