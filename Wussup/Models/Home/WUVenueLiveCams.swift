//
//  WUVenueLiveCams.swift
//  Wussup
//
//  Created by MAC26 on 03/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "VenueFourSquareID": "4c112ddece640f472e253b52",
 "IsSponseredVenues": "True"
 
 {
 "Height" : "72",
 "IsFeatured" : "False",
 "Distance" : "2566.99",
 "EventID" : "",
 "VenueFourSquareID" : "4c112ddece640f472e253b52",
 "IsSponseredVenues" : "True",
 "ImageURL" : "https:\/\/s3.amazonaws.com\/wussup-sandbox\/App_Images\/Wussup_636681383158104222.png",
 "NoOfViews" : "0",
 "Width" : "70",
 "Description" : "This is first Live Cam",
 "LiveCamURL" : "http:\/\/edge02.hdontap.com:1935\/ingest01-hd1\/Guinea-Pig_Kungl.stream\/playlist.m3u8",
 "Status" : "1",
 "Name" : "Live Cam1",
 "VenueID" : "1"
 }
 */
class WUVenueLiveCams: NSObject, Decodable,Copying{
    
    var Height              : String    = ""
    var IsFeatured          : String    = "false"
    var Distance            : String    = ""
    var EventID             : String    = "0"
    var VenueFourSquareID   : String    = ""
    var IsSponseredVenues   : String    = "false"
    var ImageURL            : String    = ""
    var NoOfViews           : String    = "0"
    var Width               : String    = ""
    var Description         : String    = ""
    var LiveCamURL          : String    = ""
    var Name                : String    = ""
    var Status              : String    = ""
    var VenueID             : String    = "0"
    var HeightFloat         : CGFloat   = 0.0
    var WidthFloat          : CGFloat   = 0.0
    var GUID                : String    = ""
    var ID                  : String    = "0"
    var created             : String    = ""
    
    private enum CodingKeys: String, CodingKey {
        case LiveCamURL
        case Name
        case Status
        case Description
        case IsFeatured
        case NoOfViews
        case VenueID
        case VenueFourSquareID
        case IsSponseredVenues
        case ImageURL
        case Height
        case Width
        case Distance
        case EventID
        case GUID
        case ID
    }
    
    required init(original: WUVenueLiveCams) {
        self.Height             = original.Height
        self.IsFeatured         = original.IsFeatured
        self.Distance           = original.Distance
        self.EventID            = original.EventID
        self.VenueFourSquareID  = original.VenueFourSquareID
        self.IsSponseredVenues  = original.IsSponseredVenues
        self.ImageURL           = original.ImageURL
        self.NoOfViews          = original.NoOfViews
        self.Width              = original.Width
        self.Description        = original.Description
        self.LiveCamURL         = original.LiveCamURL
        self.Name               = original.Name
        self.Status             = original.Status
        self.VenueID            = original.VenueID
        self.GUID               = original.GUID
        self.ID                 = original.ID
    }
    
    
    override var description: String {
        var printString = ""
        printString += "\n*********************************"
        printString += "\n LiveCamURL        : \(LiveCamURL)"
        printString += "\n Name       : \(Name)"
        printString += "\n Status       : \(Status)"
        printString += "\n Description   : \(Description)"
        printString += "\n IsFeatured   : \(IsFeatured)"
        printString += "\n NoOfViews   : \(NoOfViews)"
        printString += "\n VenueID   : \(VenueID)"
        printString += "\n VenueFourSquareID   : \(VenueFourSquareID)"
        printString += "\n Distance   : \(Distance)"
        printString += "\n EventID   : \(EventID)"
        printString += "\n Height   : \(Height)"
        printString += "\n Width   : \(Width)"
        printString += "\n GUID   : \(GUID)"
         printString += "\n ID   : \(ID)"
        
        printString += "\n*********************************\n"
        return printString
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let liveCamURL = try values.decodeIfPresent(String.self, forKey: .LiveCamURL) {
                if URL(string: liveCamURL) != nil {
                    self.LiveCamURL = liveCamURL
                }
                else {
                    self.LiveCamURL = liveCamURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for liveCamURL ")
        }
        
        do {
            if let Distance = try values.decodeIfPresent(String.self, forKey: .Distance) {
                self.Distance = Distance
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for Distance ")
        }
        
        do {
            if let name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = name
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for name ")
        }
        
        do {
            if let status = try values.decodeIfPresent(String.self, forKey: .Status){
                self.Status = status
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for status ")
        }
        
        do {
            if let description = try values.decodeIfPresent(String.self, forKey: .Description) {
                self.Description = description
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for description ")
        }
        
        do {
            if let isFeatured = try values.decodeIfPresent(String.self, forKey: .IsFeatured){
                self.IsFeatured = isFeatured
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsFeatured) {
                self.IsFeatured = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLiveCams for isFeatured ")
        }
        
        do {
            if let noOfViews = try values.decodeIfPresent(String.self, forKey: .NoOfViews){
                self.NoOfViews = noOfViews
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .NoOfViews) {
                self.NoOfViews = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLiveCams for noOfViews ")
        }
        
        do {
            if let venueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = venueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLiveCams for venueID ")
        }
        
        do {
            if let EventID = try values.decodeIfPresent(String.self, forKey: .EventID){
                self.EventID = EventID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .EventID) {
                self.EventID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLiveCams for EventID ")
        }
        
        do {
            if let venueFourSquareID = try values.decodeIfPresent(String.self, forKey: .VenueFourSquareID) {
                self.VenueFourSquareID = venueFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for VenueFourSquareID ")
        }
        
        do {
            if let isSponseredVenues = try values.decodeIfPresent(String.self, forKey: .IsSponseredVenues){
                self.IsSponseredVenues = isSponseredVenues
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSponseredVenues) {
                self.IsSponseredVenues = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLiveCams for IsSponseredVenues ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for imageURL ")
        }
        
        do {
            if let Height = try values.decodeIfPresent(String.self, forKey: .Height){
                self.Height = Height
                if let floatValue = NumberFormatter().number( from: self.Height) {
                    self.HeightFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for Height ")
        }
        
        do {
            if let Width = try values.decodeIfPresent(String.self, forKey: .Width){
                self.Width = Width
                if let floatValue = NumberFormatter().number( from: self.Width) {
                    self.WidthFloat = CGFloat(truncating: floatValue)
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for Width ")
        }
        
        do {
            if let Guid = try values.decodeIfPresent(String.self, forKey: .GUID){
                self.GUID = Guid
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueLiveCams for GUID ")
        }
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID){
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueLiveCams for ID ")
        }
    }
}

extension WUVenueLiveCams: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(LiveCamURL, forKey: .LiveCamURL)
        try container.encode(Name, forKey: .Name)
        try container.encode(Status, forKey: .Status)
        try container.encode(Description, forKey: .Description)
        try container.encode(IsFeatured, forKey: .IsFeatured)
        try container.encode(NoOfViews, forKey: .NoOfViews)
        try container.encode(VenueID, forKey: .VenueID)
        try container.encode(VenueFourSquareID, forKey: .VenueFourSquareID)
        try container.encode(IsSponseredVenues, forKey: .IsSponseredVenues)
        try container.encode(ImageURL, forKey: .ImageURL)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
        try container.encode(GUID, forKey: .GUID)
        try container.encode(ID, forKey: .ID)
    }
}




