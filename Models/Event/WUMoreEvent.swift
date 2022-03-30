//
//  WUMoreEvent.swift
//  Wussup
//
//  Created by MAC105 on 30/08/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUMoreEvent: NSObject,Decodable {
    
    var ImageURL            : String        = ""
    var Height              : String        = ""
    var Width               : String        = ""
    var HeightFloat         : CGFloat       = 0.0
    var WidthFloat          : CGFloat       = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case ImageURL
        case Height
        case Width
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
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
            Utill.printInTOConsole(printData:"type mismatched in WUMoreEvent for ImageURL ")
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMoreEvent for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUMoreEvent for Width ")
        }
    }
}

extension WUMoreEvent: Encodable
{
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
    }
}
