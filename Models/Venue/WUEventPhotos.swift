//
//  WUEventPhotos.swift
//  Wussup
//
//  Created by MAC26 on 16/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "eventPhotos":[
 {
 "EventID": "1",
 "ImageURL": "https://i1.wp.com/www.myowncity.in/wp-content/uploads/2016/06/maniar-wonderland-water-park-rides.jpg?resize=768%2C301",
 "IsConverPhoto": "True"
 },
 {"EventID": "1", "ImageURL": "https://i1.wp.com/www.myowncity.in/wp-content/uploads/2016/06/maniar-wonderland-snow-park-ahmedabad.jpg?w=586",…},
 {"EventID": "1", "ImageURL": "https://i0.wp.com/www.myowncity.in/wp-content/uploads/2016/06/maniar-wonderland-snow-park-ahmedabad-rides-for-children.jpg?w=617",…}
 ]
 */

/*
 "EventID": "6",
 "ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636634651805913079.png",
 "IsConverPhoto": "True"
 */
class WUEventPhotos: NSObject , Decodable {
    var EventID             : String    = "0"
    var IsConverPhoto       : String    = "false"
    var ImageURL            : String    = ""
    var Height              : String    = ""
    var Width               : String    = ""
    var isExpanded          : Bool      = false
    var HeightFloat         : CGFloat   = 0.0
    var WidthFloat          : CGFloat   = 0.0
    var Description         : String    = ""
    
    private enum CodingKeys: String, CodingKey {
        case EventID
        case IsConverPhoto
        case ImageURL
        case Height
        case Width
        case Description
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let eventID = try values.decodeIfPresent(String.self, forKey: .EventID){
                self.EventID = eventID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .EventID) {
                self.EventID = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventPhotos for EventID ")
        }
        
        do {
            if let imageURL = try values.decodeIfPresent(String.self, forKey: .ImageURL) {
                if URL(string: imageURL) != nil {
                    self.ImageURL = imageURL
                }
                else {
                    self.ImageURL = imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventPhotos for ImageURL ")
        }
        
        do {
            if let isConverPhoto = try values.decodeIfPresent(String.self, forKey: .IsConverPhoto){
                self.IsConverPhoto = isConverPhoto
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsConverPhoto) {
                self.IsConverPhoto = String(val)
            }
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventPhotos for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventPhotos for Width ")
        }
        
        do {
            if let Description = try values.decodeIfPresent(String.self, forKey: .Description) {
                self.Description = Description
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventPhotos for Description ")
        }
        
    }
}

extension WUEventPhotos: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(EventID, forKey: .EventID)
        try container.encode(IsConverPhoto, forKey: .IsConverPhoto)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
        try container.encode(Description, forKey: .Description)
    }
}

