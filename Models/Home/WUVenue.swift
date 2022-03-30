//
//  WUVenue.swift
//  Wussup
//
//  Created by MAC26 on 23/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

class WUVenue :NSObject, Decodable, Copying {
    
    var IsVenueOpen             : String                = "false"
    var CategoryImage           : String                = ""
    var CategoryName            : String                = ""
    var CategoryID              : String                = "0"
    var CategoryFourSquareID    : String                = ""
    var VenueDistance           : String                = ""
    var VenueCity               : String                = ""
    var VenueState              : String                = ""
    var FourSquareVenueID       : String                = ""
    var VenueAddress            : String                = ""
    var VenueRating             : String                = ""
    var IsSponseredVenues       : String                = "false"
    var VenuePhone              : String                = ""
    var VenueName               : String                = ""
    var SponsoredVenuID         : String                = "0"
    var VenueCountry            : String                = ""
    var VenuePostCode           : String                = ""
    var VenueURL                : String                = ""
    var VenueAtOpen             : String                = ""
    var VenueOpenDateTime       : String                = ""
    var VenueAtClose            : String                = ""
    var VenueCloseDateTime      : String                = ""
    var VenueLattitude          : String                = ""
    var VenueLongitude          : String                = ""
    var MapPinImageUrl          : String                = ""
    var VenueImages             : [WUVenueImages]       = []
    var LiveCamsURLs            : [WUVenueLiveCams]     = []
    var IsClaimVenue            : String                = "false"
    var Price                   : String                = ""
    var OverlayImageURL         : String                = ""
    var VenueFullAddress        : String                = ""
    var VenueStatusID           : Int                   =  0
    var IsPremiumVenue          : Bool                  = false
    var NoOfUserGiveVenueRating : String                = ""

    required init(original: WUVenue) {
        self.IsVenueOpen = original.IsVenueOpen
        self.CategoryImage = original.CategoryImage
        self.CategoryName = original.CategoryName
        self.VenueDistance = original.VenueDistance
        self.VenueCity = original.VenueCity
        self.VenueState = original.VenueState
        self.FourSquareVenueID = original.FourSquareVenueID
        self.VenueAddress = original.VenueAddress
        self.VenueRating = original.VenueRating
        self.IsSponseredVenues = original.IsSponseredVenues
        self.CategoryID = original.CategoryID
        self.VenuePhone = original.VenuePhone
        self.VenueName = original.VenueName
        self.SponsoredVenuID = original.SponsoredVenuID
        self.CategoryFourSquareID = original.CategoryFourSquareID
        self.VenueCountry = original.VenueCountry
        self.VenuePostCode = original.VenuePostCode
        self.VenueURL = original.VenueURL
        self.VenueAtOpen = original.VenueAtOpen
        self.VenueOpenDateTime = original.VenueOpenDateTime
        self.VenueAtClose = original.VenueAtClose
        self.VenueCloseDateTime = original.VenueCloseDateTime
        self.VenueLattitude = original.VenueLattitude
        self.VenueLongitude = original.VenueLongitude
        self.MapPinImageUrl = original.MapPinImageUrl
        self.VenueImages = original.VenueImages
        self.LiveCamsURLs = original.LiveCamsURLs
        self.IsClaimVenue = original.IsClaimVenue
        self.Price = original.Price
        self.OverlayImageURL = original.OverlayImageURL
        self.VenueStatusID = original.VenueStatusID
        self.VenueFullAddress = original.VenueFullAddress
        self.IsPremiumVenue = original.IsPremiumVenue
        self.NoOfUserGiveVenueRating = original.NoOfUserGiveVenueRating
    }
    
