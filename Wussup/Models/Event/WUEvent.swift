//
//  WUEvent.swift
//  Wussup
//
//  Created by MAC219 on 6/1/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
/*
 "ID": "6",
 "Name": "Event1",
 "Description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Why do we use it? It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
 "Status": "1",
 "StartDate": "06/09/2018 01:00 PM",
 "EndDate": "06/20/2018 01:30 PM",
 "IsFeaturedEvent": "True",
 "NoOfViews": "0",
 "NoOfAccepted": "0",
 "NoOfDeclined": "0",
 "Promotor": "Admin",
 "Phone": null,
 "Address": null,
 "FullAddress": "TatvaSoft House, Opp. Kensville Golf Academy, Near Shivalik Business, Center, Sarkhej - Gandhinagar Highway, Off, Rajpath Rangoli Road, Ahmedabad, Gujarat 380054",
 "City": null,
 "State": null,
 "Country": null,
 "ZipCode": null,
 "CamURL": null,
 "VenueID": "2",
 "CategoryID": "1",
 "ConverPhotoURL": null,
 "eventPhotos":[],
 "eventPromotor":[]
 */
class WUEvent:NSObject,Decodable {
    
    var ID              : String            = "0"
    var Name            : String            = ""
    var Description     : String            = ""
    var Status          : String            = "1"
    var StartDate       : String            = ""
    var EndDate         : String            = ""
    var IsFeaturedEvent : String            = "false"
    var NoOfViews       : String            = ""
    var NoOfAccepted    : String            = ""
    var NoOfDeclined    : String            = ""
    var Promotor        : String            = ""
    var Phone           : String            = ""
    var Address         : String            = ""
    var FullAddress     : String            = ""
    var City            : String            = ""
    var State           : String            = ""
    var Country         : String            = ""
    var ZipCode         : String            = ""
    var CamURL          : String            = ""
    var WebsiteURL      : String            = ""
    var VenueID         : String            = "0"
    var CategoryID      : String            = "0"
    var ConverPhotoURL  : String            = ""
    var eventPhotos     : [WUEventPhotos]   = []
    var eventPromotor   : [WUEventPromotor] = []
    var Height          : String            = ""
    var Width           : String            = ""
    var HeightFloat     : CGFloat           = 0.0
    var WidthFloat      : CGFloat           = 0.0
    var LiveCamsURL     : [WUVenueLiveCams]          = []
    var PriceRating         : String                    = ""
    var GUID                : String                    = ""
    var VideoURL            : String                    = ""
    
    private enum CodingKeys: String, CodingKey {
        
