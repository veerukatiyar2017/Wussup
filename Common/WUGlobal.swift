//
//  WUGlobal.swift
//  Wussup
//
//  Created by MAC219 on 4/20/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import CoreLocation

enum Categories:Int,Codable {
    case none
    case topSpots
    case localPromotions
    case liveCams
    case restaurants
    case barsAndPubs
    case shopping
    case entertainment
    case artsAndTheatre
    case outdoor
    case destinations
    case casinos
    case animalRescue
}

enum VenueProfileProperties:Int,Codable {
    case none
    case photos
    case promotions
    case specials
    case liveCams
    case happyHour
    case menus
    case liveMusic
    case specialEvents
}

enum WUSearchFilterID : String {
    case nearby  = "1"
    case openNow = "2"
    case LiveMusic = "3"
    case FoodCategory = "4"
}

class WUGlobal: NSObject {
    static let global           : WUGlobal = WUGlobal()
    var geolocationFilterData   : WUGeolocationFilterData!
    var user                    : User!
    var homeBanner              : [WUHomeBannerList] = []
    //var venueLocalPromotions    : [WUVenueLocalPromotions] = []
    var localPromotions         : WULocalPromotions?
    var appTabbarController     : WUTabbarViewController?
    var notifciationCount       : Int = 0
    var currentLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var arrayCategories         : [WUCategory]! = []
    var arraySearchFilters      : [WUSearchFilters] = [WUSearchFilters(filterId: WUSearchFilterID.nearby.rawValue,
                                                                       filterName: Text.SearchFilterNames.nearby),
                                                  WUSearchFilters(filterId: WUSearchFilterID.openNow.rawValue,
                                                                  filterName: Text.SearchFilterNames.openNow),
                                                  WUSearchFilters(filterId: WUSearchFilterID.LiveMusic.rawValue,
                                                                  filterName: Text.SearchFilterNames.LiveMusic),
                                                  WUSearchFilters(filterId: WUSearchFilterID.FoodCategory.rawValue,
                                                                  filterName: Text.SearchFilterNames.FoodCategory)]
    var deviceToken : String = ""
}