    private enum CodingKeys: String, CodingKey {
        case IsVenueOpen
        case CategoryImage
        case CategoryName
        case VenueDistance
        case VenueCity
        case VenueState
        case FourSquareVenueID
        case VenueAddress
        case VenueRating
        case IsSponseredVenues
        case CategoryID
        case VenuePhone
        case VenueName
        case SponsoredVenuID
        case CategoryFourSquareID
        case VenueCountry
        case VenuePostCode
        case VenueURL
        case VenueImages
        case VenueAtOpen
        case VenueOpenDateTime
        case VenueAtClose
        case VenueCloseDateTime
        case VenueLattitude
        case VenueLongitude
        case MapPinImageUrl
        case LiveCamsURLs
        case IsClaimVenue
        case Price
        case OverlayImageURL
        case VenueStatusID
        case VenueFullAddress
        case IsPremiumVenue = "PremiumVenue"
        case NoOfUserGiveVenueRating
    }
   
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let IsVenueOpen = try values.decodeIfPresent(String.self, forKey: .IsVenueOpen){
                self.IsVenueOpen = IsVenueOpen
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsVenueOpen) {
                // Can check for "parent" specifically if you want.
                self.IsVenueOpen = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenue for IsVenueOpen ")
        }
        
        
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage) {
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for CategoryImage ")
        }
       
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for CategoryName ")
        }
        
       
        do {
            if let venueDistance = try values.decodeIfPresent(String.self, forKey: .VenueDistance){
                self.VenueDistance = venueDistance
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueDistance ")
        }
      
        do {
            if let venueCity = try values.decodeIfPresent(String.self, forKey: .VenueCity){
                self.VenueCity = venueCity
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueCity ")
        }
       
        do {
            if let venueState = try values.decodeIfPresent(String.self, forKey: .VenueState){
                self.VenueState = venueState
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueState ")
        }
       
        do {
            if let fourSquareVenueID = try values.decodeIfPresent(String.self, forKey: .FourSquareVenueID){
                self.FourSquareVenueID = fourSquareVenueID
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for FourSquareVenueID ")
        }
        
        do {
            if let venueAddress = try values.decodeIfPresent(String.self, forKey: .VenueAddress){
                self.VenueAddress = venueAddress
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueAddress ")
        }
        
        do {
            if let venueRating = try values.decodeIfPresent(String.self, forKey: .VenueRating){
                self.VenueRating = venueRating
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueRating ")
        }
       
        do {
            if let isSponseredVenues = try values.decodeIfPresent(String.self, forKey: .IsSponseredVenues){
                self.IsSponseredVenues = isSponseredVenues
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSponseredVenues) {
                // Can check for "parent" specifically if you want.
                self.IsSponseredVenues = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUVenue for IsSponseredVenues ")
        }
       
        
        do {
            if let categoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = categoryID
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                // Can check for "parent" specifically if you want.
                self.CategoryID = String(val)
            }
             Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenue for CategoryID ")
        }
       
        
        do {
            if let venuePhone = try values.decodeIfPresent(String.self, forKey: .VenuePhone){
                self.VenuePhone = venuePhone
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenuePhone ")
        }
        
        
        do {
            if let venueName = try values.decodeIfPresent(String.self, forKey: .VenueName){
                self.VenueName = venueName
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueName ")
        }
        
        
        do {
            if let sponsoredVenuID = try values.decodeIfPresent(String.self, forKey: .SponsoredVenuID){
                self.SponsoredVenuID = sponsoredVenuID
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Int.self, forKey: .SponsoredVenuID) {
                // Can check for "parent" specifically if you want.
                self.SponsoredVenuID = String(val)
            }
             Utill.printInTOConsole(printData:"solved type mismatched in WUVenue for SponsoredVenuID ")
        }
        
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for CategoryFourSquareID ")
        }
        
        
        do {
            if let venueCountry = try values.decodeIfPresent(String.self, forKey: .VenueCountry){
                self.VenueCountry = venueCountry
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueCountry ")
        }
        
        do {
            if let venuePostCode = try values.decodeIfPresent(String.self, forKey: .VenuePostCode){
                self.VenuePostCode = venuePostCode
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenuePostCode ")
        }
        
        do {
            if let venueURL = try values.decodeIfPresent(String.self, forKey: .VenueURL){
                if URL(string: venueURL) != nil {
                    self.VenueURL = venueURL
                }
                else {
                    self.VenueURL = venueURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueURL ")
        }
        
        
        do {
            if let venueImages = try values.decodeIfPresent([WUVenueImages].self, forKey: .VenueImages){
                self.VenueImages = venueImages
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueImages ")
        }
        
        
        do {
            if let venueAtOpen = try values.decodeIfPresent(String.self, forKey: .VenueAtOpen){
                self.VenueAtOpen = venueAtOpen
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueAtOpen ")
        }
        
        
        do {
            if let venueOpenDateTime = try values.decodeIfPresent(String.self, forKey: .VenueOpenDateTime){
                self.VenueOpenDateTime = venueOpenDateTime
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueOpenDateTime ")
        }
        
        do {
            if let venueAtClose = try values.decodeIfPresent(String.self, forKey: .VenueAtClose){
                self.VenueAtClose = venueAtClose
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueAtClose ")
        }
       
        do {
            if let venueCloseDateTime = try values.decodeIfPresent(String.self, forKey: .VenueCloseDateTime){
                self.VenueCloseDateTime = venueCloseDateTime
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueCloseDateTime ")
        }
        
        do {
            if let VenueLattitude = try values.decodeIfPresent(String.self, forKey: .VenueLattitude){
                self.VenueLattitude = VenueLattitude
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueLattitude ")
        }
        
        do {
            if let VenueLongitude = try values.decodeIfPresent(String.self, forKey: .VenueLongitude){
                self.VenueLongitude = VenueLongitude
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for VenueLongitude ")
        }
        
        do {
            if let MapPinImageUrl = try values.decodeIfPresent(String.self, forKey: .MapPinImageUrl){
                if URL(string: MapPinImageUrl) != nil {
                    self.MapPinImageUrl = MapPinImageUrl
                }
                else {
                    self.MapPinImageUrl = MapPinImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for MapPinImageUrl ")
        }

        
        do {
            if let LiveCamsURLs = try values.decodeIfPresent([WUVenueLiveCams].self, forKey: .LiveCamsURLs){
                self.LiveCamsURLs = LiveCamsURLs
            }
        } catch DecodingError.typeMismatch {
             Utill.printInTOConsole(printData:"type mismatched in WUVenue for LiveCamsURLs ")
        }
        
        do {
            if let isClaimVenue = try values.decodeIfPresent(String.self, forKey: .IsClaimVenue){
                self.IsClaimVenue = isClaimVenue
            }
        } catch DecodingError.typeMismatch {
            // There was something for the "manage_stock" key, but it wasn't a boolean value. Try a string.
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsClaimVenue) {
                // Can check for "parent" specifically if you want.
                self.IsClaimVenue = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenue for IsClaimVenue ")
        }
        do {
            if let Price = try values.decodeIfPresent(String.self, forKey: .Price){
                self.Price = Price
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenue for Price ")
        }
        
        do {
            if let OverlayImageURL = try values.decodeIfPresent(String.self, forKey: .OverlayImageURL){
                self.OverlayImageURL = OverlayImageURL
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenue for OverlayImageURL ")
        }
        
        do {
            if let VenueStatusID = try values.decodeIfPresent(Int.self, forKey: .VenueStatusID){
                self.VenueStatusID = VenueStatusID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenue for VenueStatusID ")
        }
        
        do {
            if let VenueFullAddress = try values.decodeIfPresent(String.self, forKey: .VenueFullAddress){
                self.VenueFullAddress = VenueFullAddress
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenue for VenueFullAddress ")
        }
        
        do {
            if let IsPremiumVenue = try values.decodeIfPresent(Bool.self, forKey: .IsPremiumVenue){
                self.IsPremiumVenue = IsPremiumVenue
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsPremiumVenue) {
                self.IsPremiumVenue = val
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenue for isPremiumVenue ")
        }
        
        do {
            if let noOfUserGiveVenueRating = try values.decodeIfPresent(String.self, forKey: .NoOfUserGiveVenueRating){
                self.NoOfUserGiveVenueRating = noOfUserGiveVenueRating
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for NoOfUserGiveVenueRating ")
        }
    }
}

extension WUVenue: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(IsVenueOpen, forKey: .IsVenueOpen)
        try container.encode(VenueCity, forKey: .VenueCity)
        try container.encode(VenueState, forKey: .VenueState)
        try container.encode(FourSquareVenueID, forKey: .FourSquareVenueID)
        try container.encode(VenueAddress, forKey: .VenueAddress)
        try container.encode(VenueRating, forKey: .VenueRating)
        try container.encode(IsSponseredVenues, forKey: .IsSponseredVenues)
        try container.encode(CategoryID, forKey: .CategoryID)
        try container.encode(VenuePhone, forKey: .VenuePhone)
        try container.encode(VenueName, forKey: .VenueName)
        try container.encode(SponsoredVenuID, forKey: .SponsoredVenuID)
        try container.encode(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(VenueCountry, forKey: .VenueCountry)
        try container.encode(VenuePostCode, forKey: .VenuePostCode)
        try container.encode(VenueURL, forKey: .VenueURL)
        try container.encode(VenueImages, forKey: .VenueImages)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(VenueDistance, forKey: .VenueDistance)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encode(VenueAtOpen, forKey: .VenueImages)
        try container.encode(VenueOpenDateTime, forKey: .CategoryName)
        try container.encode(VenueAtClose, forKey: .VenueDistance)
        try container.encode(VenueCloseDateTime, forKey: .CategoryImage)
        try container.encode(LiveCamsURLs, forKey: .LiveCamsURLs)
        try container.encode(IsClaimVenue, forKey: .IsClaimVenue)
        try container.encode(Price, forKey: .Price)
        try container.encode(OverlayImageURL, forKey: .OverlayImageURL)
        try container.encode(VenueStatusID, forKey: .VenueStatusID)
        try container.encode(VenueFullAddress, forKey: .VenueFullAddress)
        try container.encode(IsPremiumVenue, forKey: .IsPremiumVenue)

    }
}