        case ID
        case Name
        case Description
        case Status
        case StartDate
        case EndDate
        case IsFeaturedEvent
        case NoOfViews
        case NoOfAccepted
        case NoOfDeclined
        case Promotor
        case Phone
        case Address
        case FullAddress
        case City
        case State
        case Country
        case ZipCode
        case CamURL
        case WebsiteURL
        case VenueID
        case CategoryID
        case ConverPhotoURL
        case eventPhotos
        case eventPromotor
        case Height
        case Width
        case LiveCamsURL
        case PriceRating
        case GUID
        case VideoURL
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        do {
            if let ID = try values.decodeIfPresent(String.self, forKey: .ID){
                self.ID = ID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .ID) {
                self.ID = String(val)
            }
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUEvent for ID ")
        }
        
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for Name ")
        }
        
        
        do {
            if let Description = try values.decodeIfPresent(String.self, forKey: .Description){
                self.Description = Description
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for Description ")
        }
        
        
        do {
            if let Status = try values.decodeIfPresent(String.self, forKey: .Status){
                self.Status = Status
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .Status) {
                self.Status = String(val)
            }
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUEvent for Status ")
        }
        
        
        do {
            if let StartDate = try values.decodeIfPresent(String.self, forKey: .StartDate){
                self.StartDate = StartDate
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for StartDate ")
        }
        
        
        do {
            if let EndDate = try values.decodeIfPresent(String.self, forKey: .EndDate){
                self.EndDate = EndDate
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for EndDate ")
        }
        
        do {
            if let IsFeaturedEvent = try values.decodeIfPresent(String.self, forKey: .IsFeaturedEvent){
                self.IsFeaturedEvent = IsFeaturedEvent
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsFeaturedEvent) {
                self.IsFeaturedEvent = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUEvent for IsFeaturedEvent ")
        }
        
        do {
            if let NoOfViews = try values.decodeIfPresent(String.self, forKey: .NoOfViews){
                self.NoOfViews = NoOfViews
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for NoOfViews ")
        }
        
        do {
            if let NoOfAccepted = try values.decodeIfPresent(String.self, forKey: .NoOfAccepted){
                self.NoOfAccepted = NoOfAccepted
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for NoOfAccepted ")
        }
        
        do {
            if let NoOfDeclined = try values.decodeIfPresent(String.self, forKey: .NoOfDeclined){
                self.NoOfDeclined = NoOfDeclined
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for NoOfDeclined ")
        }
        
        do {
            if let Promotor = try values.decodeIfPresent(String.self, forKey: .Promotor){
                self.Promotor = Promotor
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for Promotor ")
        }
        
        do {
            if let Phone = try values.decodeIfPresent(String.self, forKey: .Phone){
                self.Phone = Phone
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for Phone ")
        }
        
        do {
            if let Address = try values.decodeIfPresent(String.self, forKey: .Address){
                self.Address = Address
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for Address ")
        }
        
        do {
            if let FullAddress = try values.decodeIfPresent(String.self, forKey: .FullAddress){
                self.FullAddress = FullAddress
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for FullAddress ")
        }
        
        do {
            if let City = try values.decodeIfPresent(String.self, forKey: .City){
                self.City = City
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for City ")
        }
        
        do {
            if let State = try values.decodeIfPresent(String.self, forKey: .State){
                self.State = State
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for State ")
        }
        
        do {
            if let Country = try values.decodeIfPresent(String.self, forKey: .Country){
                self.Country = Country
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for Country ")
        }
        
        do {
            if let ZipCode = try values.decodeIfPresent(String.self, forKey: .ZipCode){
                self.ZipCode = ZipCode
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for ZipCode ")
        }
        
        do {
            if let CamURL = try values.decodeIfPresent(String.self, forKey: .CamURL){
                if URL(string: CamURL) != nil {
                    self.CamURL = CamURL
                }
                else {
                    self.CamURL = CamURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for CamURL ")
        }
        
        do {
            if let WebsiteURL = try values.decodeIfPresent(String.self, forKey: .WebsiteURL){
                if URL(string: WebsiteURL) != nil {
                    self.WebsiteURL = WebsiteURL
                }
                else {
                    self.WebsiteURL = WebsiteURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for WebsiteURL ")
        }
        
        do {
            if let VenueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = VenueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUEvent for VenueID ")
        }
        
        do {
            if let CategoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = CategoryID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUEvent for CategoryID ")
        }
        
        do {
            if let ConverPhotoURL = try values.decodeIfPresent(String.self, forKey: .ConverPhotoURL){
                if URL(string: ConverPhotoURL) != nil {
                    self.ConverPhotoURL = ConverPhotoURL
                }
                else {
                    self.ConverPhotoURL = ConverPhotoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for ConverPhotoURL ")
        }
        
        do {
            if let eventPhotos = try values.decodeIfPresent([WUEventPhotos].self, forKey: .eventPhotos){
                self.eventPhotos = eventPhotos
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for eventPhotos ")
        }
        
        do {
            if let eventPromotor = try values.decodeIfPresent([WUEventPromotor].self, forKey: .eventPromotor){
                self.eventPromotor = eventPromotor
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for eventPromotor ")
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
            if let LiveCamsURL = try values.decodeIfPresent([WUVenueLiveCams].self, forKey: .LiveCamsURL){
                self.LiveCamsURL = LiveCamsURL
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUEvent for LiveCamsURL ")
        }
        do {
            if let priceRating = try values.decodeIfPresent(String.self, forKey: .PriceRating){
                self.PriceRating = priceRating
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEvent for PriceRating ")
        }
        
        do {
            if let GUID = try values.decodeIfPresent(String.self, forKey: .GUID){
                self.GUID = GUID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEvent for GUID ")
        }
        
        do {
            if let VideoURL = try values.decodeIfPresent(String.self, forKey: .VideoURL){
                self.VideoURL = VideoURL
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEvent for VideoURL ")
        }
    }
}

extension WUEvent: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(Name, forKey: .Name)
        try container.encode(Description, forKey: .Description)
        try container.encode(Status, forKey: .Status)
        try container.encode(StartDate, forKey: .StartDate)
        try container.encode(EndDate, forKey: .EndDate)
        try container.encode(NoOfViews, forKey: .NoOfViews)
        try container.encode(NoOfAccepted, forKey: .NoOfAccepted)
        try container.encode(NoOfDeclined, forKey: .NoOfDeclined)
        try container.encode(Promotor, forKey: .Promotor)
        try container.encode(Phone, forKey: .Phone)
        try container.encode(Address, forKey: .Address)
        try container.encode(FullAddress, forKey: .FullAddress)
        try container.encode(City, forKey: .City)
        try container.encode(State, forKey: .State)
        try container.encode(Country, forKey: .Country)
        try container.encode(ZipCode, forKey: .ZipCode)
        try container.encode(CamURL, forKey: .CamURL)
        try container.encode(WebsiteURL, forKey: .WebsiteURL)
        try container.encode(VenueID, forKey: .VenueID)
        try container.encode(ConverPhotoURL, forKey: .ConverPhotoURL)
        try container.encode(eventPhotos, forKey: .eventPhotos)
        try container.encode(eventPromotor, forKey: .eventPromotor)
        try container.encode(Height, forKey: .Height)
        try container.encode(Width, forKey: .Width)
        try container.encode(LiveCamsURL, forKey: .LiveCamsURL)
        try container.encode(PriceRating, forKey: .PriceRating)
        try container.encode(GUID, forKey: .GUID)
        try container.encode(VideoURL, forKey: .VideoURL)
    }
}
