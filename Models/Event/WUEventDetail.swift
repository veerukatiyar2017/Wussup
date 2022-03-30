//
//  WUEventDetail.swift
//  Wussup
//
//  Created by MAC219 on 6/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUEventDetail: NSObject,Decodable {
    
    var ID                  : String                    = "0"
    var Name                : String                    = ""
    var Description         : String                    = ""
    var Status              : String                    = "1"
    var StartDate           : String                    = ""
    var EndDate             : String                    = ""
    var IsFeaturedEvent     : String                    = "false"
    var NoOfViews           : String                    = ""
    var NoOfAccepted        : String                    = ""
    var NoOfDeclined        : String                    = ""
    var Promotor            : String                    = ""
    var Phone               : String                    = ""
    var Address             : String                    = ""
    var FullAddress         : String                    = ""
    var City                : String                    = ""
    var State               : String                    = ""
    var Country             : String                    = ""
    var ZipCode             : String                    = ""
    var CamURL              : String                    = ""
    var WebsiteURL          : String                    = ""
    var VenueID             : String                    = "0"
    var CategoryID          : String                    = "0"
    var ConverPhotoURL      : String                    = ""
    var Latitude            : String                    = ""
    var Longitude           : String                    = ""
    var EventPhotoDetail    : WUEventPhotoDetail        = WUEventPhotoDetail()
    var EventPromoterDetail : WUEventPromoterDetail     = WUEventPromoterDetail()
    var MoreEventDetail     : WUMoreEventDetail         = WUMoreEventDetail()
    var DirectionDetail     : WUEventDirectionDetail    = WUEventDirectionDetail()
    var EventAdmissionDetail : WUEventAdmissionDetail    = WUEventAdmissionDetail()
    var LiveCamsURL         : [WUVenueLiveCams]         = []
    var Facebook            : String                    = ""
    var Twitter             : String                    = ""
    var Instagram           : String                    = ""
    var PriceRating         : String                    = ""
    var GUID                : String                    = ""
    var VideoURL            : String                    = ""
    var EventFeaturedImage  : String                    = ""
    
    private enum CodingKeys: String, CodingKey {
        case MoreEvents
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
        case Latitude
        case Longitude
        case EventPhotoDetail
        case EventPromoterDetail
        case MoreEventDetail
        case DirectionDetail
        case LiveCamsURL
        case Facebook
        case Twitter
        case Instagram
        case PriceRating
        case GUID
        case VideoURL
        case EventAdmissionDetail
        case EventFeaturedImage
        
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
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventDetail for ID ")
        }
        
        
        do {
            if let Name = try values.decodeIfPresent(String.self, forKey: .Name){
                self.Name = Name
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Name ")
        }
        
        
        do {
            if let Description = try values.decodeIfPresent(String.self, forKey: .Description){
                self.Description = Description
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Description ")
        }
        
        
        do {
            if let Status = try values.decodeIfPresent(String.self, forKey: .Status){
                self.Status = Status
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .Status) {
                self.Status = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventDetail for Status ")
        }
        
        
        do {
            if let StartDate = try values.decodeIfPresent(String.self, forKey: .StartDate){
                self.StartDate = StartDate
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for StartDate ")
        }
        
        
        do {
            if let EndDate = try values.decodeIfPresent(String.self, forKey: .EndDate){
                self.EndDate = EndDate
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for EndDate ")
        }
        
        do {
            if let IsFeaturedEvent = try values.decodeIfPresent(String.self, forKey: .IsFeaturedEvent){
                self.IsFeaturedEvent = IsFeaturedEvent
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsFeaturedEvent) {
                self.IsFeaturedEvent = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUEventDetail for IsFeaturedEvent ")
        }
        
        do {
            if let NoOfViews = try values.decodeIfPresent(String.self, forKey: .NoOfViews){
                self.NoOfViews = NoOfViews
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for NoOfViews ")
        }
        
        do {
            if let NoOfAccepted = try values.decodeIfPresent(String.self, forKey: .NoOfAccepted){
                self.NoOfAccepted = NoOfAccepted
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for NoOfAccepted ")
        }
        
        do {
            if let NoOfDeclined = try values.decodeIfPresent(String.self, forKey: .NoOfDeclined){
                self.NoOfDeclined = NoOfDeclined
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for NoOfDeclined ")
        }
        
        do {
            if let Promotor = try values.decodeIfPresent(String.self, forKey: .Promotor){
                self.Promotor = Promotor
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Promotor ")
        }
        
        do {
            if let Phone = try values.decodeIfPresent(String.self, forKey: .Phone){
                self.Phone = Phone
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Phone ")
        }
        
        do {
            if let Address = try values.decodeIfPresent(String.self, forKey: .Address){
                self.Address = Address
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Address ")
        }
        
        do {
            if let FullAddress = try values.decodeIfPresent(String.self, forKey: .FullAddress){
                self.FullAddress = FullAddress
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for FullAddress ")
        }
        
        do {
            if let City = try values.decodeIfPresent(String.self, forKey: .City){
                self.City = City
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for City ")
        }
        
        do {
            if let State = try values.decodeIfPresent(String.self, forKey: .State){
                self.State = State
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for State ")
        }
        
        do {
            if let Country = try values.decodeIfPresent(String.self, forKey: .Country){
                self.Country = Country
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Country ")
        }
        
        do {
            if let ZipCode = try values.decodeIfPresent(String.self, forKey: .ZipCode){
                self.ZipCode = ZipCode
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for ZipCode ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for CamURL ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for WebsiteURL ")
        }
        do {
            if let VenueID = try values.decodeIfPresent(String.self, forKey: .VenueID){
                self.VenueID = VenueID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueID) {
                self.VenueID = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventDetail for VenueID ")
        }
        
        do {
            if let CategoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = CategoryID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUEventDetail for CategoryID ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for ConverPhotoURL ")
        }
        
        do {
            if let Latitude = try values.decodeIfPresent(String.self, forKey: .Latitude){
                self.Latitude = Latitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Latitude ")
        }
        
        do {
            if let Longitude = try values.decodeIfPresent(String.self, forKey: .Longitude){
                self.Longitude = Longitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Longitude ")
        }
        
        do {
            if let EventPhotoDetail = try values.decodeIfPresent(WUEventPhotoDetail.self, forKey: .EventPhotoDetail){
                self.EventPhotoDetail = EventPhotoDetail
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for EventPhotoDetail ")
        }
        
        do {
            if let EventPromoterDetail = try values.decodeIfPresent(WUEventPromoterDetail.self, forKey: .EventPromoterDetail){
                self.EventPromoterDetail = EventPromoterDetail
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for EventPromoterDetail ")
        }
        
        do {
            if let MoreEventDetail = try values.decodeIfPresent(WUMoreEventDetail.self, forKey: .MoreEventDetail){
                self.MoreEventDetail = MoreEventDetail
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for MoreEventDetail ")
        }
        
        do {
            if let DirectionDetail = try values.decodeIfPresent(WUEventDirectionDetail.self, forKey: .DirectionDetail){
                self.DirectionDetail = DirectionDetail
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for DirectionDetail ")
        }
        do {
            if let LiveCamsURL = try values.decodeIfPresent([WUVenueLiveCams].self, forKey: .LiveCamsURL){
                self.LiveCamsURL = LiveCamsURL
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for LiveCamsURL ")
        }
        
        do {
            if let facebook = try values.decodeIfPresent(String.self, forKey: .Facebook){
                if URL(string: facebook) != nil {
                    self.Facebook = facebook
                }
                else {
                    self.Facebook = facebook.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Facebook ")
        }
        
        do {
            if let twitter = try values.decodeIfPresent(String.self, forKey: .Twitter){
                if URL(string: twitter) != nil {
                    self.Twitter = twitter
                }
                else {
                    self.Twitter = twitter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Twitter ")
        }
        
        do {
            if let instagram = try values.decodeIfPresent(String.self, forKey: .Instagram){
                if URL(string: instagram) != nil {
                    self.Instagram = instagram
                }
                else {
                    self.Instagram = instagram.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for Instagram ")
        }
        
        do {
            if let priceRating = try values.decodeIfPresent(String.self, forKey: .PriceRating){
                self.PriceRating = priceRating
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for PriceRating ")
        }
        
        do {
            if let GUID = try values.decodeIfPresent(String.self, forKey: .GUID){
                self.GUID = GUID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for GUID ")
        }
        
        do {
            if let VideoURL = try values.decodeIfPresent(String.self, forKey: .VideoURL){
                if URL(string: VideoURL) != nil {
                    self.VideoURL = VideoURL
                }
                else {
                    self.VideoURL = VideoURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for VideoURL ")
        }
        
        do {
            if let EventAdmissionDetail = try values.decodeIfPresent(WUEventAdmissionDetail.self, forKey: .EventAdmissionDetail){
                self.EventAdmissionDetail = EventAdmissionDetail
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for EventAdmissionDetail ")
        }
        
        do {
            if let EventFeaturedImage = try values.decodeIfPresent(String.self, forKey: .EventFeaturedImage){
                if URL(string: EventFeaturedImage) != nil {
                    self.EventFeaturedImage = EventFeaturedImage
                }
                else {
                    self.EventFeaturedImage = EventFeaturedImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUEventDetail for EventFeaturedImage ")
        }
    }
}

extension WUEventDetail: Encodable{
    
    func encode(to encoder: Encoder) throws{
        
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
        try container.encode(Latitude, forKey: .Latitude)
        try container.encode(Longitude, forKey: .Longitude)
        try container.encode(EventPhotoDetail, forKey: .EventPhotoDetail)
        try container.encode(EventPromoterDetail, forKey: .EventPromoterDetail)
        try container.encode(MoreEventDetail, forKey: .MoreEventDetail)
        try container.encode(DirectionDetail, forKey: .DirectionDetail)
        try container.encode(LiveCamsURL, forKey: .LiveCamsURL)
        try container.encode(Facebook, forKey: .Facebook)
        try container.encode(Twitter, forKey: .Twitter)
        try container.encode(Instagram, forKey: .Instagram)
        try container.encode(PriceRating, forKey: .PriceRating)
        try container.encode(GUID, forKey: .GUID)
        try container.encode(VideoURL, forKey: .VideoURL)
        try container.encode(EventAdmissionDetail, forKey: .EventAdmissionDetail)
        try container.encode(EventFeaturedImage, forKey: .EventFeaturedImage)
    }
}

