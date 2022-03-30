//
//  WUEventPromoterDetail.swift
//  Wussup
//
//  Created by MAC219 on 6/6/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "Name": "Promoter",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/PromoterIcon@3x.png",
 "eventPromoter":[
 {"EventID": "6", "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636638070270892728.png",…},
 {"EventID": "6", "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636638070343398770.png",…},
 {"EventID": "6", "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636638070428135660.png",…},
 {"EventID": "6", "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636638070537224667.png",…},
 {"EventID": "6", "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636638070607850450.png",…}
 ]
 }
 */
class WUEventPromoterDetail: NSObject, Decodable {
   
    var Name            : String                = ""
    var ImageURL        : String                = ""
    var eventPromoter   :[WUEventPromotor]      = []
    var isExpanded      : Bool                  = false
    
    private enum CodingKeys: String, CodingKey {
        
        case Name
        case ImageURL
        case eventPromoter
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
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromoterDetail for Name ")
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
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromoterDetail for ImageURL ")
        }
        
        do {
            if let eventPromoter = try values.decodeIfPresent([WUEventPromotor].self, forKey: .eventPromoter){
                self.eventPromoter = eventPromoter
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEventPromoterDetail for eventPromoter ")
        }
    }
}

extension WUEventPromoterDetail: Encodable{
    
    func encode(to encoder: Encoder) throws{
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Name, forKey: .Name)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(eventPromoter, forKey: .eventPromoter)
    }
}
