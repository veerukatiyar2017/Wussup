
//  WUVenueDetail.swift
//  Wussup
//
//  Created by MAC26 on 14/05/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

/*
 "IsUserFavoriteVenue": "false",
 "VenueFavoriteCount": "0",
 "ClaimBusiness": "True",
 "VenueOpenStatus": "Open",
 "IsVenueOpen": "True",
 "Price": "$",
 "PriceType": "Moderate",
 "VenueDescription": "Best Burgers & Breakfast in Reno. Open 24/7.",
 "VenueCoverPhoto":{"SquareImage": "https://igx.4sqi.net/img/general/720x513/359875__iFXVD36o_DWhjM0PenPeVVjiASWQnUfKuHGIIbdy8g.jpg",…},
 "HappyHours":[{"Days": "Today", "Time":["10:00 AM–Noon", "6:00 PM–8:00 PM" ] },…],
 "OpenHours":[{"Days": "Mon–Sun", "Time":["24 Hours" ] }],
 "Menus":[{"Name": "Happy Hour Menu", "GetSubMenuTypes":[{"Name": "Main",…],
 "LiveCams":[],
 "Promotions":[],
 "Specials":[],
 "LiveMusic":[],
 "SpecialEvents":[],
 "IsSponseredVenues": "true",
 "SponsoredVenuID": "1",
 "VenueName": "Archie's Giant Hamburgers & Breakfast",
 "FourSquareVenueID": "4b6b4446f964a52008fd2be3",
 "CategoryID": null,
 "CategoryName": null,
 "CategoryImage": null,
 "CategoryFourSquareID": null,
 "VenueURL": "http://www.archiesfamousgrill.com",
 "VenueImages":[{"SquareImage": "https://igx.4sqi.net/img/general/720x513/359875__iFXVD36o_DWhjM0PenPeVVjiASWQnUfKuHGIIbdy8g.jpg",…],
 "VenueRating": "0",
 "VenueCity": "Reno",
 "VenueState": "NV",
 "VenueCountry": "United States",
 "VenuePostCode": "89503",
 "VenueDistance": null,
 "VenuePhone": "7753229595",
 "VenueAddress": "2195 N Virginia St (at N Sierra St)",
 "VenueLattitude": "39.54898",
 "VenueLongitude": "-119.8217",
 "VenueAtOpen": null,
 "VenueOpenDateTime": null,
 "VenueAtClose": null,
 "VenueCloseDateTime": null,
 "MapPinImageUrl": "http://web1.anasource.com/Wussup_UAT//images/API/MapPinIcon@2x.png"
 //
 "UserFavoriteVenueNotificationSettings":{
 "UserFavoriteVenueID": "10018",
 "IsSendPromotionalAlert": "True",
 "IsSendCustomNotification": "False",
 "PerDay": "0",
 "PerWeek": "0",
 "PerMonth": "0",
 "IsWeekEndNotification": "False",
 "IsSpecialEventNotification": "False"
 }
 */


class WUVenueDetail: NSObject,Decodable,Copying {
    
    var IsUserFavoriteVenue : String                = "false"
    var VenueFavoriteCount  : String                = "0"
    var UserVenueRating     : String                = "0"
    var ClaimBusiness       : String                = "false"
    var VenueOpenStatus     : String                = ""
    var IsVenueOpen         : String                = "false"
    var Price               : String                = "$"
    var PriceType           : String                = ""
    var VenueDescription    : String                = ""
    var VenueOpenHours      : [WUVenueHours]        = []
    var VenueCoverPhoto     : WUVenueImages         = WUVenueImages()
    var VenuePhotos         : WUVenueProfilePhotos  = WUVenueProfilePhotos()
    var VenueHappyHours     : WUVenueHappyHours     = WUVenueHappyHours()
    var Menus               : WUMenus               = WUMenus()
    var LiveCams            : WULiveCams            = WULiveCams()
    var Promotions          : WULocalPromotions     = WULocalPromotions()
    var Specials            : WUSpecials            = WUSpecials()
    var LiveMusic           : WULiveMusic           = WULiveMusic()
    var SpecialEvents       : WUSpecialEvents       = WUSpecialEvents()
    var IsSponseredVenues   : String                = "false"
    var SponsoredVenuID     : String                = "0"
    var VenueName           : String                = ""
    var FourSquareVenueID   : String                = ""
    var CategoryID          : String                = "0"
    var CategoryName        : String                = ""
    var CategoryImage       : String                = ""
    var CategoryFourSquareID : String               = ""
    var VenueURL            : String                = ""
    var VenueRating         : String                = ""
    var VenueCity           : String                = ""
    var VenueState          : String                = ""
    var VenueCountry        : String                = ""
    var VenuePostCode       : String                = ""
    var VenueDistance       : String                = ""
    var VenuePhone          : String                = ""
    var VenueAddress        : String                = ""
    var VenueLattitude      : String                = ""
    var VenueLongitude      : String                = ""
    var VenueAtOpen         : String                = ""
    var VenueOpenDateTime   : String                = ""
    var VenueAtClose        : String                = ""
    var VenueCloseDateTime  : String                = ""
    var MapPinImageUrl      : String                = ""
    var NoOfUserGiveVenueRating      : String       = ""
    var UserFavoriteVenueNotificationSettings : WUUserFavNotificationSettings = WUUserFavNotificationSettings()
    var LiveCamsURLs        : [String] = []
    var Twitter             : String                = ""
    var Facebook            : String                = ""
    var Instragram          : String                = ""
    var GUID                : String                = ""
    var OverlayImageURL     : String                = ""
    var SelectedImageURL    : String                = ""
    var UnSelectedImageURL  : String                = ""
    var VenueFeaturedImage  : String                = ""
    var VenueStatusID : Int = 0
    var VenueFullAddress  : String                = ""
    
