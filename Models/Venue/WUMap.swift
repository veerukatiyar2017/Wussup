//
//  WUMap.swift
//  Wussup
//
//  Created by MAC219 on 7/5/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import MapKit

class WUMap : NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String!
    
//    var VenueName           : String                = ""
//    var VenueCity           : String                = ""
//    var VenueState          : String                = ""
//    var VenueCountry        : String                = ""
//    var VenuePostCode       : String                = ""
//    var VenueDistance       : String                = ""
//    var VenueAddress        : String                = ""
//    var VenueLattitude      : String                = ""
//    var VenueLongitude      : String                = ""
//    var MapPinImageUrl      : String                = ""
   
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
