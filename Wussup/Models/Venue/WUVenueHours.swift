//
//  WUVenueHours.swift
//  Wussup
//
//  Created by MAC26 on 14/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

/*"includeToday": "True",
 "Days": "Sunday",
 "Time":["11:00 AM - 10:00 PM"]
 */

/*
 ImageURL": "https://s3.amazonaws.com/wussup-sandbox/App_Images/Wussup_636632192354354433.png",
 "includeToday": "False",
 "Days": null,
 "Time":[],
 "Height": "0",
 "Width": "0",
 "venueHoursLogs":[]
 */

import UIKit

class WUVenueHours: NSObject,Decodable {
    
    var ImageURL            : String        = ""
    var includeToday        : String        = "False"
    var Days                : String        = ""
    var Time                : [String]      = []
    var Height              : String        = ""
    var Width               : String        = ""
    var venueHoursLogs      : [String]      = []
    var isAddedToCalendar   : Bool          = false
    var HeightFloat         : CGFloat       = 0.0
    var WidthFloat          : CGFloat       = 0.0
    
    private enum CodingKeys: String, CodingKey {
        
        case ImageURL
        case includeToday
        case Days
        case Time
        case Height
        case Width
        case venueHoursLogs
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
            Utill.printInTOConsole(printData:"type mismatched in WUVenueHours for ImageURL ")
        }
        
        
        do {
            if let includeToday = try values.decodeIfPresent(String.self, forKey: .includeToday){
                self.includeToday = includeToday
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .includeToday) {
                self.includeToday = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueHours for includeToday ")
        }
        
        do {
            if let days = try values.decodeIfPresent(String.self, forKey: .Days){
                self.Days = days
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueHours for Days ")
        }
        
        do {
            if let Time = try values.decodeIfPresent([String].self, forKey: .Time){
                self.Time = Time
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueHours for Time ")
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueHours for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueHours for Width ")
        }
        
        do {
            if let venueHoursLogs = try values.decodeIfPresent([String].self, forKey: .venueHoursLogs){
                self.venueHoursLogs = venueHoursLogs
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueHours for venueHoursLogs ")
        }
    }
}

extension WUVenueHours: Encodable
{
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(includeToday, forKey: .includeToday)
        try container.encode(Days, forKey: .Days)
        try container.encode(Time, forKey: .Time)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
        try container.encode(venueHoursLogs, forKey: .venueHoursLogs)
        
    }
}