    required init(original: WUVenueDetail) {
        self.IsUserFavoriteVenue = original.IsUserFavoriteVenue
        self.VenueFavoriteCount = original.VenueFavoriteCount
        self.UserVenueRating = original.UserVenueRating
        self.ClaimBusiness = original.ClaimBusiness
        self.VenueOpenStatus = original.VenueOpenStatus
        self.IsVenueOpen = original.IsVenueOpen
        self.Price = original.Price
        self.PriceType = original.PriceType
        self.VenueDescription = original.VenueDescription
        self.VenueOpenHours  = original.VenueOpenHours
        self.VenueCoverPhoto = original.VenueCoverPhoto
        self.VenuePhotos = original.VenuePhotos
        self.VenueHappyHours = original.VenueHappyHours
        self.Menus = original.Menus
        self.LiveCams = original.LiveCams
        self.Promotions = original.Promotions
        self.Specials = original.Specials
        self.LiveMusic = original.LiveMusic
        self.SpecialEvents = original.SpecialEvents
        self.IsSponseredVenues  = original.IsSponseredVenues
        self.SponsoredVenuID = original.SponsoredVenuID
        self.VenueName = original.VenueName
        self.FourSquareVenueID = original.FourSquareVenueID
        self.CategoryID = original.CategoryID
        self.CategoryName = original.CategoryName
        self.CategoryImage = original.CategoryImage
        self.CategoryFourSquareID = original.CategoryFourSquareID
        self.VenueURL = original.VenueURL
        self.VenueRating = original.VenueRating
        self.VenueCity = original.VenueCity
        self.VenueState = original.VenueState
        self.VenueCountry = original.VenueCountry
        self.VenuePostCode = original.VenuePostCode
        self.VenueDistance = original.VenueDistance
        self.VenuePhone = original.VenuePhone
        self.VenueAddress  = original.VenueAddress
        self.VenueLattitude = original.VenueLattitude
        self.VenueLongitude = original.VenueLongitude
        self.VenueAtOpen = original.VenueAtOpen
        self.VenueOpenDateTime = original.VenueOpenDateTime
        self.VenueAtClose = original.VenueAtClose
        self.VenueCloseDateTime = original.VenueCloseDateTime
        self.MapPinImageUrl = original.MapPinImageUrl
        self.NoOfUserGiveVenueRating = original.NoOfUserGiveVenueRating
        self.UserFavoriteVenueNotificationSettings = original.UserFavoriteVenueNotificationSettings
        self.LiveCamsURLs = original.LiveCamsURLs
        self.Twitter = original.Twitter
        self.Facebook = original.Facebook
        self.Instragram = original.Instragram
        self.GUID = original.GUID
        self.OverlayImageURL = original.OverlayImageURL
        self.SelectedImageURL = original.SelectedImageURL
        self.UnSelectedImageURL = original.UnSelectedImageURL
        self.VenueFeaturedImage = original.VenueFeaturedImage
        self.VenueStatusID = original.VenueStatusID
        self.VenueFullAddress = original.VenueFullAddress
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case IsUserFavoriteVenue
        case VenueFavoriteCount
        case ClaimBusiness
        case VenueOpenStatus
        case IsVenueOpen
        case Price
        case PriceType
        case VenueDescription
        case VenueCoverPhoto
        case VenueHappyHours
        case VenueOpenHours
        case Menus
        case LiveCams
        case Promotions
        case Specials
        case LiveMusic
        case SpecialEvents
        case IsSponseredVenues
        case SponsoredVenuID
        case VenueName
        case FourSquareVenueID
        case CategoryID
        case CategoryName
        case CategoryImage
        case CategoryFourSquareID
        case VenueURL
        case VenuePhotos
        case VenueRating
        case VenueCity
        case VenueState
        case VenueCountry
        case VenuePostCode
        case VenueDistance
        case VenuePhone
        case VenueAddress
        case VenueLattitude
        case VenueLongitude
        case VenueAtOpen
        case VenueOpenDateTime
        case VenueAtClose
        case VenueCloseDateTime
        case MapPinImageUrl
        case NoOfUserGiveVenueRating
        case UserVenueRating
        case UserFavoriteVenueNotificationSettings
        case LiveCamsURLs
        case Twitter
        case Facebook
        case Instragram
        case GUID
        case OverlayImageURL
        case SelectedImageURL
        case UnSelectedImageURL
        case VenueFeaturedImage
        case VenueStatusID
        case VenueFullAddress
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let isUserFavoriteVenue = try values.decodeIfPresent(String.self, forKey: .IsUserFavoriteVenue){
                self.IsUserFavoriteVenue = isUserFavoriteVenue
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsUserFavoriteVenue) {
                self.IsUserFavoriteVenue = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueDetail for IsUserFavoriteVenue ")
        }
        
        do {
            if let venueFavoriteCount = try values.decodeIfPresent(String.self, forKey: .VenueFavoriteCount){
                self.VenueFavoriteCount = venueFavoriteCount
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .VenueFavoriteCount) {
                self.VenueFavoriteCount = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenueDetail for VenueFavoriteCount ")
        }
        
        do {
            if let claimBusiness = try values.decodeIfPresent(String.self, forKey: .ClaimBusiness){
                self.ClaimBusiness = claimBusiness
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .ClaimBusiness) {
                self.ClaimBusiness = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueDetail for ClaimBusiness ")
        }
        
        do {
            if let venueOpenStatus = try values.decodeIfPresent(String.self, forKey: .VenueOpenStatus){
                self.VenueOpenStatus = venueOpenStatus
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueOpenStatus ")
        }
        
        do {
            if let isVenueOpen = try values.decodeIfPresent(String.self, forKey: .IsVenueOpen){
                self.IsVenueOpen = isVenueOpen
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsVenueOpen) {
                self.IsVenueOpen = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueDetail for IsVenueOpen ")
        }
        
        do {
            if let price = try values.decodeIfPresent(String.self, forKey: .Price){
                self.Price = price
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for Price ")
        }
        
        
        do {
            if let priceType = try values.decodeIfPresent(String.self, forKey: .PriceType){
                self.PriceType = priceType
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for PriceType ")
        }
        
        do {
            if let venueDescription = try values.decodeIfPresent(String.self, forKey: .VenueDescription){
                self.VenueDescription = venueDescription
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueDescription ")
        }
        
        do {
            if let venueCoverPhoto = try values.decodeIfPresent(WUVenueImages.self, forKey: .VenueCoverPhoto){
                self.VenueCoverPhoto = venueCoverPhoto
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueCoverPhoto ")
        }
        
        do {
            if let happyHours = try values.decodeIfPresent(WUVenueHappyHours.self, forKey: .VenueHappyHours){
                self.VenueHappyHours = happyHours
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for HappyHours ")
        }
        
        do {
            if let openHours = try values.decodeIfPresent([WUVenueHours].self, forKey: .VenueOpenHours){
                self.VenueOpenHours = openHours
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for OpenHours ")
        }
        
        do {
            if let menus = try values.decodeIfPresent(WUMenus.self, forKey: .Menus){
                self.Menus = menus
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for Menus ")
        }
        
        do {
            if let liveCams = try values.decodeIfPresent(WULiveCams.self, forKey: .LiveCams){
                self.LiveCams = liveCams
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for LiveCams ")
        }
        
        do {
            if let promotions = try values.decodeIfPresent(WULocalPromotions.self, forKey: .Promotions){
                self.Promotions = promotions
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for HappyHours ")
        }
        
        do {
            if let specials = try values.decodeIfPresent(WUSpecials.self, forKey: .Specials){
                self.Specials = specials
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for Specials ")
        }
        
        do {
            if let liveMusic = try values.decodeIfPresent(WULiveMusic.self, forKey: .LiveMusic){
                self.LiveMusic = liveMusic
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for LiveMusic ")
        }
        
        do {
            if let specialEvents = try values.decodeIfPresent(WUSpecialEvents.self, forKey: .SpecialEvents){
                self.SpecialEvents = specialEvents
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for SpecialEvents ")
        }
        
        do {
            if let isSponseredVenues = try values.decodeIfPresent(String.self, forKey: .IsSponseredVenues){
                self.IsSponseredVenues = isSponseredVenues
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Bool.self, forKey: .IsSponseredVenues) {
                self.IsSponseredVenues = String(val)
            }
            Utill.printInTOConsole(printData:"solved type mismatched in WUVenueDetail for IsSponseredVenues ")
        }
        
        do {
            if let sponsoredVenuID = try values.decodeIfPresent(String.self, forKey: .SponsoredVenuID){
                self.SponsoredVenuID = sponsoredVenuID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .SponsoredVenuID) {
                self.SponsoredVenuID = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenueDetail for SponsoredVenuID ")
        }
        
        do {
            if let venueName = try values.decodeIfPresent(String.self, forKey: .VenueName){
                self.VenueName = venueName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueName ")
        }
        
        do {
            if let fourSquareVenueID = try values.decodeIfPresent(String.self, forKey: .FourSquareVenueID){
                self.FourSquareVenueID = fourSquareVenueID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for FourSquareVenueID ")
        }
        
        do {
            if let categoryID = try values.decodeIfPresent(String.self, forKey: .CategoryID){
                self.CategoryID = categoryID
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .CategoryID) {
                self.CategoryID = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenueDetail for CategoryID ")
        }
        
        do {
            if let categoryName = try values.decodeIfPresent(String.self, forKey: .CategoryName){
                self.CategoryName = categoryName
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for CategoryName ")
        }
        do {
            if let categoryImage = try values.decodeIfPresent(String.self, forKey: .CategoryImage){
                self.CategoryImage = categoryImage
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for CategoryImage ")
        }
        
        do {
            if let categoryFourSquareID = try values.decodeIfPresent(String.self, forKey: .CategoryFourSquareID){
                self.CategoryFourSquareID = categoryFourSquareID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for CategoryFourSquareID ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueURL ")
        }
        
        do {
            if let venuePhotos = try values.decodeIfPresent(WUVenueProfilePhotos.self, forKey: .VenuePhotos){
                self.VenuePhotos = venuePhotos
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenuePhotos ")
        }
        
        do {
            if let venueRating = try values.decodeIfPresent(String.self, forKey: .VenueRating){
                self.VenueRating = venueRating
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueRating ")
        }
        
        do {
            if let venueCity = try values.decodeIfPresent(String.self, forKey: .VenueCity){
                self.VenueCity = venueCity
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueCity ")
        }
        
        do {
            if let venueState = try values.decodeIfPresent(String.self, forKey: .VenueState){
                self.VenueState = venueState
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueState ")
        }
        
        do {
            if let venueCountry = try values.decodeIfPresent(String.self, forKey: .VenueCountry){
                self.VenueCountry = venueCountry
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueCountry ")
        }
        
        do {
            if let venuePostCode = try values.decodeIfPresent(String.self, forKey: .VenuePostCode){
                self.VenuePostCode = venuePostCode
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenuePostCode ")
        }
        
        do {
            if let venueDistance = try values.decodeIfPresent(String.self, forKey: .VenueDistance){
                self.VenueDistance = venueDistance
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueDistance ")
        }
        
        do {
            if let venuePhone = try values.decodeIfPresent(String.self, forKey: .VenuePhone){
                self.VenuePhone = venuePhone
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenuePhone ")
        }
        
        do {
            if let venueAddress = try values.decodeIfPresent(String.self, forKey: .VenueAddress){
                self.VenueAddress = venueAddress
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueAddress ")
        }
        
        do {
            if let venueLattitude = try values.decodeIfPresent(String.self, forKey: .VenueLattitude){
                self.VenueLattitude = venueLattitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueLattitude ")
        }
        
        do {
            if let venueLongitude = try values.decodeIfPresent(String.self, forKey: .VenueLongitude){
                self.VenueLongitude = venueLongitude
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueLongitude ")
        }
        
        do {
            if let venueAtOpen = try values.decodeIfPresent(String.self, forKey: .VenueAtOpen){
                self.VenueAtOpen = venueAtOpen
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueAtOpen ")
        }
        
        do {
            if let venueOpenDateTime = try values.decodeIfPresent(String.self, forKey: .VenueOpenDateTime){
                self.VenueOpenDateTime = venueOpenDateTime
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueOpenDateTime ")
        }
        
        do {
            if let venueAtClose = try values.decodeIfPresent(String.self, forKey: .VenueAtClose){
                self.VenueAtClose = venueAtClose
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueAtClose ")
        }
        
        do {
            if let venueCloseDateTime = try values.decodeIfPresent(String.self, forKey: .VenueCloseDateTime){
                self.VenueCloseDateTime = venueCloseDateTime
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueCloseDateTime ")
        }
        
        do {
            if let mapPinImageUrl = try values.decodeIfPresent(String.self, forKey: .MapPinImageUrl){
                if URL(string: mapPinImageUrl) != nil {
                    self.MapPinImageUrl = mapPinImageUrl
                }
                else {
                    self.MapPinImageUrl = mapPinImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for MapPinImageUrl ")
        }
        
        do {
            if let noOfUserGiveVenueRating = try values.decodeIfPresent(String.self, forKey: .NoOfUserGiveVenueRating){
                self.NoOfUserGiveVenueRating = noOfUserGiveVenueRating
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for NoOfUserGiveVenueRating ")
        }
        
        do {
            if let userVenueRating = try values.decodeIfPresent(String.self, forKey: .UserVenueRating){
                self.UserVenueRating = userVenueRating
            }
        } catch DecodingError.typeMismatch {
            if let val = try values.decodeIfPresent(Int.self, forKey: .UserVenueRating) {
                self.UserVenueRating = String(val)
            }
            Utill.printInTOConsole(printData:"solvedtype mismatched in WUVenueDetail for UserVenueRating ")
        }
        
        do {
            if let UserFavoriteVenueNotificationSettings = try values.decodeIfPresent(WUUserFavNotificationSettings.self, forKey: .UserFavoriteVenueNotificationSettings){
                self.UserFavoriteVenueNotificationSettings = UserFavoriteVenueNotificationSettings
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for UserFavoriteVenueNotificationSettings ")
        }
        do {
            if let LiveCamsURLs = try values.decodeIfPresent([String].self, forKey: .LiveCamsURLs){
                self.LiveCamsURLs = LiveCamsURLs
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for LiveCamsURLs ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for Twitter ")
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
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for Facebook ")
        }
        
        do {
            if let instagram = try values.decodeIfPresent(String.self, forKey: .Instragram){
                if URL(string: instagram) != nil {
                    self.Instragram = instagram
                }
                else {
                    self.Instragram = instagram.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for Instragram")
        }
        
        do {
            if let GUID = try values.decodeIfPresent(String.self, forKey: .GUID){
                self.GUID = GUID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for GUID")
        }
        do {
            if let OverlayImageURL = try values.decodeIfPresent(String.self, forKey: .OverlayImageURL){
                if URL(string: OverlayImageURL) != nil {
                    self.OverlayImageURL = OverlayImageURL
                }
                else {
                    self.OverlayImageURL = OverlayImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for OverlayImageURL")
        }
        
        do {
            if let SelectedImageURL = try values.decodeIfPresent(String.self, forKey: .SelectedImageURL){
                if URL(string: SelectedImageURL) != nil {
                    self.SelectedImageURL = SelectedImageURL
                }
                else {
                    self.SelectedImageURL = SelectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for SelectedImageURL ")
        }
        
        do {
            if let UnSelectedImageURL = try values.decodeIfPresent(String.self, forKey: .UnSelectedImageURL){
                if URL(string: UnSelectedImageURL) != nil {
                    self.UnSelectedImageURL = UnSelectedImageURL
                }
                else {
                    self.UnSelectedImageURL = UnSelectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for UnSelectedImageURL ")
        }
        
        do {
            if let VenueFeaturedImage = try values.decodeIfPresent(String.self, forKey: .VenueFeaturedImage){
                if URL(string: VenueFeaturedImage) != nil {
                    self.VenueFeaturedImage = VenueFeaturedImage
                }
                else {
                    self.VenueFeaturedImage = UnSelectedImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                }
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueFeaturedImage ")
        }
        
        do {
            if let VenueStatusID = try values.decodeIfPresent(Int.self, forKey: .VenueStatusID){
                self.VenueStatusID = VenueStatusID
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueStatusID ")
        }
        
        do {
            if let VenueFullAddress = try values.decodeIfPresent(String.self, forKey: .VenueFullAddress){
                self.VenueFullAddress = VenueFullAddress
            }
        } catch DecodingError.typeMismatch {
            Utill.printInTOConsole(printData:"type mismatched in WUVenueDetail for VenueFullAddress ")
        }
    }
}

extension WUVenueDetail: Encodable
{
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(IsUserFavoriteVenue, forKey: .IsUserFavoriteVenue)
        try container.encode(VenueFavoriteCount, forKey: .VenueFavoriteCount)
        try container.encode(ClaimBusiness, forKey: .ClaimBusiness)
        try container.encode(VenueOpenStatus, forKey: .VenueOpenStatus)
        try container.encode(IsVenueOpen, forKey: .IsVenueOpen)
        try container.encode(Price, forKey: .Price)
        try container.encode(PriceType, forKey: .PriceType)
        try container.encode(VenueDescription, forKey: .VenueDescription)
        try container.encode(VenueCoverPhoto, forKey: .VenueCoverPhoto)
        try container.encode(VenueHappyHours, forKey: .VenueHappyHours)
        try container.encode(VenueOpenHours, forKey: .VenueOpenHours)
        try container.encode(Menus, forKey: .Menus)
        try container.encode(LiveCams, forKey: .LiveCams)
        try container.encode(Promotions, forKey: .Promotions)
        try container.encode(Specials, forKey: .Specials)
        try container.encode(LiveMusic, forKey: .LiveMusic)
        try container.encode(SpecialEvents, forKey: .SpecialEvents)
        try container.encode(IsSponseredVenues, forKey: .IsSponseredVenues)
        try container.encode(SponsoredVenuID, forKey: .SponsoredVenuID)
        try container.encode(VenueName, forKey: .VenueName)
        try container.encode(FourSquareVenueID, forKey: .FourSquareVenueID)
        try container.encode(CategoryID, forKey: .CategoryID)
        try container.encode(CategoryName, forKey: .CategoryName)
        try container.encode(CategoryImage, forKey: .CategoryImage)
        try container.encode(CategoryFourSquareID, forKey: .CategoryFourSquareID)
        try container.encode(VenueURL, forKey: .VenueURL)
        try container.encode(VenuePhotos, forKey: .VenuePhotos)
        try container.encode(VenueRating, forKey: .VenueRating)
        try container.encode(VenueCity, forKey: .VenueCity)
        try container.encode(VenueState, forKey: .VenueState)
        try container.encode(VenueCountry, forKey: .VenueCountry)
        try container.encode(VenuePostCode, forKey: .VenuePostCode)
        try container.encode(VenueDistance, forKey: .VenueDistance)
        try container.encode(VenuePhone, forKey: .VenuePhone)
        try container.encode(VenueAddress, forKey: .VenueAddress)
        try container.encode(VenueLattitude, forKey: .VenueLattitude)
        try container.encode(VenueLongitude, forKey: .VenueLongitude)
        try container.encode(VenueAtOpen, forKey: .VenueAtOpen)
        try container.encode(VenueOpenDateTime, forKey: .VenueOpenDateTime)
        try container.encode(VenueAtClose, forKey: .VenueAtClose)
        try container.encode(VenueCloseDateTime, forKey: .VenueCloseDateTime)
        try container.encode(MapPinImageUrl, forKey: .MapPinImageUrl)
        try container.encode(UserVenueRating, forKey: .MapPinImageUrl)
        try container.encode(UserFavoriteVenueNotificationSettings, forKey: .UserFavoriteVenueNotificationSettings)
        try container.encode(LiveCamsURLs, forKey: .LiveCamsURLs)
        try container.encode(Twitter, forKey: .Twitter)
        try container.encode(Facebook, forKey: .Facebook)
        try container.encode(Instragram, forKey: .Instragram)
        try container.encode(Instragram, forKey: .Instragram)
        try container.encode(GUID, forKey: .GUID)
        try container.encode(OverlayImageURL, forKey: .OverlayImageURL)
        try container.encode(SelectedImageURL, forKey: .SelectedImageURL)
        try container.encode(UnSelectedImageURL, forKey: .UnSelectedImageURL)
        try container.encode(VenueFeaturedImage, forKey: .VenueFeaturedImage)
        try container.encode(VenueStatusID, forKey: .VenueStatusID)
        try container.encode(VenueFullAddress, forKey: .VenueFullAddress)
    }
}


